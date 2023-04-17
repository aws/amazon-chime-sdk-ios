//
//  DeviceHelper.swift
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AVFoundation

protocol DeviceHelper {
    
    func requestAudioPermissionIfNeeded(
        _ completion: @escaping (_ error: Error?) -> Void
    )
    
    func requestCameraPermissionIfNeeded(
        _ completion: @escaping (_ error: Error?) -> Void
    )
}

class DefaultDeviceHelper: DeviceHelper {
    
    func requestAudioPermissionIfNeeded(
        _ completion: @escaping (_ error: Error?) -> Void) {
            let audioSession = AVAudioSession.sharedInstance()
            switch audioSession.recordPermission {
            case .denied:
                let error = Errors.audioPermissionDenied
                completion(error)
            case .undetermined:
                requestAudioPermission(completion)
            case .granted:
                completion(nil)
            @unknown default:
                let error = Errors.unknownAudioPermission
                completion(error)
            }
    }
    
    private func requestAudioPermission(
        _ completion: @escaping (_ error: Error?) -> Void
    ) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                completion(nil)
            } else {
                completion(Errors.audioPermissionDenied)
            }
        }
    }
    
    func requestCameraPermissionIfNeeded(
        _ completion: @escaping (_ error: Error?) -> Void
    ) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied, .restricted:
            let error = Errors.cameraPermissionDenied
            completion(error)
        case .notDetermined:
            requestCameraPermission(completion)
        case .authorized:
            completion(nil)
        @unknown default:
            let error = Errors.unknownCameraPermission
            completion(error)
        }
    }
    
    private func requestCameraPermission(
        _ completion: @escaping (_ error: Error?) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { authorized in
            if authorized {
                completion(nil)
            } else {
                completion(Errors.cameraPermissionDenied)
            }
        }
    }
}
