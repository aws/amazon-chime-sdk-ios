//
//  ViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import AVFoundation
import Toast
import UIKit

class JoiningViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var meetingIdTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var joinButton: UIButton!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var joinWithoutCallKitButton: UIButton!
    @IBOutlet var joinAsIncomingCallButton: UIButton!
    @IBOutlet var joinAsOutgoingCallButton: UIButton!

    private let logger = ConsoleLogger(name: "JoiningViewController")
    private let toastDisplayDuration = 2.0

    override func viewDidLoad() {
        super.viewDidLoad()
        meetingIdTextField.delegate = self
        nameTextField.delegate = self

        setupHideKeyboardOnTap()
        versionLabel.text = "amazon-chime-sdk-ios@\(Versioning.sdkVersion())"
    }

    override func viewWillAppear(_: Bool) {
        setJoinButtons(isEnabled: true)
    }

    private func urlRewriter(url: String) -> String {
        // changing url
        // return url.replacingOccurrences(of: "example.com", with: "my.example.com")
        return url
    }

    @IBAction func joinWithoutCallKitButtonClicked(_ sender: UIButton) {
        joinMeeting(callKitOption: .disabled)
    }

    @IBAction func joinAsIncomingCallButton(_ sender: UIButton) {
        joinMeeting(callKitOption: .incoming)
    }

    @IBAction func joinAsOutgoingCallButton(_ sender: UIButton) {
        joinMeeting(callKitOption: .outgoing)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func setJoinButtons(isEnabled: Bool) {
        joinWithoutCallKitButton.isEnabled = isEnabled
        joinAsIncomingCallButton.isEnabled = isEnabled
        joinAsOutgoingCallButton.isEnabled = isEnabled
    }

    func joinMeeting(callKitOption: CallKitOption) {
        view.endEditing(true)
        let meetingId = meetingIdTextField.text ?? ""
        let name = nameTextField.text ?? ""

        if meetingId.isEmpty || name.isEmpty {
            DispatchQueue.main.async {
                self.view.makeToast("Meeting ID or name is invalid",
                                    duration: self.toastDisplayDuration)
            }
            return
        }

        setJoinButtons(isEnabled: false)

        postRequest(meetingId: meetingId, name: name, completion: { data, error in
            guard error == nil, let data = data else {
                DispatchQueue.main.async {
                    self.view.makeToast("Unable to join meeting please try different meeting ID",
                                        duration: self.toastDisplayDuration)
                    self.setJoinButtons(isEnabled: true)
                }
                return
            }

            let (meetingResp, attendeeResp) = self.processJson(data: data)
            guard let currentMeetingResponse = meetingResp, let currentAttendeeResponse = attendeeResp else {
                self.logger.error(msg: "Unable to process meeting JSON response")
                return
            }

            let meetingSessionConfig = MeetingSessionConfiguration(createMeetingResponse: currentMeetingResponse,
                                                                   createAttendeeResponse: currentAttendeeResponse,
                                                                   urlRewriter: self.urlRewriter)

            DispatchQueue.main.async {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let meetingViewController = mainStoryboard.instantiateViewController(withIdentifier: "meeting")
                    as? MeetingViewController else {
                    self.logger.error(msg: "Unable to instantitate MeetingViewController")
                    return
                }
                meetingViewController.modalPresentationStyle = .fullScreen
                meetingViewController.meetingSessionConfig = meetingSessionConfig
                meetingViewController.meetingId = meetingId
                meetingViewController.selfName = name
                meetingViewController.callKitOption = callKitOption
                self.present(meetingViewController, animated: true, completion: nil)
            }
        })
    }

    private func postRequest(meetingId: String, name: String, completion: @escaping CompletionFunc) {
        let encodedURL = HttpUtils.encodeStrForURL(
            str: "\(AppConfiguration.url)join?title=\(meetingId)&name=\(name)&region=\(AppConfiguration.region)"
        )
        HttpUtils.postRequest(
            url: encodedURL,
            completion: completion,
            jsonData: nil, logger: logger
        )
    }

    private func processJson(data: Data) -> (CreateMeetingResponse?, CreateAttendeeResponse?) {
        let jsonDecoder = JSONDecoder()
        do {
            let joinMeetingResponse = try jsonDecoder.decode(JoinMeetingResponse.self, from: data)
            let meeting = joinMeetingResponse.joinInfo.meeting.meeting
            let meetingResp = CreateMeetingResponse(meeting:
                Meeting(
                    externalMeetingId: meeting.externalMeetingId,
                    mediaPlacement: MediaPlacement(
                        audioFallbackUrl: meeting.mediaPlacement.audioFallbackUrl,
                        audioHostUrl: meeting.mediaPlacement.audioHostUrl,
                        signalingUrl: meeting.mediaPlacement.signalingUrl,
                        turnControlUrl: meeting.mediaPlacement.turnControlUrl
                    ),
                    mediaRegion: meeting.mediaRegion,
                    meetingId: meeting.meetingId
                )
            )
            let attendee = joinMeetingResponse.joinInfo.attendee.attendee
            let attendeeResp = CreateAttendeeResponse(attendee:
                Attendee(attendeeId: attendee.attendeeId,
                         externalUserId: attendee.externalUserId,
                         joinToken: attendee.joinToken)
            )
            return (meetingResp, attendeeResp)
        } catch {
            logger.error(msg: error.localizedDescription)
            return (nil, nil)
        }
    }
}
