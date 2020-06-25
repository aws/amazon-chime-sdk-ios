
//
//  MetricsDictionary.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import Foundation

class MetricsDictionary {
    private var dict = [String: Int]()

    func update(dict: [AnyHashable: Any]) {
        for key in dict.keys {
            if let key = key as? ObservableMetric {
                self.dict[key.description] = dict[key] as? Int ?? 0
            }
        }
    }

    func getCount() -> Int {
        return dict.count
    }

    func getMetricsName(index: Int) -> String {
        return Array(dict.keys).sorted(by: <)[index]
    }

    func getMetricsValue(index: Int) -> String {
        let key = getMetricsName(index: index)
        return String(dict[key] ?? 0)
    }
}
