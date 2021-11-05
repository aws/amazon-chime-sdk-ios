//
//  WebappViewController.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit
import WebKit

class WebappViewController: UIViewController, WKUIDelegate {
    var webview: WKWebView!

    override func loadView() {
        webview = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webview.uiDelegate = self
        view = webview
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webview.load(URLRequest(url: URL(string: AppConfiguration.url)!))
    }
}
