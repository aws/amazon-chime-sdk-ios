//
//  StringExtension.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

extension String {
    
    /// Validate if the string is empty or contains only blank spaces
    ///
    /// - Returns: `true` if empty or blank, otherwise `false`.
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
