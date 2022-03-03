//
//  SegmentationProcessor.swift
//  AmazonChimeSDK
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

#if canImport(AmazonChimeSDKMachineLearning)
import AmazonChimeSDKMachineLearning
#endif
import CoreImage
import CoreMedia
import Foundation

/// `SegmentationProcessor` is a processor that handles the process of predicting an image foreground mask.
public class SegmentationProcessor {
    #if canImport(AmazonChimeSDKMachineLearning)
    /// Tensorflow model used to predict the foreground of the image.
    private let model: CwtTfLiteModel = CwtTfLiteModel()

    /// State used to represent model current state.
    private var modelState: CwtModelState = CwtModelState.EMPTY
    #endif

    /// Custom logger.
    private let logger: Logger

    /// Segmentation model file name.
    private let modelFileName: String = "selfie_segmentation_landscape"

    /// Public constructor to initialize the processor.
    ///
    /// - Parameters:
    ///   - logger: Custom logger to log events.
    public init(logger: Logger) {
        self.logger = logger
    }

    /// Initializes the TensorFlow model.
    ///
    /// - Parameters:
    ///   - height: Image height.
    ///   - width: Image width.
    ///   - channels: Number of channel of the image color space.
    public func initialize(height: Int, width: Int, channels: Int32) throws {
        #if canImport(AmazonChimeSDKMachineLearning)
        guard let bundle = Bundle(for: type(of: self)).path(forResource: modelFileName,
                                                            ofType: "tflite")
        else {
            modelState = CwtModelState.FAILED_TO_INIT_MODEL
            throw ResourceError.notFound
        }
        let path = URL(fileURLWithPath: bundle).path

        let modelConfig = CwtInputModelConfig(in_height: Int32(height),
                                              in_width: Int32(width),
                                              in_channels: Int32(channels),
                                              model_range_min: 0,
                                              model_range_max: 1)

        modelState = model.loadFile(path, config: modelConfig)
        logger.info(msg: "Model was initialized with \(modelState) state")
        #else
        logger.error(msg: "AmazonChimeSDKMachineLearning cannot be imported." +
                     "See `Download Binaries` section in README for more information on " +
                     "how to import AmazonChimeSDKMachineLearning framework.")
        // Throw an error if AmazonChimeSDKMachineLearning cannot be imported.
        throw ResourceError.notFound
        #endif
    }

    #if canImport(AmazonChimeSDKMachineLearning)
    /// Calls the model to predict the foreground on the image stored in model.getInputBuffer().
    ///
    /// - Returns: Predict success or error result.
    public func predict() -> CwtPredictResult {
        let result: CwtPredictResult = model.predict()
        return result
    }

    /// - Returns: The model current load state (Empty, Loading, Loaded).
    public func getModelState() -> CwtModelState {
        return modelState
    }

    /// - Returns: Pointer to the input buffer that is used to store the image data that will be predicted.
    public func getInputBuffer() -> UnsafeMutablePointer<UInt8> {
        return model.getInputBuffer()
    }

    /// - Returns: Pointer to the output buffer of the predicted image.
    public func getOutputBuffer() -> UnsafeMutablePointer<UInt8> {
        return model.getOutputBuffer()
    }
    #endif
}
