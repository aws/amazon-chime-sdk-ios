//
//  HttpUtils.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

// Every Error is NSError
// We can obtain code from NSError as statusCode
typealias CompletionFunc = (Data?, Error?) -> Void

class HttpUtils {
    private static let tag = "HttpUtils"
    private static let domain = "AmazonChimeSDK"
    public class func post(url: String,
                           jsonData: Data? = nil,
                           logger: Logger? = nil,
                           httpRetryPolicy: BackoffRetry = DefaultBackoffRetry(),
                           headers: [String: String] = [:],
                           // https://developer.apple.com/documentation/foundation/urlsession/1409000-shared
                           urlSession: URLSessionProtocol = URLSession(configuration: .default),
                           completion: @escaping CompletionFunc) {
        makePostRequest(url: url,
                        method: .post,
                        jsonData: jsonData,
                        logger: logger,
                        headers: headers,
                        urlSession: urlSession) { data, error in
            if error == nil ||
                !httpRetryPolicy.isRetryableCode(responseCode: (error as NSError?)?.code ?? 0) ||
                httpRetryPolicy.isRetryCountLimitReached() {
                completion(data, error)
                return
            } else {
                httpRetryPolicy.incrementRetryCount()
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(httpRetryPolicy.calculateBackOff())) {
                    post(url: url, jsonData: jsonData, logger: logger, httpRetryPolicy: httpRetryPolicy, urlSession: urlSession, completion: completion)
                }
            }
        }
    }

    private class func makePostRequest(url: String,
                                       method: HttpMethod,
                                       jsonData: Data?,
                                       logger: Logger?,
                                       headers: [String: String],
                                       urlSession: URLSessionProtocol,
                                       completion: @escaping CompletionFunc)
    {
        guard let serverUrl = URL(string: url) else {
            let msg = "Invalid url parameter"
            HttpUtils.printError(logger: logger, msg: msg)
            completion(nil, NSError(domain: HttpUtils.domain, code: 0, userInfo: [
                NSLocalizedDescriptionKey: msg
            ]))
            return
        }

        var request = URLRequest(url: serverUrl)
        request.httpMethod = String(describing: method)

        if let data = jsonData, method == .post {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
            request.httpBody = data
        }

        urlSession.dataTask(with: request) { data, resp, error in
            if let error = error {
                HttpUtils.printError(logger: logger, msg: error.localizedDescription)
                completion(nil, error)
                return
            }
            guard let httpResponse = resp as? HTTPURLResponse else {
                completion(data, nil)
                return
            }

            guard 200 ... 299 ~= httpResponse.statusCode else {
                HttpUtils.printError(logger: logger, msg: "Received status code \(httpResponse.statusCode)")
                completion(nil, NSError(domain: HttpUtils.domain, code: httpResponse.statusCode, userInfo: nil))
                return
            }
            guard let data = data else {
                // No data, but no error
                completion(nil, nil)
                return
            }
            completion(data, nil)
        }.resume()
    }

    private static func printError(logger: Logger?, msg: String) {
        logger?.error(msg: "\(HttpUtils.tag): \(msg)")
    }
}
