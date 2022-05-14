//
//  CwtTfLiteModel.h
//  cwt
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

#ifndef CWT_TF_LITE_MODEL_H
#define CWT_TF_LITE_MODEL_H

#include "CwtEnum.h"

// CwtTfLiteModel represents a wrapper around TFLiteModel for the ChimeAIWebToolkit.
@interface CwtTfLiteModel : NSObject

// state is the runtime status of the model.
@property (atomic, readonly) CwtModelState state;

// loadFile synchronously loads the given tflite model based on the absolute
// file path and given configuration. Returns the state of the model after
// loading.
- (CwtModelState) loadFile:(NSString*)path config:(CwtInputModelConfig)config;

// loadBytes synchronously loads the given tflite model based on the given
// bytes and given configuration. Returns the state of the model after
// loading.
- (CwtModelState) loadBytes:(uint8_t*)buffer length:(NSInteger)length config:(CwtInputModelConfig)config;

// predict runs the model inference. Model inputs must have been set via
// getInputBuffer(). Model outputs can be retrieved via getOutputBuffer().
// Returns a non-zero value if failed to predict.
- (CwtPredictResult) predict;

// getInputBuffer returns a buffer than can be used to set the tensor inputs
// for the tflite model.
- (uint8_t*) getInputBuffer;

// getOutputBuffer returns a buffer than can be used to fetch the tensor outputs
// for the tflite model.
- (uint8_t*) getOutputBuffer;

@end  // CwtTfLiteModel

#endif  // CWT_TF_LITE_MODEL_H
