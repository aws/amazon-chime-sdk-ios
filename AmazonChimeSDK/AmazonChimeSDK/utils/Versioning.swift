//
//  Versioning.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//
import Foundation

@objcMembers public class Versioning: NSObject {
    /// Returns the current version of Amazon Chime SDK in the format of String.
    /// If there is an error with the version, "N/A" will be returned.
    public static func sdkVersion() -> String {
        guard let sdkVersion = Bundle(for: Versioning.self).infoDictionary?["CFBundleShortVersionString"] as? String
            else {
                return "N/A"
        }
        return sdkVersion
    }
}
