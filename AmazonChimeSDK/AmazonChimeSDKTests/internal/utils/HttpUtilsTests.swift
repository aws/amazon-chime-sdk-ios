//
//  HttpUtilsTests.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@testable import AmazonChimeSDK
import Mockingbird
import XCTest

let url = "https://example.com"

class HttpUtilsTests: XCTestCase {
    func testPostShouldReturnErrorIfURLSessionReturnError() {
        HttpUtils.post(url: url, jsonData: nil, logger: nil, urlSession: URLSessionMockErrorImp(), completion: { data, error in
            XCTAssertNotNil(error)
        })
    }

    func testPostShouldReturn400IfURLSEssionReturn400() {
        HttpUtils.post(url: url, jsonData: nil, logger: nil, urlSession: URLSessionMock400Imp(), completion: { _, error in
            if let error = error {
                XCTAssertEqual(400, (error as NSError).code)
            } else {
                XCTFail("Error null")
            }
        })
    }

    func testPostShouldReturn200IfURLSessionReturn200() {
        HttpUtils.post(url: url, jsonData: nil, logger: nil, urlSession: URLSessionMock200Imp(), completion: {data, error in
            XCTAssertNil(error)
        })
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}

class URLSessionMock400Imp: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, HTTPURLResponse(url: URL(string: url)!, statusCode: 400, httpVersion: "2.0", headerFields: nil), nil)
        return URLSessionDataTaskMock {}
    }
}

class URLSessionMock200Imp: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, HTTPURLResponse(url: URL(string: url)!, statusCode: 200, httpVersion: "2.0", headerFields: nil), nil)
        return URLSessionDataTaskMock {}
    }
}

class URLSessionMockErrorImp: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(nil, HTTPURLResponse(url: URL(string: url)!, statusCode: 500, httpVersion: "2.0", headerFields: nil), nil)
        return URLSessionDataTaskMock {}
    }
}
