//
//  MeetingObserverWeakReference.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

class MeetingObserverWeakReference {
    weak var value: MeetingObserver?
      
    init (_ value: MeetingObserver) {
      self.value = value
    }
}
