//
//  ViewControllerExtension.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

extension UIViewController {
    func setupHideKeyboardOnTap() {
        view.addGestureRecognizer(dismissKeyboardRecognizer())
    }

    private func dismissKeyboardRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: view, action: #selector(view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
