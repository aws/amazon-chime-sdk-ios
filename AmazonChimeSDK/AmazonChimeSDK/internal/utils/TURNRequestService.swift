//
//  TURNRequestService.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation
import UIKit

@objcMembers public class TURNRequestService: NSObject {
    private static let contentTypeHeader = "Content-Type"
    private static let contentType = "application/json"
    private static let userAgentTypeHeader = "User-Agent"
    private static let meetingIdKey = "meetingId"
    private static let tokenHeader = "X-Chime-Auth-Token"
    private static let tokenKey = "_aws_wt_session"
    private static let turnRequestHttpMethod = "POST"

    static func postTURNRequest(meetingId: String,
                                turnControlUrl: String,
                                joinToken: String,
                                logger: Logger,
                                completion: @escaping (MeetingSessionTURNCredentials?) -> Void) {
        guard let turnRequest = constructTURNRequest(meetingId: meetingId,
                                                     turnControlUrl: turnControlUrl,
                                                     joinToken: joinToken) else {
            logger.error(msg: "Failed to construct TURN request")
            completion(nil)
            return
        }
        let session = URLSession(configuration: .default)
        session.dataTask(with: turnRequest) { data, resp, error in
            if let error = error {
                logger.error(msg: "Failed to make TURN request, error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let httpResponse = resp as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    logger.error(msg: "Received status code \(httpResponse.statusCode) when making TURN request")
                    completion(nil)
                    return
                }
            }
            if let turnCredentials = processTurnResponse(data: data) {
                completion(turnCredentials)
            } else {
                logger.error(msg: "Failed to decode TURN response")
                completion(nil)
            }
        }.resume()
    }

    private static func constructTURNRequest(meetingId: String,
                                             turnControlUrl: String,
                                             joinToken: String) -> URLRequest? {
        guard let serverUrl = URL(string: turnControlUrl) else {
            return nil
        }
        var request = URLRequest(url: serverUrl)
        request.httpMethod = turnRequestHttpMethod
        request.addValue("\(tokenKey)=\(joinToken)", forHTTPHeaderField: tokenHeader)
        request.addValue(contentType, forHTTPHeaderField: contentTypeHeader)
        request.addValue(getUserAgent(), forHTTPHeaderField: userAgentTypeHeader)

        // Write meetingId into HTTP request body
        let meetingIdDict = [meetingIdKey: meetingId]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: meetingIdDict)
        } catch {
            return nil
        }
        return request
    }

    private static func processTurnResponse(data: Data?) -> MeetingSessionTURNCredentials? {
        guard let data = data else { return nil }
        let jsonDecoder = JSONDecoder()
        do {
            let turnCredentials: MeetingSessionTURNCredentials = try jsonDecoder.decode(
                MeetingSessionTURNCredentials.self, from: data
            )
            return turnCredentials
        } catch {
            return nil
        }
    }

    private static func getUserAgent() -> String {
        let model = UIDevice.current.model
        let systemVersion = UIDevice.current.systemVersion
        let scaleFactor = UIScreen.main.scale
        let defaultAgent = "(\(model); iOS \(systemVersion); Scale/\(String(format: "%.2f", scaleFactor)))"
        if let dict = Bundle.main.infoDictionary {
            if let identifier = dict[kCFBundleExecutableKey as String] ?? dict[kCFBundleIdentifierKey as String],
                let version = dict[kCFBundleVersionKey as String] {
                return "\(identifier)/\(version) \(defaultAgent)"
            }
        }
        return defaultAgent
    }
}
