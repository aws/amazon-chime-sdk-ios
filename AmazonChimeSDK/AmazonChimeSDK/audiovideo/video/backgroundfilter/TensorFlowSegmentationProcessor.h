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

// Forward declare SegmentationProcessor. This protocol is declared
// and in Swift but exposed to the Objective-C runtime. See
// SegmentationProcessor.swift for more details on the interface.
// TODO(richhx): Figure out why this doesn't work in bazel.
// For some reason, importing using apple_dynamic_framework_import
// into another library causes the SegmentationProcessor to not be
// visible, thereby causing compilation issues. As a workaround, we
// simply comment this out even though this is the recommended approach
// by Apple.
// https://developer.apple.com/documentation/swift/importing-swift-into-objective-c
// @protocol SegmentationProcessor;

@interface TensorFlowSegmentationProcessor : NSObject

+ (BOOL) isAvailable;

- (BOOL) initializeWithHeight:(NSInteger)height width:(NSInteger)width channels:(NSInteger)channels;

- (BOOL) predict;

- (NSInteger) getModelState;

- (uint8_t* _Nonnull) getInputBuffer;

- (uint8_t* _Nonnull) getOutputBuffer;

@end // TensorFlowSegmentationProcessor

#endif  // TENSOR_FLOW_SEGMENTATION_PROCESSOR_H
