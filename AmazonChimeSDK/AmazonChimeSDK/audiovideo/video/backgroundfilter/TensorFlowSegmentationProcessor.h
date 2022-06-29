//
//  TensorFlowSegmentationProcessor.h
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

#ifndef TENSOR_FLOW_SEGMENTATION_PROCESSOR_H
#define TENSOR_FLOW_SEGMENTATION_PROCESSOR_H

#import <Foundation/Foundation.h>
#import "SegmentationProcessor.h"

@interface TensorFlowSegmentationProcessor : NSObject <SegmentationProcessor>

+ (BOOL) isAvailable;

- (BOOL) initialize:(NSInteger)height width:(NSInteger)width channels:(NSInteger)channels;

- (BOOL) predict;

- (NSInteger) getModelState;

- (uint8_t* _Nonnull) getInputBuffer;

- (uint8_t* _Nonnull) getOutputBuffer;

@end // TensorFlowSegmentationProcessor

#endif  // TENSOR_FLOW_SEGMENTATION_PROCESSOR_H
