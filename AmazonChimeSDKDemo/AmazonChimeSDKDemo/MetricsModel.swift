//
//  MetricsDictionary.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

class MetricsModel: NSObject {
    private var dict = [String: Int]()

    func update(dict: [AnyHashable: Any]) {
        for key in dict.keys {
            if let key = key as? ObservableMetric {
                self.dict[key.description] = dict[key] as? Int ?? 0
            }
        }
    }

    private func getMetricsName(index: Int) -> String {
        return Array(dict.keys).sorted(by: <)[index]
    }

    private func getMetricsValue(index: Int) -> String {
        let key = getMetricsName(index: index)
        return String(dict[key] ?? 0)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension MetricsModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return dict.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item >= dict.count {
            return UITableViewCell()
        }
        let metricsName = getMetricsName(index: indexPath.item)
        let metricsValue = getMetricsValue(index: indexPath.item)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: metricsTableCellReuseIdentifier) as? MetricsTableCell else {
            return MetricsTableCell(name: metricsName, value: metricsValue)
        }

        cell.updateCell(name: metricsName, value: metricsValue)

        return cell
    }
}
