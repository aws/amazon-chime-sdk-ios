//
//  ToastView.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

final class ToastView: PaddingLabel {
    
    static let defaultDuration = 2.0
    
    private let autoDismissAnimationDuration = 1.0
    private let dismissAnimationDuration = 0.2
    private let dismissAnimationDelay = 0.0
    private let paddingTop = 32.0
    private let paddingBottom = 32.0
    private let widthMultiplier = 0.78
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.numberOfLines = 0
        self.isUserInteractionEnabled = false
        self.textAlignment = .center
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                self.backgroundColor = .darkGray
            } else {
                self.backgroundColor = .lightGray
            }
        } else {
            self.backgroundColor = .lightGray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(_ message: String,
              inView parentView: UIView,
              duration: TimeInterval,
              position: ToastPosition) {
        self.text = message
        parentView.addSubview(self)
        self.setupConstraints(position)
        parentView.bringSubviewToFront(self)
        self.dismiss(duration: autoDismissAnimationDuration,
                     delay: duration)
    }
    
    func dismiss() {
        self.dismiss(duration: dismissAnimationDuration,
                     delay: dismissAnimationDelay)
    }
    
    private func setupConstraints(_ position: ToastPosition) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let superview = self.superview {
            self.widthAnchor.constraint(lessThanOrEqualTo: superview.widthAnchor,
                                        multiplier: self.widthMultiplier).isActive = true
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
            switch position {
            case .top:
                self.topAnchor.constraint(equalTo: superview.topAnchor,
                                          constant: self.paddingTop).isActive = true
            case .center:
                self.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
            case .bottom:
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor,
                                             constant: -self.paddingBottom).isActive = true
            }
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private func dismiss(duration: TimeInterval,
                         delay: TimeInterval) {
        self.layer.removeAllAnimations()
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: .curveEaseOut) {
            self.alpha = 0
        } completion: { isComplete in
            if isComplete {
                 self.removeFromSuperview()
            }
        }
    }
}
