//
//  BackoffRetry.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier-> Apache-2.0
//

import Foundation

protocol BackoffRetry {
    func calculateBackOff() -> Int
    func getRetryCount() -> Int
    func isRetryCountLimitReached() -> Bool
    func incrementRetryCount()
    func isRetryableCode(responseCode: Int) -> Bool
}
