//
//  MeetingModule.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import AVFoundation
import UIKit

let incomingCallKitDelayInSeconds = 10.0

class MeetingModule {
    private static var sharedInstance: MeetingModule?
    private(set) var activeMeeting: MeetingModel?
    private let meetingPresenter = MeetingPresenter()
    private var meetings: [UUID: MeetingModel] = [:]
    private let logger = ConsoleLogger(name: "MeetingModule")

    static func shared() -> MeetingModule {
        if sharedInstance == nil {
            sharedInstance = MeetingModule()

            // This is to initialize CallKit properly before requesting first outgoing/incoming call
            _ = CallKitManager.shared()
        }
        return sharedInstance!
    }

    func prepareMeeting(meetingId: String, selfName: String, option: CallKitOption, completion: @escaping (Bool) -> Void) {

        requestRecordPermission { success in
            guard success else {
                completion(false)
                return
            }
            JoinRequestService.postJoinRequest(meetingId: meetingId, name: selfName) { meetingSessionConfig in
                guard let meetingSessionConfig = meetingSessionConfig else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                let meetingModel = MeetingModel(meetingSessionConfig: meetingSessionConfig,
                                                meetingId: meetingId,
                                                selfName: selfName,
                                                callKitOption: option)
                self.meetings[meetingModel.uuid] = meetingModel

                switch option {
                case .incoming:
                    guard let call = meetingModel.call else {
                        completion(false)
                        return
                    }
                    let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + incomingCallKitDelayInSeconds) {
                        CallKitManager.shared().reportNewIncomingCall(with: call)
                        UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
                    }
                case .outgoing:
                    guard let call = meetingModel.call else {
                        completion(false)
                        return
                    }
                    CallKitManager.shared().startOutgoingCall(with: call)
                case .disabled:
                    DispatchQueue.main.async { [weak self] in
                        self?.joinMeeting(meetingModel, completion: completion)
                    }
                }
                completion(true)
            }
        }
    }

    func joinMeeting(_ meeting: MeetingModel, completion: @escaping (Bool) -> Void) {
        endActiveMeeting {
            self.meetingPresenter.showMeetingView(meetingModel: meeting) { success in
                if success {
                    self.activeMeeting = meeting
                }
                completion(success)
            }
        }
    }

    func getMeeting(with uuid: UUID) -> MeetingModel? {
        return meetings[uuid]
    }

    func endActiveMeeting(completion: @escaping () -> Void) {
        if let activeMeeting = activeMeeting {
            activeMeeting.endMeeting()
            meetingPresenter.dismissActiveMeetingView {
                self.meetings[activeMeeting.uuid] = nil
                self.activeMeeting = nil
                completion()
            }
        } else {
            completion()
        }
    }

    func dismissMeeting(_ meeting: MeetingModel) {
        if let activeMeeting = activeMeeting, meeting.uuid == activeMeeting.uuid {
            meetingPresenter.dismissActiveMeetingView(completion: {})
            meetings[meeting.uuid] = nil
            self.activeMeeting = nil
        } else {
            meetings[meeting.uuid] = nil
        }
    }

    func requestRecordPermission(completion: @escaping (Bool) -> Void) {
        let audioSession = AVAudioSession.sharedInstance()
        switch audioSession.recordPermission {
        case .denied:
            logger.error(msg: "User did not grant audio permission, it should redirect to Settings")
            completion(false)
        case .undetermined:
            audioSession.requestRecordPermission { granted in
                if granted {
                    completion(true)
                } else {
                    self.logger.error(msg: "User did not grant audio permission")
                    completion(false)
                }
            }
        case .granted:
            completion(true)
        @unknown default:
            logger.error(msg: "Audio session record permission unknown case detected")
            completion(false)
        }
    }

    func requestVideoPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied, .restricted:
            logger.error(msg: "User did not grant video permission, it should redirect to Settings")
            completion(false)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if authorized {
                    completion(true)
                } else {
                    self.logger.error(msg: "User did not grant video permission")
                    completion(false)
                }
            }
        case .authorized:
            completion(true)
        @unknown default:
            logger.error(msg: "AVCaptureDevice authorizationStatus unknown case detected")
            completion(false)
        }
    }
}
