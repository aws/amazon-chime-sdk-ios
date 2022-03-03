# What is Background Blur and Background Replacement?
The background blur and replacement APIs allows builders to apply blur or replacement on frames received from a video source. The filter processors uses a TensorFlow Lite (TFLite) machine learning model to segment the foreground of a frame and then apply on top of the blurred background or a replacement image using built in swift capabilities. Follow this guide for more information on how to use `BackgroundBlurVideoFrameProcessor` and `BackgroundReplacementVideoFrameProcessor`.

Background blur and replacement are integrated in the `AmazonChimeSDKDemo` app. To try it out, follow these steps:
1. Run the `AmazonChimeSDKDemo` on your device.
2. Join a meeting.
3. Enable video.
4. Click on the `video`tab.
5. Click on the icon with three dots under your local video tile.
6. Enable `none`, `blur` or `replacement` filter from the menu.

# Getting Started

## Prerequisites

* Have `AmazonChimeSDKMachineLearning` framework imported and `selfie_segmentation_landscape.tflite` copied as a bundle resource in your project. Follow `README` for more information on how to import these depedencies.
* Understanding of [custom_video](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/custom_video.md) guide.
* Basic to intermediate understanding of iOS development.
* Xcode version 11.3 or later.
* iOS device target of 10.0 or later.

## Overview
`BackgroundBlurVideoFrameProcessor` and `BackgroundReplacementVideoFrameProcessor` uses [`VideoSource`](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSource.html) and [`VideoSink`](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSink.html) APIs to consume and modify frames which are then fanned out to downstream sinks. To use the processors, builders must wire up the processor to a video source external (e.g. `DefaultCameraCaptureSource`) using `VideoSource.addVideoSink(sink:)`. Then enable the local video with background blur or replacement processor as the source using `AudioVideoControllerFacade.startLocalVideo(source:)`.

`BackgroundBlurVideoFrameProcessor` and `BackgroundReplacementVideoFrameProcessor` will return the same unmodified frame if any issues occur. Please see logs for more information.

### Implementing background blur in your application.

`BackgroundBlurVideoFrameProcessor` constructor takes a `BackgroundBlurConfiguration`:

`BackgroundBlurConfiguration`
```
logger: Logger,
blurStrength: BackgroundBlurStrength
```

1. logger: Logger to log any warnings or errors.
2. blurStrength: specifies the blur intensity, the higher the more blurred the background will be. See `BackgroundBlurStrength` for more information. The processor will default to `BackgroundBlurStrength.low` if not provided by the builder. It can also be changed later using the `setBlurStrength(newBlurStrength: BackgroundBlurStrength)` API.

Here's an example:

```
let backgroundBlurConfigurations = BackgroundBlurConfiguration(logger: ConsoleLogger(name: "BackgroundBlurProcessor"),
                                                               blurStrength: BackgroundBlurStrength.low)
let backgroundBlurVideoFrameProcessor = BackgroundBlurVideoFrameProcessor(backgroundBlurConfiguration: backgroundBlurConfigurations)

let cameraCaptureSource = DefaultCameraCaptureSource(logger: ConsoleLogger(name: "DefaultCameraCaptureSource"))

// Add the background blur processor as sink to the video source (e.g. `DefaultCameraCaptureSource`)
cameraCaptureSource.addVideoSink(sink: backgroundBlurVideoFrameProcessor)

// Use background blur processor as source
audioVideo.startLocalVideo(backgroundBlurVideoFrameProcessor)
```

`BackgroundBlurVideoFrameProcessor` will receive the frames and apply the foreground on top of the blurred background image which is sent to the downstream sinks to render the modified frame. 

## Implementing background replacement in your application.

`BackgroundReplacementVideoFrameProcessor` constructor takes a `BackgroundReplacementConfiguration`:

`BackgroundReplacementConfiguration`
```
logger: Logger,
backgroundReplacementImage: UIImage
```

1. logger: Logger to log any warnings or errors.
2. backgroundReplacementImage: The background replacement image that will be used by the processor to replace the background. Note: the background replacement image width and height should match the `VideoFrame` width and height.

Here's an example:

```
let backgroundReplacementConfigurations = BackgroundReplacementConfiguration(logger: ConsoleLogger(name: "BackgroundReplacementVideoFrameProcessor"),
                                                                             backgroundReplacement: backgroundReplacementImage)
let backgroundReplacementVideoFrameProcessor = BackgroundReplacementVideoFrameProcessor(backgroundReplacementConfiguration: backgroundReplacementConfigurations)

let cameraCaptureSource = DefaultCameraCaptureSource(logger: ConsoleLogger(name: "DefaultCameraCaptureSource"))

// Add the background replacement processor as sink to the video source (e.g. `DefaultCameraCaptureSource`)
cameraCaptureSource.addVideoSink(sink: backgroundReplacementVideoFrameProcessor)

// Use background replacement processor as source
audioVideo.startLocalVideo(backgroundReplacementVideoFrameProcessor)
```

`BackgroundReplacementVideoFrameProcessor` will receive the frames and apply the foreground on top of the replacement image which is sent to the downstream sinks to render the modified frame. 