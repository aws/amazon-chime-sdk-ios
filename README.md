# Amazon Chime SDK for iOS

> Note: If building with the SDK source code, the `development` branch contains bleeding-edge changes that may not build with the publically available Chime media library or may not be as stable as [public releases](https://github.com/aws/amazon-chime-sdk-ios/releases).

## Build video calling, audio calling, and screen sharing applications powered by Amazon Chime.

The Amazon Chime SDK for iOS makes it easy to add collaborative audio calling,
video calling, and screen share viewing features to iOS applications by 
using the same infrastructure services that power meetings on the Amazon 
Chime service.

This Amazon Chime SDK for iOS works by connecting to meeting session
resources that you have created in your AWS account. The SDK has everything
you need to build custom calling and collaboration experiences in your
iOS application, including methods to: configure meeting sessions, list 
and select audio devices, switch video devices, start and stop screen share 
viewing, receive callbacks when media events occur such as volume changes, 
and manage meeting features such as audio mute and video tile bindings.

To get started, see the following resources:

* [Amazon Chime](https://aws.amazon.com/chime)
* [Amazon Chime Developer Guide](https://docs.aws.amazon.com/chime/latest/dg/what-is-chime.html)
* [Amazon Chime SDK API Reference](http://docs.aws.amazon.com/chime/latest/APIReference/Welcome.html)
* [SDK Documentation](https://aws.github.io/amazon-chime-sdk-ios/)

And review the following guides:
* [API Overview](guides/api_overview.md)
* [Getting Started](guides/getting_started.md)
* [Custom Video Sources, Processors, and Sinks](guides/custom_video.md)
* [Video Pagination with Active Speaker-Based Policy](guides/video_pagination.md)
* [Content Share](guides/content_share.md)

## Setup

To include the SDK binaries in your own project, follow these steps.

For the purpose of setup, your project's root folder (where you can find your `.xcodeproj` file) will be referred to as `root`

### 1. Download binaries

Download the following zips:
 * if you need bitcode support:
    * [AmazonChimeSDK-0.13.1.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/sdk/0.13.1/AmazonChimeSDK-0.13.1.tar.gz)
    * [AmazonChimeSDKMedia-0.9.0.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/media/0.9.0/AmazonChimeSDKMedia-0.9.0.tar.gz)
 * if you do NOT need bitcode support:
    * [AmazonChimeSDK-0.13.1.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/sdk-without-bitcode/0.13.1/AmazonChimeSDK-0.13.1.tar.gz)
    * [AmazonChimeSDKMedia-0.9.0.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/media-without-bitcode/0.9.0/AmazonChimeSDKMedia-0.9.0.tar.gz)

Unzip and copy the `.framework`s to `root`

### 2. Update project file

Open your `.xcodeproj` file in Xcode and click on your build target. Under `Build Settings` tab, add `$(PROJECT_DIR)` to `Framework Search Path`

Under `Build Settings` tab, add `@executable_path/Frameworks` to `Runpath Search Paths`

Under `General` tab, look for `Frameworks, Libraries, and Embedded Content` section. Click on `+`, then `Add Others`, then `Add Files`. Specify the location of `AmazonChimeSDK.framework` and `AmazonChimeSDKMedia.framework` from Step 1

After adding the two frameworks, verify that `Embed & Sign` is selected under the `Embed` option.

In `Build Settings` tab, under `Linking` section, add the following two flags in `Other Linker Flags`:

* `-lc++`
* `-ObjC`

## Running the demo app

To run the demo application, follow these steps.

### 1. Clone the Git repo

`git clone git@github.com:aws/amazon-chime-sdk-ios.git`

### 2. Download binary

Download the following zip:

* [AmazonChimeSDKMedia-0.9.0.tar.gz](https://amazon-chime-sdk-ios.s3.amazonaws.com/media/0.9.0/AmazonChimeSDKMedia-0.9.0.tar.gz)

Unzip and copy the .framework to `AmazonChimeSDK` folder

### 3. Deploy serverless demo

Deploy the serverless demo from [amazon-chime-sdk-js](https://github.com/aws/amazon-chime-sdk-js)

### 4. Update Demo App

* Update `AppConfiguration.swift` with the URL and region of the serverless demo.
* (Optional) Update `AppConfiguration.swift` and `SampleHandler.swift` with the broadcast upload extension bundle ID and App Group ID if you want to test sharing device level screen capture. See [Content Share](guides/content_share.md) for more details.

### 5. Use Demo App to join meeting

On the joining screen, choose to join the meeting without `CallKit` or join via `CallKit` incoming/outgoing call. Since the demo app does not have Push Notification, it delays joining via incoming call by 10 seconds to give user enough time to background the app or lock the screen to mimic the behavior.

## Reporting a suspected vulnerability

If you discover a potential security issue in this project we ask that you notify AWS/Amazon Security via our
[vulnerability reporting page](http://aws.amazon.com/security/vulnerability-reporting/). Please do **not** create a public GitHub issue.

## Usage
  - [Starting a session](#starting-a-session)
  - [Device](#device)
  - [Audio](#audio)
  - [Video](#video)
  - [Screen share](#screen-share)
  - [Metrics](#metrics)
  - [Data Message](#data-message)
  - [Stopping a session](#stopping-a-session)
  - [Voice Focus](#voice-focus)
  - [Custom Video Source](#custom-video-source)
### Starting a session

#### Use case 1. Start a session

To start sending/receiving audio, you’ll just need to start the session.

```swift
meetingSession.audioVideo.start()
```

#### Use case 2. Add an observer to receive audio and video session life cycle events

```swift
class ViewController: AudioVideoObserver {
    func audioSessionDidStartConnecting(reconnecting: Bool) {}
    func audioSessionDidStart(reconnecting: Bool) {
        // It is recommended to handle mute of self attendee.
    }
    func audioSessionDidDrop() {}
    func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {}
    func audioSessionDidCancelReconnect() {}
    func connectionDidRecover() {}
    func connectionDidBecomePoor() {}
    func videoSessionDidStartConnecting() {}
    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        // Handle logic of receiving video/starting local video
    }
    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {}
    
    meetingSession.audioVideo.addAudioVideoObserver(observer: self)
}
```

### Device

#### Use case 3. List audio devices

List available devices that can be used for the meeting.

```swift
let devices = meetingSession.audioVideo.listAudioDevices()
```

#### Use case 4. Choose audio device by passing `MediaDevice` object

> NOTE: chooseAudioDevice is no-op if it is called before audioVideo.start(). You should call this after audio session has started. You can put it in audioSessionDidStart callback.



> NOTE: You should call chooseAudioDevice with one of devices returned from listAudioDevices().

```swift
let devices = audioVideo.listAudioDevices()
// Have your own logic to sort listAudioDevices() 
// For instance, you can sort it by Blutooth -> Earphone -> Speaker -> built-in earpiece
if (devices.isNotEmpty()) {
    meetingSession.audioVideo.chooseAudioDevice(mediaDevice: devices[0])
}             
```

#### Use case 5. Switch between camera

> NOTE: switchCamera() is no-op if you are using custom camera capture source. Please refer [custom_video](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/custom_video.md#implementing-a-custom-video-source-and-transmitting) for more details.


`switchCamera` will switch currently active camera. In order to get active camera, you can call [getActiveCamera](https://aws.github.io/amazon-chime-sdk-ios/Protocols/DeviceController.html#/c:@M@AmazonChimeSDK@objc(pl)DeviceController(im)getActiveCamera).

```swift
meetingSession.audioVideo.switchCamera()
```

#### Use case 6. Subscribe to get updated device list

Add DeviceChangeObserver to receive callback when new audio device is connected or audio device has been disconnected. For instance, if a bluetooth audio device is connected, `audioDeviceDidChange` is called with the device list including the headphone.

```swift
class ViewController: DeviceChangeObserver {
    func audioDeviceDidChange(freshAudioDeviceList: [MediaDevice]) {
        // You'll get something similar to [iPhone Microphone (audioHandset), Built-in Speaker (audioBuiltInSpeaker), Headset Microphone (audioWiredHeadset)]
        let deviceLabels: [String] = freshAudioDeviceList.map { device in "\(device.label) (\(device.type))" }
    }
    
    meetingSession.audioVideo.addDeviceChangeObserver(observer: self)
}
```

#### Use case 7. Get currently selected audio device

```swift
let activeAudioDevice = meetingSession.audioVideo.getActiveAudioDevice()
```

### Audio

#### Use case 8. Mute and unmute an audio input

```swift
let muted = meetingSession.audioVideo.realtimeLocalMute() // Mute

let unmuted = meetingSession.audioVideo.realtimeLocalUnmute // Unmute
```

#### Use case 9. Add an observer to observe realtime events such as volume changes/signal change/muted status of a specific attendee

You can use this to build real-time indicator UI on specific attendee.

```swift
class ViewController: RealtimeObserver {
    func attendeesDidLeave(attendeeInfo: [AttendeeInfo]) {
        // Update UI to remove attendees
    }
    func attendeesDidDrop(attendeeInfo: [AttendeeInfo]) {
        // Update UI to remove attendees
    }
    func attendeesDidMute(attendeeInfo: [AttendeeInfo]) {
        // Update UI to show muted status of attendees
    }
    func attendeesDidUnmute(attendeeInfo: [AttendeeInfo]) {
        // Update UI to show unmuted status of attendees
    }
    func volumeDidChange(volumeUpdates: [VolumeUpdate]) {
        // Update UI to show some volume level of attendees
    }
    func signalStrengthDidChange(signalUpdates: [SignalUpdate]) {
        // Update UI to show some signal stregth (network condition) of attendees
    }
    func attendeesDidJoin(attendeeInfo: [AttendeeInfo]) {
        // Update UI to show attendees
    }
    
    meetingSession.audioVideo.addRealtimeObserver(observer: self)
}
```

#### Use case 10. Detect the active speakers

> NOTE: You need to set `scoreCallbackIntervalMs` to receive callback for `activeSpeakerScoreDidChange`. If this value is not set, you will only get `activeSpeakerScoreDidChange` callback. For basic use case, you can just use `activeSpeakerDidDetect`.

```swift
class ViewController: ActiveSpeakerObserver {
    var observerId: String {
        return UUID().uuidString
    }

    var scoresCallbackIntervalMs: Int {
        return 5000 // 5 second
    }
    
    func activeSpeakerDidDetect(attendeeInfo: [AttendeeInfo]) {}

    func activeSpeakerScoreDidChange(scores: [AttendeeInfo: Double]) {
       // handle logic based on active speaker score changed.
       // You can compare them to get most active speaker
    }

    // Use default policy for active speaker. 
    // If you want custom logic, implement your own ActiveSpeakerPolicy
    meetingSession.audioVideo.addActiveSpeakerObserver(policy: DefaultActiveSpeakerPolicy(), observer: self)
}


```

### Video

> NOTE: You will need to bind the video  to `DefaultVideoRenderView` or your customer render view (`VideoRenderView`) in order to display the video.

You can find more details on adding/removing/viewing video from [building-a-meeting-application-on-ios-using-the-amazon-chime-sdk/](https://aws.amazon.com/blogs/business-productivity/building-a-meeting-application-on-ios-using-the-amazon-chime-sdk/).

#### Use case 11. Start receiving remote video

> NOTE: From `videoTileDidAdd` callback, tileState should have property of `isLocalTile` true.

```swift
/// start receiving remote video
/// startRemoteVideo will invoke videoTileDidAdd callback when remote
/// starts sharing their videos
meetingSession.audioVideo.startRemoteVideo()
```

#### Use case 12. Start viewing remote video tile

```swift
class ViewController: VideoTileObserver {
    // DefaultRenderView defined in the storyboard
    @IBOutlet var remoteVideoView: DefaultRenderView!
    
    func videoTileDidAdd(tileState: VideoTileState) {
            if tileState.isLocalTile {
                meetingSession.audioVideo.bind(videoView: remoteVideoView, tileId: tileState.tileId)
            }
        }
    }
    
    // Add observer in order to receieve videoTileDidAdd callback 
    meetingSession.audioVideo.addVideoTileObserver(observer: self)
}
```

#### Use case 13. Stop receiving remote video

```swift
// stop receiving remote video
// stopRemoteVideo will invoke videoTileDidRemove callback
meetingSession.audioVideo.stopRemoteVideo()
```

#### Use case 14. Stop viewing remote video

```swift
class ViewController: VideoTileObserver {
    func videoTileDidRemove(tileState: VideoTileState) {
        // unbind video view to stop viewing the tile
        meetingSession.audioVideo.unbindVideoView(tileId: tileState.tileId)
    }   
    
    meetingSession.audioVideo.addVideoTileObserver(observer: self)
}
```

#### Use case 15. Start sharing your video

> NOTE: From `videoTileDidAdd` callback, tileState should have property of `isLocalTile` true.

```swift
// start sharing local video
// startLocalVideo will invoke videoTileDidAdd callback
meetingSession.audioVideo.startLocalVideo()
```

#### Use case 16. Start viewing local video tile

> NOTE: The local video should be mirrored. cell.videoRenderView.mirror = true.

```swift
class ViewController: VideoTileObserver {
    // DefaultRenderView defined in the storyboard
    @IBOutlet var localVideoView: DefaultRenderView!
    
    func videoTileDidAdd(tileState: VideoTileState) {
            if tileState.isLocalTile {
                meetingSession.audioVideo.bind(videoView: localVideoView, tileId: tileState.tileId)
            }
        }
    }
    
    // Add observer in order to receieve videoTileDidAdd callback 
    meetingSession.audioVideo.addVideoTileObserver(observer: self)
}
```

#### Use case 17. Stop sharing your video

```swift
// stop sharing local video
// stopLocalVideo will invoke videoTileDidRemove callback
meetingSession.audioVideo.stopLocalVideo()
```

#### Use case 18. Stop viewing local video

```swift
class ViewController: VideoTileObserver {
    func videoTileDidRemove(tileState: VideoTileState) {
        // unbind video view to stop viewing the tile
        meetingSession.audioVideo.unbindVideoView(tileId: tileState.tileId)
    }
    
    meetingSession.audioVideo.addVideoTileObserver(observer: self)
}
```

More advanced use case can be found in [video_pagination](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/video_pagination.md).

### Screen share

#### Use case 19. Start/Stop viewing remote screen share

```swift
class ViewController: VideoTileObserver {
    // DefaultRenderView defined in the storyboard
    @IBOutlet var screenVideoView: DefaultRenderView!
    
    func videoTileDidAdd(tileState: VideoTileState) {
        if (tileState.isContent) {
            meetingSession.audioVideo.bindVideoView(videoView: screenVideoView, tileId: tileState.tileId)
        }
    }

    func videoTileDidRemove(tileState: VideoTileState) {
        meetingSession.audioVideo.unbindVideoView(tileId: tileState.tileId)
    }
    
    meetingSession.audioVideo.addVideoTileObserver(observer: self)
}
```

### Metrics

#### Use case 20. Start receiving metrics

```swift
class ViewController: MetricsObserver {
    func metricsDidReceive(metrics: [AnyHashable: Any]) {
        // handle metric observer
    }
    
    meetingSession.audioVideo.addMetricsObserver(observer: self)
}
```

### Data Message

#### Use case 21. Start receiving data message

You can receive real-time message from subscribed topic. 

> NOTE: topic needs to be alpha-numeric and it can include hyphen and underscores.

```swift
class ViewController: DataMessageObserver {
    func dataMessageDidReceived(dataMessage: DataMessage) {
        // handle data message
    }
    // You can also subscribe to different topic.
    meetingSession.audioVideo.addRealtimeDataMessageObserver(topic: "chat", observer: self)
}
```

#### Use case 22. Start sending data message

You can send real time message to any subscribed topic. 

> NOTE: Topic needs to be alpha-numeric and it can include hyphen and underscores. Data cannot exceed 2kb and lifetime should be positive integer. 

```swift
do {
    // Send "Hello Chime" to any subscribers who are listening to "chat" topic with 1 seconds of lifetime
    try meetingSession
        .audioVideo
        .realtimeSendDataMessage(topic: "chat",
                                data: "Hello Chime",
                                lifetimeMs: 1000)
} catch {
    logger.error(msg: "Failed to send message!")
    return
}
```

### Stopping a session

> NOTE: Make sure to remove all the observers you have added to avoid any memory leaks.

#### Use case 23. Stop a session

```swift
class ViewController : AudioVideoObserver {
    // There are other handlers in AudioVideoObserver you do need to implement
    func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        // Some clean up code when meeting ended.
        removeAudioVideoFacadeObservers()
    }
    
    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        // This will be invoked.
    }
    
    private func removeAudioVideoFacadeObservers() {
        let audioVideo = meetingSession.audioVideo
        audioVideo.removeVideoTileObserver(observer: self)
        audioVideo.removeRealtimeObserver(observer: self)
        audioVideo.removeAudioVideoObserver(observer: self)
        audioVideo.removeMetricsObserver(observer: self)
        audioVideo.removeDeviceChangeObserver(observer: self)
        audioVideo.removeActiveSpeakerObserver(observer: self)
        audioVideo.removeRealtimeDataMessageObserverFromTopic(topic: "chat")
    }
    meetingSession.audioVideo.stop()
}
```

### Voice Focus

Voice focus reduces the background noise in the meeting for better meeting experience. For more details, see [api_overview.md#11-using-amazon-voice-focus-optional](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/api_overview.md#11-using-amazon-voice-focus-optional)

#### Use case 24. Enable/Disable voice focus

```swift
val success = audioVideo.realtimeSetVoiceFocusEnabled(true) // success = enabling voice focus successful

val success = audioVideo.realtimeSetVoiceFocusEnabled(false) // success = disabling voice focus successful
```

### Custom Video Source

Custom video source allows you to inject your own source to control the video such as applying filter to the video. Detailed guides can be found in [custom_video.md](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/custom_video.md).


---

Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
