//
//  HttpUtils.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import Foundation

typealias CompletionFunc = (Data?, Error?) -> Void

class HttpUtils {
    public static func postRequest(url: String,
                                   jsonData: Data? = nil,
                                   logger: Logger? = nil,
                                   completion: @escaping CompletionFunc) {
        makeHttpRequest(url: url, method: "post", jsonData: jsonData, logger: logger, completion: completion)
    }

    public static func getRequest(url: String, logger: Logger? = nil, completion: @escaping CompletionFunc) {
        makeHttpRequest(url: url, method: "get", jsonData: nil, logger: logger, completion: completion)
    }

    private static func makeHttpRequest(url: String,
                                        method: String,
                                        jsonData: Data?,
                                        logger: Logger?,
                                        completion: @escaping CompletionFunc) {
        guard let serverUrl = URL(string: url) else {
            logger?.error(msg: "Unable to parse Url please make sure check Url")
            return
        }

        var request = URLRequest(url: serverUrl)
        request.httpMethod = method

        if let data = jsonData, method.lowercased() == "post" {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
        }

        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                logger?.error(msg: error.localizedDescription)
                completion(nil, error)
                return
            }
            if let httpResponse = resp as? HTTPURLResponse {
                guard 200 ... 299 ~= httpResponse.statusCode else {
                    logger?.error(msg: "Received status code \(httpResponse.statusCode)")
                    completion(nil, NSError(domain: "", code: httpResponse.statusCode, userInfo: nil))
                    return
                }
            }
            guard let data = data else { return }
            completion(data, nil)
        }.resume()
    }

    public static func encodeStrForURL(str: String) -> String {
        return str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? str
    }
}
