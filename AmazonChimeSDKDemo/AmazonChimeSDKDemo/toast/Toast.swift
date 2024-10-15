//
//  Toast.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

extension UIView {
    
    private var toasts: [UIView] {
        return self.subviews.filter { $0 is ToastView }
    }

    func makeToast(_ message: String,
                   duration: Double = ToastView.defaultDuration,
                   position: ToastPosition = .bottom) {
        let toast = ToastView(frame: CGRect.zero)
        toast.show(message, inView: self, duration: duration, position: position)
    }
    
    func hideToast() {
        self.toasts.forEach { toast in
            if let toastView = toast as? ToastView {
                toastView.dismiss()
            }
        }
    }

}
