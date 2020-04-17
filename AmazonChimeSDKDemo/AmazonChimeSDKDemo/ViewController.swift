//
//  ViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import AVFoundation
import UIKit
import Toast

class ViewController: UIViewController {
    var meetingID = ""
    var name = ""
    let logger = ConsoleLogger(name: "ViewController")

    @IBOutlet var meetingIDText: UITextField!
    @IBOutlet var nameText: UITextField!
    @IBOutlet var joinButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func joinMeeting(sender: UIButton) {
        meetingID = meetingIDText.text ?? ""
        name = nameText.text ?? ""

        postRequest(completion: { data, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.view.makeToast("Unable to join meeting please try different meeting ID", duration: 2.0)
                }
                return
            }

            if let data = data {
                let (meetingResp, attendeeResp) = self.processJson(data: data)
                guard let currentMeetingResponse = meetingResp, let currentAttendeeResponse = attendeeResp else {
                    return
                }
                let meetingSessionConfig = MeetingSessionConfiguration(createMeetingResponse: currentMeetingResponse,
                                                                       createAttendeeResponse: currentAttendeeResponse)
                DispatchQueue.main.async {
                    let meetingView = UIStoryboard(name: "Main", bundle: nil)
                    guard let meetingViewController = meetingView.instantiateViewController(withIdentifier: "meeting")
                        as? MeetingViewController else {
                        self.logger.error(msg: "Unable to instantitateViewController")
                        return
                    }
                    meetingViewController.modalPresentationStyle = .fullScreen
                    meetingViewController.meetingSessionConfig = meetingSessionConfig
                    meetingViewController.meetingId = self.meetingID
                    meetingViewController.selfName = self.name
                    self.present(meetingViewController, animated: true, completion: nil)
                }
            }
        })
    }

    private func postRequest(completion: @escaping CompletionFunc) {
        if meetingID.isEmpty || name.isEmpty {
            DispatchQueue.main.async {
                self.view.makeToast("Given empty meetingID or name please provide those values", duration: 2.0)
            }
            return
        }

        let encodedURL = HttpUtils.encodeStrForURL(
            str: "\(AppConfiguration.url)join?title=\(meetingID)&name=\(name)&region=\(AppConfiguration.region)"
        )
        HttpUtils.postRequest(
            url: encodedURL,
            completion: completion,
            jsonData: nil, logger: logger)
    }

    private func processJson(data: Data) -> (CreateMeetingResponse?, CreateAttendeeResponse?) {
        let jsonDecoder = JSONDecoder()
        do {
            let meetingResponse = try jsonDecoder.decode(MeetingResponse.self, from: data)
            let meetingResp = CreateMeetingResponse(meeting:
                Meeting(
                    meetingId: meetingResponse.joinInfo.meeting.meetingId,
                    mediaPlacement: MediaPlacement(
                        audioFallbackUrl: meetingResponse.joinInfo.meeting.mediaPlacement.audioFallbackUrl,
                        audioHostUrl: meetingResponse.joinInfo.meeting.mediaPlacement.audioHostUrl,
                        turnControlUrl: meetingResponse.joinInfo.meeting.mediaPlacement.turnControlUrl,
                        signalingUrl: meetingResponse.joinInfo.meeting.mediaPlacement.signalingUrl
                    )
                )
            )
            let attendeeResp = CreateAttendeeResponse(attendee:
                Attendee(attendeeId: meetingResponse.joinInfo.attendee.attendeeId,
                         joinToken: meetingResponse.joinInfo.attendee.joinToken))

            return (meetingResp, attendeeResp)
        } catch {
            logger.error(msg: error.localizedDescription)
            return (nil, nil)
        }
    }
}
