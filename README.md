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

# Usage
- [Usage](#ios-usage)
  - [Starting a session](#starting-a-session)
    - [Use case 1. Start a session.](#use-case-1-start-a-session)
    - [Use case 2. Add an observer to receive audio and video session life cycle events.](#use-case-2-add-an-observer-to-receive-audio-and-video-session-life-cycle-events)
  - [Device](#device)
    - [Use case 3. List audio/video devices](#use-case-3-list-audiovideo-devices)
    - [Use case 4. Choose audio device by passing `MediaDevice` object](#use-case-4-choose-audio-device-by-passing-mediadevice-object)
    - [Use case 5. Switch between camera](#use-case-5-switch-between-camera)
    - [Use case 6. Subscribe to new device/device removal.](#use-case-6-subscribe-to-new-devicedevice-removal)
    - [Use case 7. Get currently selected audio device](#use-case-7-get-currently-selected-audio-device)
  - [Audio](#audio)
    - [Use case 8. Mute and unmute an audio input](#use-case-8-mute-and-unmute-an-audio-input)
    - [Use case 9. Add an observer to observe realtime events such as volume changes/signal change/muted status of a specific attendee.](#use-case-9-add-an-observer-to-observe-realtime-events-such-as-volume-changessignal-changemuted-status-of-a-specific-attendee)
    - [Use case 10. Detect the active speakers.](#use-case-10-detect-the-active-speakers)
  - [Video](#video)
    - [Use case 11. Start sharing your video.](#use-case-11-start-sharing-your-video)
    - [Use case 12. Start viewing local video tile](#use-case-12-start-viewing-local-video-tile)
    - [Use case 13. Stop sharing your video.](#use-case-13-stop-sharing-your-video)
    - [Use case 14. Stop viewing local video](#use-case-14-stop-viewing-local-video)
    - [Use case 15. View only one remote attendee video. e.g. 1-on-1 session. Tutor-Student session](#use-case-15-view-only-one-remote-attendee-video-eg-1-on-1-session-tutor-student-session)
  - [Screen share](#screen-share)
    - [Use case 16. Start/Stop viewing remote screen share.](#use-case-16-startstop-viewing-remote-screen-share)
  - [Metrics](#metrics)
    - [Use case 17. Start receiving metrics](#use-case-17-start-receiving-metrics)
  - [Data Message](#data-message)
    - [Use case 18. Start receiving data message](#use-case-18-start-receiving-data-message)
    - [Use case 19. Start sending data message](#use-case-19-start-sending-data-message)
  - [Stopping a session](#stopping-a-session)
    - [Use case 20. Stop session](#use-case-20-stop-session)
  - [Voice Focus](#voice-focus)
    - [Use case 21. Enable/Disable voice focus](#use-case-21-enabledisable-voice-focus)
  - [Custom Video Source](#custom-video-source)
    - [Use case 22. Enable/Disable torch (back light)](#use-case-22-enabledisable-torch-back-light)
## Starting a session

### Use case 1. Start a session. 

To start hearing audio and receiving video, you’ll just need to start the session.

```
currentMeetingSession.audioVideo.start()
```

### Use case 2. Add an observer to receive audio and video session life cycle events. 

```
class MeetingModel : AudioVideoObserver {
    **func** audioSessionDidStartConnecting(reconnecting: Bool) {}
    **func** audioSessionDidStart(reconnecting: Bool) {
        // Handle mute of self attendee.
    }
    **func** audioSessionDidDrop() {}
    **func** audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {}
    **func** audioSessionDidCancelReconnect() {}
    **func** connectionDidRecover() {}
    **func** connectionDidBecomePoor() {}
    **func** videoSessionDidStartConnecting() {}
    **func** videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {}
    **func** videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {}
    
    currentMeetingSession.audioVideo.addAudioVideoObserver(observer: **self**)
}
```

## Device

### Use case 3. List audio/video devices

List available devices that can be used for the meeting

```
let devices = currentMeetingSession.audioVideo.listAudioDevices()
```

### Use case 4. Choose audio device by passing `MediaDevice` object

> NOTE: chooseAudioDevice is no-op if it is called before audioVideo.start(). You should call this after audio session has started. You can put it in audioSessionDidStart callback

```
let devices = audioVideo.listAudioDevices()
// Have your own logic to sort listAudioDevices() 

if (devices.isNotEmpty()) {
    currentMeetingSession.audioVideo.chooseAudioDevice(mediaDevice: devices[0])
}             
```

### Use case 5. Switch between camera

> NOTE: switchCamera() is no-op if you are using custom camera capture source.

```
currentMeetingSession.audioVideo.switchCamera() // front will switch to back and back will switch to front camera
```

### Use case 6. Subscribe to new device/device removal.

Add DeviceChangeObserver to receive callback when new audio device is introduced or audio device has been removed. For instance, if a bluetooth audio device is introduced, it will invoke `audioDeviceDidChange`

```
extension MeetingModel: DeviceChangeObserver {
    func audioDeviceDidChange(freshAudioDeviceList: [MediaDevice]) {
        let deviceLabels: [String] = freshAudioDeviceList.map { device in "* \(device.label)" }
        logger.info("Device changed (deviceLabels.joined(separator: "\n")")
    }
}
```

### Use case 7. Get currently selected audio device

```
let activeAudioDevice = `currentMeetingSession.audioVideo.getActiveAudioDevice()`
```

## Audio

### Use case 8. Mute and unmute an audio input

```
let muted = currentMeetingSession.audioVideo.realtimeLocalMute() // Mute

let unmuted = currentMeetingSession.audioVideo.realtimeLocalUnmute // Unmute
```

### Use case 9. Add an observer to observe realtime events such as volume changes/signal change/muted status of a specific attendee. 

You can use this to build real-time indicator UI on specific attendee

```
extension MeetingModel: RealtimeObserver {
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
    
    currentMeetingSession.audioVideo.addRealtimeObserver(observer: **self**)
}
```

### Use case 10. Detect the active speakers. 

> NOTE: You need to set `scoreCallbackIntervalMs` to receive callback for `activeSpeakerScoreDidChange`. If this value is not set, you will only get `activeSpeakerScoreDidChange` callback. For basic use case, you can just use `activeSpeakerDidDetect.`

```
**extension** MeetingModel: ActiveSpeakerObserver {
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
    currentMeetingSession.audioVideo.addActiveSpeakerObserver(policy: DefaultActiveSpeakerPolicy(), observer: **self**)
}
```

## Video

> NOTE: You will need to bind the video  to `DefaultVideoRenderView` or your customer render view (`VideoRenderView`) in order to display the video.

You can find more details on adding/removing/viewing video from [building-a-meeting-application-on-ios-using-the-amazon-chime-sdk/](https://aws.amazon.com/blogs/business-productivity/building-a-meeting-application-on-ios-using-the-amazon-chime-sdk/)

### Use case 11. Start sharing your video. 

> NOTE: From `videoTileDidAdd` callback, tileState should have property of `isLocalTile` true

```
extension MeetingModel {
    // start sharing local video
    // startLocalVideo will invoke videoTileDidAdd callback
    currentMeetingSession.audioVideo.startLocalVideo()
}
```

### Use case 12. Start viewing local video tile

> NOTE: The local video should be mirrored. cell.videoRenderView.mirror = true

```
extension MeetingModel: VideoTileObserver {
    func videoTileDidAdd(tileState: VideoTileState) {
            if tileState.isLocalTile {
                videoModel.setSelfVideoTileState(tileState)
                if activeMode == .video {
                    videoModel.localVideoUpdatedHandler?()
                }
            }
        }
    }
    // Add observer in order to receieve videoTileDidAdd callback 
    currentMeetingSession.audioVideo.addVideoTileObserver(observer: self)
}
```

```
extension MeetingViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        // Only one section for all video tiles
        return 1
    }

    func collectionView(_: UICollectionView,
                        numberOfItemsInSection _: Int) -> Int {
        guard let meetingModel = meetingModel else {
            return 0
        }
        return meetingModel.videoModel.videoTileCount
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let meetingModel = meetingModel, indexPath.item < meetingModel.videoModel.videoTileCount else {
            return UICollectionViewCell()
        }
        let isSelf = indexPath.item == 0
        let videoTileState = meetingModel.videoModel.getVideoTileState(for: indexPath)
        let displayName = meetingModel.getVideoTileDisplayName(for: indexPath)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoTileCellReuseIdentifier,
                                                            for: indexPath) as? VideoTileCell else {
            return VideoTileCell()
        }

        cell.updateCell(name: displayName,
                        isSelf: isSelf,
                        videoTileState: videoTileState,
                        tag: indexPath.row)
        cell.delegate = meetingModel.videoModel

        if let tileState = videoTileState {
            if tileState.isLocalTile, meetingModel.isFrontCameraActive {
                cell.videoRenderView.mirror = true
            }
            meetingModel.bind(videoRenderView: cell.videoRenderView, tileId: tileState.tileId)
        }
        return cell
    }
    
    meetingModel.videoModel.localVideoUpdatedHandler = { [weak self] in
        self?.videoCollection?.reloadItems(at: [IndexPath(item: 0, section: 0)])
    }
}
```

### Use case 13. Stop sharing your video.

```
extension MeetingModel {
    // stop sharing local video
    // stopLocalVideo will invoke videoTileDidRemove callback
    currentMeetingSession.audioVideo.stopLocalVideo()
}
```

### Use case 14. Stop viewing local video

```
extension MeetingModel: VideoTileObserver {

    func videoTileDidRemove(tileState: VideoTileState) {
        logger.info(msg: "Attempting to remove video tile tileId: \(tileState.tileId)" +
            " attendeeId: \(tileState.attendeeId)")
        // unbind tile
        currentMeetingSession.audioVideo.unbindVideoView(tileId: tileState.tileId)

        if tileState.isLocalTile {
            videoModel.setSelfVideoTileState(nil)
            if activeMode == .video {
                videoModel.localVideoUpdatedHandler?()
            }
        }
    }   
    currentMeetingSession.audioVideo.addVideoTileObserver(observer: self)   
}
```

### Use case 15. View only one remote attendee video. e.g. 1-on-1 session. Tutor-Student session

> NOTE: by calling `audioVideo.pauseRemoteVideoTile` we can save network bandwidth of the device. Please refer to [api_overview.md#8g-in-depth-look-and-comparison-between-video-apis](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/api_overview.md#8g-in-depth-look-and-comparison-between-video-apis)

```
extension MeetingModel: VideoTileObserver {
    private var isAttendeeVideoShared = false
    func videoTileDidAdd(tileState: VideoTileState) {
        logger.info(msg: "Attempting to add video tile tileId: \(tileState.tileId)" +
            " attendeeId: \(tileState.attendeeId) with size \(tileState.videoStreamContentWidth)*\(tileState.videoStreamContentHeight)")

            if tileState.isLocalTile {
                videoModel.setSelfVideoTileState(tileState)
                if activeMode == .video {
                    videoModel.localVideoUpdatedHandler?()
                }
            } else if !tileState.isContent {
                if isAttendeeVideoShared {
                    currentMeetingSession.audioVideo.pauseRemoteVideoTile(tileId: tileState.tileId)
                    return
                }
                if shouldShowThisVideoTile(tileState) {
                    isAttendeeVideoShared = true
                    videoModel.addRemoteVideoTileState(tileState, completion: { success in
                        if success { 
                           self.videoModel.videoUpdatedHandler?()
                        } else {
                            self.logger.info(msg: "Cannot add more video tile tileId: \(tileState.tileId)")
                        }
                    })
                    return
                } else {
                    currentMeetingSession.audioVideo.pauseRemoteVideoTile(tileId: tileState.tileId)
                }
            }
        }
    }
    
    private func shouldShowThisVideoTile(tileState: VideoTileState) {
        // Handle your own logic to check whether this video needs to be displayed
        return true
    }

    func videoTileDidRemove(tileState: VideoTileState) {
        logger.info(msg: "Attempting to remove video tile tileId: \(tileState.tileId)" +
            " attendeeId: \(tileState.attendeeId)")
        currentMeetingSession.audioVideo.unbindVideoView(tileId: tileState.tileId)

        if tileState.isLocalTile {
            videoModel.setSelfVideoTileState(nil)
            if activeMode == .video {
                videoModel.localVideoUpdatedHandler?()
            }
        }
    }
    
    currentMeetingSession.audioVideo.addVideoTileObserver(observer: self)
}
```

## Screen share

### Use case 16. Start/Stop viewing remote screen share.

```
extension MeetingModel: VideoTileObserver {
    func videoTileDidAdd(tileState: VideoTileState) {
        logger.info(msg: "Attempting to add video tile tileId: \(tileState.tileId)" +
            " attendeeId: \(tileState.attendeeId) with size \(tileState.videoStreamContentWidth)*\(tileState.videoStreamContentHeight)")
        if tileState.isContent {
            screenShareModel.tileId = tileState.tileId
            screenShareModel.viewUpdateHandler?(true)
        }
    }


    func videoTileDidRemove(tileState: VideoTileState) {
        logger.info(msg: "Attempting to remove video tile tileId: \(tileState.tileId)" +
            " attendeeId: \(tileState.attendeeId)")
        currentMeetingSession.audioVideo.unbindVideoView(tileId: tileState.tileId)

        if tileState.isContent {
            screenShareModel.tileId = nil
            screenShareModel.viewUpdateHandler?(false)
        }
    }
}
```

```
meetingModel.screenShareModel.tileIdDidSetHandler = { [weak self, weak meetingModel] tileId in
    if let tileId = tileId,
        let screenRenderView = self?.screenRenderView,
        let meetingModel = meetingModel {

        meetingModel.bind(videoRenderView: screenRenderView, tileId: tileId)
    }
}
meetingModel.screenShareModel.viewUpdateHandler = { [weak self] shouldShow in
    self?.screenRenderView.isHidden = !shouldShow
    self?.noScreenViewLabel.isHidden = shouldShow
}
```

## Metrics

### Use case 17. Start receiving metrics

```
extension MeetingModel: MetricsObserver {
    func metricsDidReceive(metrics: [AnyHashable: Any]) {
        // handle metric observer
    }
    
    currentMeetingSession.audioVideo.addMetricsObserver(observer: **self**)
}
```

## Data Message

### Use case 18. Start receiving data message

You can receive real-time message from subscribed topic. 

> NOTE: topic needs to be alpha-numeric and it can include hyphen and underscores.

```
extension MeetingModel: DataMessageObserver {
    func dataMessageDidReceived(dataMessage: DataMessage) {
        // handle data message
    }
    // You can also subscribe to different topic.
    currentMeetingSession.audioVideo.addRealtimeDataMessageObserver(topic: "chat", observer: **self**)
}
```

### Use case 19. Start sending data message

You can send real time message to any subscribed topic. 

> NOTE: topic needs to be alpha-numeric and it can include hyphen and underscores. Data cannot exceed 2kb and lifetime should be positive integer 

```
do {
    // Send "Hello Chime" to any subscribers who are listening to "chat" topic with 1 seconds of lifetime
    try currentMeetingSession
        .audioVideo
        .realtimeSendDataMessage(topic: "chat",
                                data: "Hello Chime",
                                lifetimeMs: 1000)
} catch {
    logger.error(msg: "Failed to send message!")
    return
}
```

## Stopping a session

> NOTE: Make sure to remove all the observers you have added to avoid any memory leaks.

### Use case 20. Stop session

```
class MeetingModel : AudioVideoObserver {
    // There are other handlers in AudioVideoObserver you do need to implement
    **func** **** audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        // Some clean up code when meeting ended.
        removeAudioVideoFacadeObservers()
    }
    
    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
        // This will be invoked.
    }
    
    private func removeAudioVideoFacadeObservers() {
        let audioVideo = currentMeetingSession.audioVideo
        audioVideo.removeVideoTileObserver(observer: self)
        audioVideo.removeRealtimeObserver(observer: self)
        audioVideo.removeAudioVideoObserver(observer: self)
        audioVideo.removeMetricsObserver(observer: self)
        audioVideo.removeDeviceChangeObserver(observer: self)
        audioVideo.removeActiveSpeakerObserver(observer: self)
        audioVideo.removeRealtimeDataMessageObserverFromTopic(topic: "chat")
    }
    currentMeetingSession.audioVideo.stop()
}
```

## Voice Focus

Voice focus reduces the background noise in the meeting for better meeting experience. For more details, see [api_overview.md#11-using-amazon-voice-focus-optional](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/api_overview.md#11-using-amazon-voice-focus-optional)

### Use case 21. Enable/Disable voice focus

```
val success = audioVideo.realtimeSetVoiceFocusEnabled(true) // success = enabling voice focus successful

val success = audioVideo.realtimeSetVoiceFocusEnabled(false) // success = disabling voice focus successful
```

## Custom Video Source

Custom video source allows you to inject your own source to control the video such as applying filter to the video. Detailed guides can be found in [custom_video.md](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/custom_video.md).

### Use case 22. Enable/Disable torch (back light)

```
let customSource = DefaultCameraCaptureSource(logger: ConsoleLogger(name: "CustomCameraSource"))

// Enable torch
customSource.torchEnabled = true

// Disable torch
customSource.torchEnabled = false
```

---

Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
