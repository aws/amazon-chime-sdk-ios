//
//  JoinRequestService.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import Foundation

class JoinRequestService: NSObject {
    static let logger = ConsoleLogger(name: "JoiningRequestService")

    private static func urlRewriter(url: String) -> String {
        // changing url
        // return url.replacingOccurrences(of: "example.com", with: "my.example.com")
        return url
    }

    static func postJoinRequest(meetingId: String,
                                name: String,
                                overriddenEndpoint: String,
                                completion: @escaping (MeetingSessionConfiguration?) -> Void) {
        var url = overriddenEndpoint.isEmpty ? AppConfiguration.url : overriddenEndpoint
        url = url.hasSuffix("/") ? url : "\(url)/"
        let encodedURL = HttpUtils.encodeStrForURL(
            str: "\(url)join?title=\(meetingId)&name=\(name)&region=\(AppConfiguration.region)"
        )
        HttpUtils.postRequest(url: encodedURL, jsonData: nil, logger: logger) { data, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let meetingSessionConfiguration = self.processJson(data: data) else {
                completion(nil)
                return
            }
            completion(meetingSessionConfiguration)
        }
    }

    private static func processJson(data: Data) -> MeetingSessionConfiguration? {
        let jsonDecoder = JSONDecoder()
        do {
            let joinMeetingResponse = try jsonDecoder.decode(JoinMeetingResponse.self, from: data)
            let meetingResp = getCreateMeetingResponse(from: joinMeetingResponse)
            let attendeeResp = getCreateAttendeeResponse(from: joinMeetingResponse)
            return MeetingSessionConfiguration(createMeetingResponse: meetingResp,
                                               createAttendeeResponse: attendeeResp,
                                               urlRewriter: urlRewriter)
        } catch {
            logger.error(msg: error.localizedDescription)
            return nil
        }
    }

    private static func getCreateMeetingResponse(from joinMeetingResponse: JoinMeetingResponse) -> CreateMeetingResponse {
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
        return meetingResp
    }

    private static func getCreateAttendeeResponse(from joinMeetingResponse: JoinMeetingResponse) -> CreateAttendeeResponse {
        let attendee = joinMeetingResponse.joinInfo.attendee.attendee
        let attendeeResp = CreateAttendeeResponse(attendee:
            Attendee(attendeeId: attendee.attendeeId,
                     externalUserId: attendee.externalUserId,
                     joinToken: attendee.joinToken)
        )
        return attendeeResp
    }
}
