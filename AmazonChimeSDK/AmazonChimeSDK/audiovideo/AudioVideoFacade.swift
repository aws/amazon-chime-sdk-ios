//
//  AudioVideoFacade.swift
//  AmazonChimeSDK
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

import Foundation

@objc public protocol AudioVideoFacade: AudioVideoControllerFacade, RealtimeControllerFacade,
    DeviceController, VideoTileControllerFacade, ActiveSpeakerDetectorFacade {}
