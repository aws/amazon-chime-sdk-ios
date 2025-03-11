//
//  IngestionConfigurationBuilder.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// `IngestionConfigurationBuilder` helps to create `IngestionConfiguration`
/// by providing builder pattern.
@objcMembers public class IngestionConfigurationBuilder: NSObject {
    private var flushSize: Int = 20
    private var flushIntervalMs: Int64 = 5000
    private var retryCountLimit: Int = 2

    public override init() {}

    public func setFlushSize(flushSize: Int) -> IngestionConfigurationBuilder {
        self.flushSize = flushSize
        return self
    }

    public func setFlushIntervalMs(flushIntervalMs: Int64) -> IngestionConfigurationBuilder {
        self.flushIntervalMs = flushIntervalMs
        return self
    }

    public func setRetryCountLimit(retryCountLimit: Int) -> IngestionConfigurationBuilder {
        self.retryCountLimit = retryCountLimit
        return self
    }

    public func build(disabled: Bool = false,
                      ingestionUrl: String,
                      clientConiguration: EventClientConfiguration) -> IngestionConfiguration {
        return IngestionConfiguration(clientConfiguration: clientConiguration,
                                      ingestionUrl: ingestionUrl,
                                      disabled: disabled,
                                      flushSize: flushSize,
                                      flushIntervalMs: flushIntervalMs,
                                      retryCountLimit: retryCountLimit)
    }
}
