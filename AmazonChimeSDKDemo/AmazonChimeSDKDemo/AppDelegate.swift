//
//  AppDelegate.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // If app is being force killed while CallKit integrated meeting is in progress,
        // provider(_: CXProvider, perform action: CXEndCallAction) will not be called.
        // So we need to invoke isEndedHandler() directly.
        if let call = MeetingModule.shared().activeMeeting?.call {
            call.isEndedHandler?()
        } else {
            MeetingModule.shared().endActiveMeeting {}
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if let meeting = MeetingModule.shared().activeMeeting {
            meeting.isAppInBackground = true
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let meeting = MeetingModule.shared().activeMeeting {
            meeting.isAppInBackground = false
        }
    }
}
