# Custom Video Sources, Processors, and Sinks

Builders using the Amazon Chime SDK for video can produce, modify, and consume raw video frames transmitted or received during the call. You can allow the facade to manage its own camera capture source, provide your own custom source, or use a provided SDK capture source as the first step in a video processing pipeline which modifies frames before transmission. This guide will give an introduction and overview of the APIs involved with custom video sources.

## Prerequisites

* You have read the [API overview](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/api_overview.md) and have a basic understanding of the components covered in that document.
* You have completed [Getting Started](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/getting_started.md) and have running application which uses the Amazon Chime SDK.

Note: Deploying the serverless/browser demo and receiving traffic from the demo created in this post can incur AWS charges.

## Using the provided camera capture implementation as a custom source to access additional functionality

While the Amazon Chime SDK internally uses a implementation of camera capture, the same capturer can be created, maintained, and used externally before being passed in for transmission to remote participants using the [AudioVideoFacade](https://aws.github.io/amazon-chime-sdk-ios/Protocols.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoFacade). This grants access to the following features:

* Explicit camera device and format selection.
* Configuration, starting, stopping, and video renderering before joining the call.
* Torch/flashlight control.

The camera capture implementation is found in [DefaultCameraCaptureSource](https://aws.github.io/amazon-chime-sdk-ios/Classes/DefaultCameraCaptureSource.html). To create and use the camera capture source complete the following steps:

1. Create a [DefaultCameraCaptureSource](https://aws.github.io/amazon-chime-sdk-ios/Classes/DefaultCameraCaptureSource.html). This requires a [Logger](https://aws.github.io/amazon-chime-sdk-ios/Protocols/Logger.html) as dependency.

```
    let cameraCaptureSource = DefaultCameraCaptureSource(logger: logger)
```

3. Call [VideoCaptureSource.start()](Protocols/VideoCaptureSource.html#/c:@M@AmazonChimeSDK@objc(pl)VideoCaptureSource(im)start) and [DefaultCameraCaptureSource.stop()](https://aws.github.io/amazon-chime-sdk-ios/Classes/DefaultCameraCaptureSource.html#/c:@M@AmazonChimeSDK@objc(pl)VideoCaptureSource(im)stop) to start and stop the capture respectively. Note that if no [VideoSink](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSink.html) has been attached (see later sections) that captured frames will be immediately dropped.

```
    // Start the capture
    cameraCaptureSource.start()

    // Stop the capture when complete
    cameraCaptureSource.stop()
```

4. To set the capture device, use [CameraCaptureSource.switchCamera()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/CameraCaptureSource.html#/c:@M@AmazonChimeSDK@objc(pl)CameraCaptureSource(im)switchCamera) or set [CameraCaptureSource.device](https://aws.github.io/amazon-chime-sdk-ios/Protocols/CameraCaptureSource.html#/c:@M@AmazonChimeSDK@objc(pl)CameraCaptureSource(py)device). You can get a list of usable devices by calling [MediaDevice.listVideoDevices()](https://aws.github.io/amazon-chime-sdk-ios/Classes/MediaDevice.html#/c:@M@AmazonChimeSDK@objc(cs)MediaDevice(cm)listVideoDevices). To set the format, set [CameraCaptureSource.format](https://aws.github.io/amazon-chime-sdk-ios/Protocols/CameraCaptureSource.html#/c:@M@AmazonChimeSDK@objc(pl)CameraCaptureSource(py)format). You can get a list of usable formats by calling [MediaDevice.listSupportedVideoCaptureFormats(mediaDevice:)](https://aws.github.io/amazon-chime-sdk-ios/Classes/MediaDevice.html#/c:@M@AmazonChimeSDK@objc(cs)MediaDevice(cm)listSupportedVideoCaptureFormatsWithMediaDevice:) with a specific [MediaDevice](https://aws.github.io/amazon-chime-sdk-ios/Classes/MediaDevice.html). These can be set before or after capture has been started, and before or during call.

```
    // Switch the camera
    cameraCaptureSource.switchCamera()

    // Get the current device and format
    let currentDevice = cameraCaptureSource.device
    let currentFormat = cameraCaptureSource.format

    // Pick a new device explicitly 
    let newDevice = MediaDevice.listVideoDevices().first { mediaDevice in
        mediaDevice.type == MediaDeviceType.videoFrontCamera
    }
    cameraCaptureSource.device = newDevice

    // Pick a new format explicitly (reverse these so the highest resolutions are first)
    let newFormat = MediaDevice.listSupportedVideoCaptureFormats(mediaDevice: videoDevice).reversed().filter { $0.height < 800 }.first
    if let format = newFormat {
        cameraCaptureSource.format = format
    }
```

5. To turn on the flashlight on the current camera, set [CameraCaptureSource.torchEnabled](https://aws.github.io/amazon-chime-sdk-ios/Protocols/CameraCaptureSource.html#/c:@M@AmazonChimeSDK@objc(pl)CameraCaptureSource(py)torchEnabled). This can be set before or after capture has been started, and before or during call.

```
    // Turn on the torch
    cameraCaptureSource.torchEnabled = true

    // Turn off the torch
    cameraCaptureSource.torchEnabled = false
```

6. To render local camera feeds before joining the call, use [VideoSource.addVideoSink](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSource.html#/c:@M@AmazonChimeSDK@objc(pl)VideoSource(im)addVideoSinkWithSink:) with a provided [VideoSink](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSink.html) (e.g. a [DefaultVideoRenderView](https://aws.github.io/amazon-chime-sdk-ios/Classes/DefaultVideoRenderView.html) created as described in [Getting Started](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/getting_started.md#render-a-video-tile)).
```
    // Add the render view as a sink to camera capture source
    cameraCaptureSource.addVideoSink(sink: someDefaultVideoRenderView)
```

To use the capture source in a call, do the following:

1. When enabling local video, call [AudioVideoControllerFacade.startLocalVideo(source:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)startLocalVideoWithSource:) with the camera capture source as the parameter. Ensure that the capture source is started before `startLocalVideo(source:)` to start transmitting frames.

```
    // Start the camera capture source is started if not already
    cameraCaptureSource.start()
    audioVideo.startLocalVideo(source: cameraCaptureSource)
```

## Implementing a custom video source and transmitting

If builders wish to implement their own video sources (e.g. a camera capture implementation with different configuration, or a raw data source), they can do so by implementing the [VideoSource](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSource.html) protocol, and then producing [VideoFrame](https://aws.github.io/amazon-chime-sdk-ios/Classes/VideoFrame.html) objects containing the raw buffers in some compatible format, similar to the following snippet. See [DefaultCameraCaptureSource code](https://github.com/aws/amazon-chime-sdk-ios/blob/master/AmazonChimeSDK/AmazonChimeSDK/audiovideo/video/capture/DefaultCameraCaptureSource.swift) for a working implementation using the [AVFoundation](https://developer.apple.com/av-foundation/) framework.

The following snippet contains boilerplate for maintaining a list of sinks that have been added to the source; this allows all sources to be forked to multiple targets (e.g. transmission and local rendering). See [VideoContentHint](https://aws.github.io/amazon-chime-sdk-ios/Enums/VideoContentHint.html) for more information on the effects of that paramater to the downstream encoder.

```
class MyVideoSource: VideoSource {
    // Do not indicate any hint to downstream encoder
    var videoContentHint = VideoContentHint.none

    // Downstream video sinks
    private let sinks = NSMutableSet()

    func startProducingFrames() {
        while (true) {
            // Obtain pixel buffer from undelying source ...

            // Create frame
            let buffer = VideoFramePixelBuffer(pixelBuffer: somePixelBuffer)
            let timestampNs = someTimestamp
            let frame = VideoFrame(timestampNs: Int64(timestampNs),
                                   rotation: .rotation0,
                                   buffer: buffer)

            // Forward the frame to downstream sinks
            for sink in sinks {
                (sink as? VideoSink)?.onVideoFrameReceived(frame: frame)
            }
        }
    }

    func addVideoSink(sink: VideoSink) {
        sinks.add(sink)
    }

    func removeVideoSink(sink: VideoSink) {
        sinks.remove(sink)
    }
}
```

When enabling local video, call [AudioVideoControllerFacade.startLocalVideo(source:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)startLocalVideoWithSource:) with the custom source as the parameter. Ensure that the capture source is started before `startLocalVideo(source:)` to start transmitting frames.

```
    // Create and start the processor
    let myVideoSource = MyVideoSource()
    myVideoSource.startProducingFrames()

    // Begin transmission of frames
    audioVideo.startLocalVideo(source: myVideoSource)
```

## Implementing a custom video processing step for local source

By combining the [VideoSource](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSource.html) and [VideoSink](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSink.html) APIs, builders can easily create a video processing step to their applications. Incoming frames can be processed, and then fanned out to downstream sinks like in the following snippet. See example processors in [Demo code](https://github.com/aws/amazon-chime-sdk-ios/blob/master/AmazonChimeSDKDemo/AmazonChimeSDKDemo/utils/MetalVideoProcessor.swift) for complete, documented implementations.

```
class MyVideoProcessor: VideoSource, VideoSink {
    // Note: Builders may want to make this mirror intended upstream source
    // or make it a constructor parameter
    var videoContentHint = VideoContentHint.none

    // Downstream video sinks
    private let sinks = NSMutableSet()

    func onVideoFrameReceived(frame: VideoFrame) {
        guard let pixelBuffer = frame.buffer as? VideoFramePixelBuffer else {
            return
        }

        // Modify buffer ...

        let processedFrame = VideoFrame(timestampNs: frame.timestampNs,
                                        rotation: frame.rotation,
                                        buffer: VideoFramePixelBuffer(pixelBuffer: someModifiedBuffer))

        for sink in sinks {
            (sink as? VideoSink)?.onVideoFrameReceived(frame: processedFrame)
        }
    }

    func addVideoSink(sink: VideoSink) {
        sinks.add(sink)
    }

    func removeVideoSink(sink: VideoSink) {
        sinks.remove(sink)
    }
}
```

To use a video frame processor, builders must use a video source external to the facade (e.g. [DefaultCameraCaptureSource](https://aws.github.io/amazon-chime-sdk-ios/Classes/DefaultCameraCaptureSource.html)). Wire up the source to the processing step using [VideoSource.addVideoSink(sink:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSource.html#/c:@M@AmazonChimeSDK@objc(pl)VideoSource(im)addVideoSinkWithSink:). When enabling local video, call [AudioVideoControllerFacade.startLocalVideo(source:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)startLocalVideoWithSource:) with the processor (i.e. the end of the pipeline) as the parameter. Ensure that the capture source is started to start transmitting frames.

```
    let myVideoProcessor = MyVideoProcessor()
    // Add processor as sink to camera capture source
    cameraCaptureSource.addVideoSink(sink: myVideoProcessor)

    // Use video processor as source to transmitted video
    audioVideo.startLocalVideo(myVideoProcessor)
```

## Implementing a custom video sink for remote sources

Though most builders will simply use [DefaultVideoRenderView](https://aws.github.io/amazon-chime-sdk-ios/Classes/DefaultVideoRenderView.html), they can also implement their own [VideoSink](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSink.html)/[VideoRenderView](https://aws.github.io/amazon-chime-sdk-ios/Protocols.html#/c:@M@AmazonChimeSDK@objc(pl)VideoRenderView) (currently `VideoRenderView` is just an alias for `VideoSink`); some may want full control over the frames for remote video processing, storage, or other applications. To do so implement the [VideoSink](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSink.html) interface like in the following snippet.

```
class MyVideoSink: VideoSink {
    func onVideoFrameReceived(frame: VideoFrame) {
        // Store, render, or upload frame
    }
}
```

When a tile is added, simply pass in the custom sink to [VideoTileControllerFacade.bindVideoView(videoView:tileId:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileControllerFacade(im)bindVideoViewWithVideoView:tileId:) and it will begin to receive remote frames:

```
func videoTileDidAdd(tileState: VideoTileState) {
    // Create a new custom sink
    let myVideoSink = MyVideoSink()

    // Bind it to the tile ID
    audioVideo.bindVideoView(myVideoSink, tileState.tileId)
}
```
