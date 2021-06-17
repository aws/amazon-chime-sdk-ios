//
//  DefaultEventSender.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers class DefaultEventSender: EventSender {
    private let ingestionConfiguration: IngestionConfiguration
    private let logger: Logger
    // 408: Request Timeout
    // 429: Too many request
    // 500: Internal Server Error
    // 502: Bad Gateway
    // 503: Service Unavailable
    // 504: Gateway timeout
    private let retryableStatusSet: Set = [408, 429, 500, 502, 503, 504]
    init(ingestionConfiguration: IngestionConfiguration, logger: Logger) {
        self.ingestionConfiguration = ingestionConfiguration
        self.logger = logger
    }

    func sendEvents(ingestionRecord: IngestionRecord, completionHandler: @escaping (Bool) -> Void) {
        do {
            let encodedRecord = try JSONEncoder().encode(ingestionRecord)
            HttpUtils.post(url: ingestionConfiguration.ingestionUrl,
                           jsonData: encodedRecord,
                           logger: logger,
                           httpRetryPolicy: DefaultBackoffRetry(maxRetry: ingestionConfiguration.retryCountLimit,
                                                                   backOffInSeconds: 0,
                                                                   retryableStatusCodes: retryableStatusSet),
                           headers: ["Authorization": "Bearer \(ingestionConfiguration.clientConfiguration.eventClientJoinToken)"]) { _, error in
                if error != nil {
                    completionHandler(false)
                } else {
                    completionHandler(true)
                }
            }
        } catch {
            logger.error(msg: "Unable to encode ingestion \(error.localizedDescription)")
            completionHandler(false)
        }
    }
}
