//
//  TensorFlowSegmentationProcessor.m
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

#import <AmazonChimeSDK/AmazonChimeSDK-Swift.h>
#import "TensorFlowSegmentationProcessor.h"
#import "CwtEnum.h"
#import "CwtTfLiteModel.h"

// TensorFlowSegmentationProcessor is a wrapper class around AmazonChimeSDKMachineLearning
// frameworks's implementation of CwtTfLiteModel, which is a TensorFlow Lite
// implementation of a segmentation processor. Note that users of this class must
// check `isAvailable` before using this processor. See `isAvailable` for more
// details.
@implementation TensorFlowSegmentationProcessor {
    CwtTfLiteModel* _model;
    NSInteger _modelState;
}

// getModelFromBundle returns the path to the segmentation model.
+ (NSString*) getModelFromBundle {
    NSString* bundle = [[NSBundle bundleForClass:TensorFlowSegmentationProcessor.class]
                        pathForResource:@"selfie_segmentation_landscape" ofType:@"tflite"];
    return bundle;
}

// isAvailable returns YES if AmazonChimeSDKMachineLearning framework (i.e.
// CwtTfLiteModel class symbol) is available in the runtime. Returns NO
// otherwise. If AmazonChimeSDKMachineLearning is not available, all methods
// in this class are unusable. Callers must guard the usage of this class
// with a check to `isAvailable` first.
+ (BOOL) isAvailable {
    Class clazz = NSClassFromString(@"CwtTfLiteModel");
    if (clazz == nil) {
        return NO;
    }
    NSString* bundle = [TensorFlowSegmentationProcessor getModelFromBundle];
    if (!bundle) {
        NSLog(@"Unable to find selfie segmentation model");
        return NO;
    }
    return YES;
}

// init instantiates the segmentation processor.
- (id) init {
    _model = [[NSClassFromString(@"CwtTfLiteModel") alloc] init];;
    _modelState = EMPTY;
    return self;
}

// initialize instantiates the model for the segmentation processor.
// Returns whether able to successfully initialize.
- (BOOL) initializeWithHeight:(NSInteger)height width:(NSInteger)width channels:(NSInteger)channels {
    NSString* bundle = [TensorFlowSegmentationProcessor getModelFromBundle];
    if (!bundle) {
        NSLog(@"Unable to find selfie segmentation model");
        return NO;
    }

    // Initialize parameters to load model.
    NSString* path = [[NSURL fileURLWithPath:bundle] path];
    CwtInputModelConfig modelConfig;
    modelConfig.in_height = (int)height;
    modelConfig.in_width = (int)width;
    modelConfig.in_channels = (int)channels;
    modelConfig.model_range_min = 0;
    modelConfig.model_range_max = 1;

    // Get the method signature and create an invocation of it.
    SEL selector = NSSelectorFromString(@"loadFile:config:");
    NSMethodSignature* methodSignature = [_model methodSignatureForSelector:selector];
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setTarget:_model];
    [invocation setSelector:selector];

    // Invoke the method.
    [invocation setArgument:&path atIndex:2];
    [invocation setArgument:&modelConfig atIndex:3];
    [invocation retainArguments];
    [invocation invoke];

    // Get the result.
    NSInteger result;
    [invocation getReturnValue:&result];
    _modelState = result;
    return _modelState == LOADED;
}

// Calls the model to predict the foreground on the image stored in
// `[model getInputBuffer]`. Returns YES if succeeded. NO otherwise.
- (BOOL) predict {
    CwtPredictResult result = [_model predict];
    return result == SUCCESS;
}

// Returns the integer representation of the model's currently
// loaded state.
// 0 = EMPTY
// 1 = LOADING
// 2 = LOADED
- (NSInteger) getModelState {
    return _modelState;
}

// Returns a direct pointer to the input buffer used to store the image data
// that we be predicted.
- (uint8_t* _Nonnull) getInputBuffer {
    return [_model getInputBuffer];
}

// Returns a direct pointer to the output buffer of the predicted image.
- (uint8_t* _Nonnull) getOutputBuffer {
    return [_model getOutputBuffer];
}

@end  // TensorFlowSegmentationProcessor
