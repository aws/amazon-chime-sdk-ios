//
//  DefaultBackoffRetry.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class DefaultBackoffRetry: BackoffRetry {
    private let maxRetry: Int
    private let backOffInSeconds: Int
    private let retryableStatusCodes: Set<Int>

    private var retryCount = 0
    private var multiplier = 2

    init(maxRetry: Int = 0,
         backOffInSeconds: Int = 0,
         retryableStatusCodes: Set<Int> = []) {
        self.retryableStatusCodes = retryableStatusCodes
        self.backOffInSeconds = backOffInSeconds
        self.maxRetry = maxRetry
    }

    func calculateBackOff() -> Int {
        // Making sure it does not exceed 2 hours
        return backOffInSeconds * Int(min(7200.0, max(pow(Double(multiplier), Double(retryCount)), 0.0)))
    }

    func getRetryCount() -> Int {
        return retryCount
    }

    func isRetryCountLimitReached() -> Bool {
        return maxRetry > retryCount
    }

    func incrementRetryCount() {
        retryCount += 1
    }

    func isRetryableCode(responseCode: Int) -> Bool {
        return retryableStatusCodes.isEmpty || retryableStatusCodes.contains(responseCode)
    }
}
