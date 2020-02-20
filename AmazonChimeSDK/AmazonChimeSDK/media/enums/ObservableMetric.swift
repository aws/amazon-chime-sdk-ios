//
//  ObservableMetric.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

// ObservableMetric types are filtered from the various
// metrics emitted by the underlying native clients
public enum ObservableMetric {
    case audioPacketsReceivedFractionLoss
    case audioPacketsSentFractionLoss
}
