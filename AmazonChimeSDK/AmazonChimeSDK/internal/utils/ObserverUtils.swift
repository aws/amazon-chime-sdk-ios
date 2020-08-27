//
//  ObserverUtils.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

@objcMembers class ObserverUtils: NSObject {
    public static func forEach<T>(
        observers: ConcurrentMutableSet,
        observerFunction: @escaping (_ observer: T) -> Void
    ) {
        DispatchQueue.main.async {
            observers.forEach { observer in
                if let observer = observer as? T {
                    observerFunction(observer)
                }
            }
        }
    }
}
