//
//  CreateDefaultMeetingSession.swift
//  AmazonChimeSDK
//
//  Created by Wang, Haoran on 1/13/20.
//  Copyright © 2020 Amazon Chime. All rights reserved.
//

import AmazonChimeSDK
import Foundation
import UIKit

public class CreateDefaultMeetingSession {
    let url = "https://thk0xqeobd.execute-api.us-east-1.amazonaws.com/Prod/"
    let region = "us-east-1"
    var meetingID = ""
    var name = ""
    let currentViewController: UIViewController

    public init(meetingID: String, name: String, currentViewController: UIViewController) {
        self.currentViewController = currentViewController
        
        self.meetingID = formatInput(text: meetingID)
        self.name = formatInput(text: name)
        let logger = ConsoleLogger(name: "Demo")
        postRequest(logger: logger, completion: { json in
            showAlert(controller: self.currentViewController, message: "We are able to join!")
            let (meetingResp, attendeeResp) = self.processJson(json: json)
            let meetingSessionConfig = MeetingSessionConfiguration(createMeetingResponse: meetingResp,
                                                                   createAttendeeResponse: attendeeResp)
            let defaultMeetingSession = DefaultMeetingSession(configuration: meetingSessionConfig, logger: logger)
            defaultMeetingSession.audioVideo.start();
        })
    }

    private func postRequest(logger: ConsoleLogger, completion: @escaping (([String: AnyObject]) -> Void)) {
        if meetingID == "" || name == "" {
            showAlert(controller: self.currentViewController, message: "Given empty meetingID or name please provide those values")
            return
        }

        let serverUrl = URL(string: "\(url)join?title=\(meetingID)&name=\(name)&region=\(region)")

        var request = URLRequest(url: serverUrl!)
        request.httpMethod = "post"

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                showAlert(controller: self.currentViewController, message: "Unable to join the meeting")
                logger.error(msg: error as? String ?? "Error")
                return
            }

            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: [])
                    as? [String: AnyObject] else { return }
                completion(json)
            } catch {
                logger.error(msg: error as? String ?? "Error")
            }
        }.resume()
    }

    private func formatInput(text: String) -> String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+")
    }

    private func processJson(json: [String: AnyObject]) -> (CreateMeetingResponse, CreateAttendeeResponse) {
        var jsonAttendeeId: String = ""
        var jsonJoinToken: String = ""
        var jsonAudioHostUrl: String = ""
        var jsonMeetingId: String = ""

        if let joinInfo = json["JoinInfo"] as? [String: Any] {
            if let attendee = joinInfo["Attendee"] as? [String: String] {
                jsonAttendeeId = attendee["AttendeeId"]!
                jsonJoinToken = attendee["JoinToken"]!
            }
            if let meeting = joinInfo["Meeting"] as? [String: Any] {
                jsonMeetingId = (meeting["MeetingId"] as? String)!
                if let mediaPlacement = meeting["MediaPlacement"] as? [String: String] {
                    jsonAudioHostUrl = mediaPlacement["AudioHostUrl"]!
                }
            }
        }

        let meetingResp = CreateMeetingResponse(meeting:
            Meeting(meetingId: jsonMeetingId, mediaPlacement: MediaPlacement(audioHostURL: jsonAudioHostUrl)))
        let attendeeResp = CreateAttendeeResponse(attendee:
            Attendee(attendeeId: jsonAttendeeId, joinToken: jsonJoinToken))

        return (meetingResp, attendeeResp)
    }
}
