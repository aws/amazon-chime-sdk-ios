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
                                   completion: @escaping CompletionFunc,
                                   jsonData: Data? = nil,
                                   logger: Logger? = nil) {
        makeHttpRequest(url: url, method: "post", completion: completion, jsonData: jsonData, logger: logger)
    }

    public static func getRequest(url: String, completion: @escaping CompletionFunc, logger: Logger? = nil) {
        makeHttpRequest(url: url, method: "get", completion: completion, jsonData: nil, logger: logger)
    }

    private static func makeHttpRequest(url: String, method: String,
                                        completion: @escaping CompletionFunc, jsonData: Data?, logger: Logger?) {
        guard let serverUrl = URL(string: url) else {
            logger?.error(msg: "Unable to parse Url please make sure check Url")
            return
        }

        var request = URLRequest(url: serverUrl)
        request.httpMethod = method

        if let data = jsonData, method.lowercased() == "post" {
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
