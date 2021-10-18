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
    static let deviceModel = getModelInfo()
    static let manufacturer = "Apple"
    static let deviceName = "\(manufacturer) \(deviceModel)"
    static let sdkName = "amazon-chime-sdk-ios"
    static let sdkVersion = Versioning.sdkVersion()
    static let osName = "iOS"
    static let osVersion = UIDevice.current.systemVersion
    static let mediaSDKVersion = mediaLibInfo()

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
        let info = getAppInfo()
        var appInfo = app_detailed_info_t.init()

        if (Bundle.main.infoDictionary?["CFBundleShortVersionString"]) != nil {
            appInfo.app_name = UnsafePointer<Int8>((info.appName as NSString).utf8String)
            appInfo.app_version = UnsafePointer<Int8>((info.appVersion as NSString).utf8String)
        }
        appInfo.device_make = UnsafePointer<Int8>((info.deviceMake as NSString).utf8String)
        appInfo.device_model = UnsafePointer<Int8>((info.deviceModel as NSString).utf8String)
        appInfo.platform_name = UnsafePointer<Int8>((info.platformName as NSString).utf8String)
        appInfo.platform_version = UnsafePointer<Int8>((info.platformVersion as NSString).utf8String)
        appInfo.client_source = UnsafePointer<Int8>((info.clientSource as NSString).utf8String)
        appInfo.chime_sdk_version = UnsafePointer<Int8>((info.chimeSdkVersion as NSString).utf8String)
        return appInfo
    }

    static public func getAppInfo() -> AppInfo {
        let appInfo = AppInfo()

        appInfo.platformVersion = UIDevice.current.systemVersion
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] {
            appInfo.appName = "\(osName)"
            appInfo.appVersion = "\(appVersion)"
        }
        appInfo.deviceModel = getModelInfo()
        appInfo.platformName = osName
        appInfo.deviceMake = "apple"
        appInfo.clientSource = "amazon-chime-sdk"
        appInfo.chimeSdkVersion = Versioning.sdkVersion()
        return appInfo
    }

    private static func mediaLibInfo() -> String {
        if  let infos = Bundle(for: AudioClient.self).infoDictionary,
            let version = infos[kCFBundleVersionKey as String] {
            return version as? String ?? "unknown"
        }
        return "unknown"
    }
}
