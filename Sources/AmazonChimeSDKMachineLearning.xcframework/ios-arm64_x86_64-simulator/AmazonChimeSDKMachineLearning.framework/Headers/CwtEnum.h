//
//  CwtEnum.h
//  cwt
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//

#ifndef CWT_ENUM_H
#define CWT_ENUM_H

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

// CwtInputModelConfig represents the input model configuration used to
// set up the CWT model. This is the same as TFLiteModel::InputModelConfig.
typedef struct {
  int in_height;
  int in_width;
  int in_channels;

  int model_range_min;
  int model_range_max;
} CwtInputModelConfig;

#ifdef __cplusplus
}
#endif

// CwtModelState represents the state of the model. This is the same as
// TFLiteModel::ModelState.
typedef NS_ENUM(NSUInteger, CwtModelState) {
  EMPTY = 0,
  LOADING = 1,
  LOADED = 2,

  FAILED_TO_INIT_MODEL = 1000,
  FAILED_TO_INIT_INTERPRETER,
  FAILED_TO_ALLOC_MEMORY,
  FAILED_TO_DOWNLOAD_MODEL,
  FAILED_TO_PREDICT,
};

// CwtPredictResult represents the result of predict invoking a model.
typedef NS_ENUM(NSUInteger, CwtPredictResult) {
  SUCCESS = 0,
  ERROR,
};

#endif  // CWT_ENUM_H
