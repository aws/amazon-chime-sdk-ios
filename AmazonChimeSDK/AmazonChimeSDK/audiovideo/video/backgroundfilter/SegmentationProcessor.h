//
//  SegmentationProcessor.h
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

#ifndef SEGMENTATION_PROCESSOR_H
#define SEGMENTATION_PROCESSOR_H

#import <Foundation/Foundation.h>

@protocol SegmentationProcessor

- (BOOL) initialize:(NSInteger)height width:(NSInteger)width channels:(NSInteger)channels;

- (BOOL) predict;

- (NSInteger) getModelState;

- (uint8_t* _Nonnull) getInputBuffer;

- (uint8_t* _Nonnull) getOutputBuffer;

@end // SegmentationProcessor

#endif  // SEGMENTATION_PROCESSOR_H
