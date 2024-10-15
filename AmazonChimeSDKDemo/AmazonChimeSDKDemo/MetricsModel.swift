//
//  MetricsDictionary.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDK
import UIKit

let userDefaultsKeyBroadcastMetrics = "demoMeetingBroadcastMetrics"

class MetricsModel: NSObject {
    let appGroupUserDefaults = UserDefaults(suiteName: AppConfiguration.appGroupId)
    var userDefaultsObserver: NSKeyValueObservation?

    private var appMetrics = [String: Double]()
    private var broadcastMetrics = [String: Double]()
    private var combinedMetrics: [String: Double] {
        return appMetrics.merging(broadcastMetrics) { (metric, _) in metric }
    }

    var metricsUpdatedHandler: (() -> Void)?

    override init() {
        super.init()

        // Since Broadcast Extension runs independently from Demo app, Metrics from Broadcasting does not
        // automatically flow into the app. So we are saving these metrics from Broadcast Extension into
        // shared App Groups User Defaults, observe and retrieve them in MetricsModel to display in demo app.
        userDefaultsObserver = appGroupUserDefaults?.observe(\.demoMeetingBroadcastMetrics,
                                                 options: [.new, .old]) { [weak self] (_, _) in
            if let strongSelf = self,
               let userDefaults = strongSelf.appGroupUserDefaults,
               let broadcastMetrics = userDefaults.demoMeetingBroadcastMetrics {
                strongSelf.broadcastMetrics = broadcastMetrics
            } else {
                self?.broadcastMetrics = [:]
            }
            self?.metricsUpdatedHandler?()
        }
    }

    deinit {
        userDefaultsObserver?.invalidate()
    }

    func updateAppMetrics(metrics: [AnyHashable: Any]) {
        self.appMetrics = [:]
        for key in metrics.keys {
            if let key = key as? ObservableMetric {
                self.appMetrics[key.description] = metrics[key] as? Double ?? 0
            }
        }
    }

    private func getMetricsName(index: Int) -> String {
        return Array(combinedMetrics.keys).sorted(by: <)[index]
    }

    private func getMetricsValue(index: Int) -> String {
        let key = getMetricsName(index: index)
        return String(combinedMetrics[key] ?? 0)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension MetricsModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return combinedMetrics.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item >= combinedMetrics.count {
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

extension UserDefaults {
    @objc dynamic var demoMeetingBroadcastMetrics: [String: Double]? {
        return object(forKey: userDefaultsKeyBroadcastMetrics) as? [String: Double]
    }
}
