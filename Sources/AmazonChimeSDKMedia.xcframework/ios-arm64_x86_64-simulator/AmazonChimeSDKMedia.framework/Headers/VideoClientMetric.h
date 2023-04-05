//
//  VideoClientMetric.h
//  AmazonChimeSDKMedia
//
//  Copyright (c) 2020 Amazon, Inc. All rights reserved.
//

typedef NS_ENUM(NSUInteger, VideoClientMetric) {
    videoAvailableSendBandwidth,
    videoAvailableReceiveBandwidth,
    videoSendBitrate,
    videoSendPacketLossPercent,
    videoSendFps,
    videoSendRttMs,
    videoReceiveBitrate,
    videoReceivePacketLossPercent,
};
