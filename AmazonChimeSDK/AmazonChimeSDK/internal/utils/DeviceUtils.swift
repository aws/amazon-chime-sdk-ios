//
//  DeviceUtils.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import AmazonChimeSDKMedia
import Foundation
import UIKit

@objcMembers public class DeviceUtils: NSObject {
    static public func getModelInfo() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }

    static public func getDetailedInfo() -> app_detailed_info_t {
        var appInfo = app_detailed_info_t.init()

        appInfo.platform_version = UnsafePointer<Int8>((UIDevice.current.systemVersion as NSString).utf8String)
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            appInfo.app_version_name = UnsafePointer<Int8>(("iOS \(appVersion)" as NSString).utf8String)
            appInfo.app_version_code = UnsafePointer<Int8>(("\(appVersion)" as NSString).utf8String)
        }
        appInfo.device_model = UnsafePointer<Int8>((getModelInfo() as NSString).utf8String)
        appInfo.platform_name = UnsafePointer<Int8>(("iOS" as NSString).utf8String)
        appInfo.device_make = UnsafePointer<Int8>(("apple" as NSString).utf8String)
        appInfo.client_source = UnsafePointer<Int8>(("amazon-chime-sdk" as NSString).utf8String)
        appInfo.chime_sdk_version = UnsafePointer<Int8>((Versioning.sdkVersion() as NSString).utf8String)
        return appInfo
    }
}
