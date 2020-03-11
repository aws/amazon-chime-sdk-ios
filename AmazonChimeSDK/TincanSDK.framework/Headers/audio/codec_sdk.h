//
//  codec_sdk.h
//  AudioClient
//
//  Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

typedef enum
{
    kCodecUnknown = 0,
    kCodecMuLaw16KHz = 1,
    kCodecPCM16KHz16bit,
    kCodecPCM8KHz16bit,
    kCodecSpeexNarrowband,
    kCodecSpeexWideband,
    kCodecOpusLow,
    kCodecOpusMedium,
    kCodecOpusHigh,
    kCodecMuLaw8KHz,
    kCodecG722,
    kCodecOpus48KHz,
} codec_mode_t;
