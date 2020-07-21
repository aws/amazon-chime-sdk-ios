//
//  MeetingModule.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

let incomingCallKitDelayInSeconds = 10.0

class MeetingModule {
    private static var sharedInstance: MeetingModule?
    private(set) var activeMeeting: MeetingModel?
    private let meetingPresenter = MeetingPresenter()
    private var meetings: [UUID: MeetingModel] = [:]

    static func shared() -> MeetingModule {
        if sharedInstance == nil {
            sharedInstance = MeetingModule()
        }
        return sharedInstance!
    }

    func prepareMeeting(meetingId: String, selfName: String, option: CallKitOption, completion: @escaping (Bool) -> Void) {
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
                DispatchQueue.main.async {
                    self.joinMeeting(meetingModel, completion: completion)
                }
            }
            completion(true)
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
        } else {
            meetings[meeting.uuid] = nil
        }
    }
}
