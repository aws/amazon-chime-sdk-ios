//
//  VideoClientMetric.h
//  MediaClient
//
//  Copyright (c) 2020 Amazon, Inc. All rights reserved.
//

typedef NS_ENUM(NSUInteger, VideoClientMetric) {
    videoAvailableSendBandwidth,
    videoAvailableReceiveBandwidth,
    videoSendBitrate,
    videoSendPacketLostPercent,
    videoSendFps,
    videoReceiveBitrate,
    videoReceivePacketLostPercent,
};
