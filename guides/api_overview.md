# API Overview

This guide gives an overview of the API methods that you can use to create a meeting with audio and video.

## 1. Create a session

The [MeetingSession](https://aws.github.io/amazon-chime-sdk-ios/Protocols/MeetingSession.html) and its [AudioVideoFacade](https://aws.github.io/amazon-chime-sdk-ios/Protocols.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoFacade) are the starting points for creating meetings. 
You will need to create a [Logger](https://aws.github.io/amazon-chime-sdk-ios/Protocols/Logger.html) and [MeetingSessionConfiguration](https://aws.github.io/amazon-chime-sdk-ios/Classes/MeetingSessionConfiguration.html) before creating a meeting session.

### 1a. Create a logger

You can utilize the [ConsoleLogger](https://aws.github.io/amazon-chime-sdk-ios/Classes/ConsoleLogger.html) to write logs with [os_log](https://developer.apple.com/documentation/os/os_log). You can also implement the Logger interface to customize the logging behavior.

```
let logger = ConsoleLogger(name: "test", level: LogLevel.DEBUG)
```

### 1b. Create a meeting session configuration

Create a [MeetingSessionConfiguration](https://aws.github.io/amazon-chime-sdk-ios/Classes/MeetingSessionConfiguration.html) object with the responses to [chime:CreateMeeting](https://docs.aws.amazon.com/chime/latest/APIReference/API_CreateMeeting.html) and [chime:CreateAttendee](https://docs.aws.amazon.com/chime/latest/APIReference/API_CreateAttendee.html). Your server application should make these API calls and securely pass the meeting and attendee responses to the client application.

### 1c. Create a meeting session

Create a [DefaultMeetingSession](https://aws.github.io/amazon-chime-sdk-ios/Classes/DefaultMeetingSession.html) with the `MeetingSessionConfiguration` object created above.

```
let meetingSession = DefaultMeetingSession(configuration: configuration, logger: logger)
```

## Configure the session

Before starting the meeting session, you should configure the audio device.

### 2a. Configure the audio device

To retrieve a list of available audio devices, call meetingSession.audioVideo.[listAudioDevices()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/DeviceController.html#/c:@M@AmazonChimeSDK@objc(pl)DeviceController(im)listAudioDevices).

To use the chosen audio device, call meetingSession.audioVideo.[chooseAudioDevice(mediaDevice:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/DeviceController.html#/c:@M@AmazonChimeSDK@objc(pl)DeviceController(im)chooseAudioDeviceWithMediaDevice:).

### 2b. Register a device change observer (optional)

You can receive events about changes to available audio devices by implementing a [DeviceChangeObserver](https://aws.github.io/amazon-chime-sdk-ios/Protocols/DeviceChangeObserver.html) and registering the observer with the audio video facade.

To add a DeviceChangeObserver, call meetingSession.audioVideo.[addDeviceChangeObserver(observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/DeviceController.html#/c:@M@AmazonChimeSDK@objc(pl)DeviceController(im)addDeviceChangeObserverWithObserver:).

To remove a DeviceChangeObserver, call meetingSession.audioVideo.[removeDeviceChangeObserver(observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/DeviceController.html#/c:@M@AmazonChimeSDK@objc(pl)DeviceController(im)removeDeviceChangeObserverWithObserver:).

A DeviceChangeObserver has the following method:

* [audioDeviceDidChange](https://aws.github.io/amazon-chime-sdk-ios/Protocols/DeviceChangeObserver.html#/c:@M@AmazonChimeSDK@objc(pl)DeviceChangeObserver(im)audioDeviceDidChangeWithFreshAudioDeviceList:): called when audio devices are changed

## 3. Request permissions for audio and video

Before starting audio or video, you will need to request permissions from the user and verify that they are granted. In Xcode, open `Info.plist` and add `NSMicrophoneUsageDescription` ("Privacy - Microphone Usage Description") and `NSCameraUsageDescription` ("Privacy - Camera Usage Description") to the property list. This will allow the app to ask for microphone and camera permissions.

After doing this, you will also need to request permissions for microphone and camera access in your source code. You can either do this with `AVAudioSession.recordPermission` and `AVCaptureDevice.authorizationStatus`, handling the response synchronously and falling back to requesting permissions, or you can use `requestRecordPermission` and `requestAccess` with an asynchronous completion handler.
```
AVAudioSession.sharedInstance().requestRecordPermission

AVCaptureDevice.requestAccess(for: .video)
```

Calling the APIs without having the above permissions granted will result in a `PermissionError`.

## 4. Register an audio video observer 

You can receive events about the audio session, video session, and connection health by implementing an [AudioVideoObserver](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoObserver.html) and registering the observer with the audio video facade.

To add an AudioVideoObserver, call meetingSession.audioVideo.[addAudioVideoObserver(observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)addAudioVideoObserverWithObserver:).

To remove an AudioVideoObserver, call meetingSession.audioVideo.[removeAudioVideoObserver(observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)removeAudioVideoObserverWithObserver:).

An AudioVideoObserver has the following methods:

* [audioSessionDidStartConnecting(reconnecting:)
](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoObserver.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoObserver(im)audioSessionDidStartConnectingWithReconnecting:): called when the audio session is connecting or reconnecting
* [audioSessionDidStart(reconnecting:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoObserver.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoObserver(im)audioSessionDidStartWithReconnecting:): called when the audio session has started
* [audioSessionDidDrop()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoObserver.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoObserver(im)audioSessionDidDrop): called when audio session gets dropped due to poor network conditions
* [audioSessionDidStopWithStatus(sessionStatus:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoObserver.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoObserver(im)audioSessionDidStopWithStatusWithSessionStatus:): called when the audio session has stopped with the reason provided in the status
* [audioSessionDidCancelReconnect()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoObserver.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoObserver(im)audioSessionDidCancelReconnect): called when the audio session cancelled reconnecting
* [connectionDidBecomePoor()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoObserver.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoObserver(im)connectionDidBecomePoor) : called when connection health has become poor
* [connectionDidRecover()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoObserver.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoObserver(im)connectionDidRecover): called when connection health has recovered
* [videoSessionDidStartConnecting()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoObserver.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoObserver(im)videoSessionDidStartConnecting): called when the video session is connecting or reconnecting
* [videoSessionDidStartWithStatus(sessionStatus:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoObserver.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoObserver(im)videoSessionDidStartWithStatusWithSessionStatus:): called when the video session has started with the status provided
* [videoSessionDidStopWithStatus(sessionStatus:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoObserver.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoObserver(im)videoSessionDidStopWithStatusWithSessionStatus:): called when the video session has stopped with the status provided

## 5. Starting and stopping the meeting session

Call this method after doing pre-requisite configuration (See previous sections). Audio permissions are required for starting the meeting session. 

To start the meeting session, call meetingSession.audioVideo.[start(callKitEnabled:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)startWithCallKitEnabled:error:). This will start underlying media clients and will start sending and receiving audio. Equivalently, call meetingSession.audioVideo.[start()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)startAndReturnError:) if the call is not reported to CallKit so that audio interruptions will be handled by the SDK itself.

To stop the meeting session, call meetingSession.audioVideo.[stop()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)stop). 

## 6. Building a roster of participants

### 6a. Register a realtime observer 

You can use a [RealtimeObserver](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeObserver.html) to learn when attendees join and leave and when their volume level, mute state, or signal strength changes.

To add a RealtimeObserver, call meetingSession.audioVideo.[addRealtimeObserver(observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeControllerFacade(im)addRealtimeObserverWithObserver:).

To remove a RealtimeObserver, call meetingSession.audioVideo.[removeRealtimeObserver(observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeControllerFacade(im)removeRealtimeObserverWithObserver:).

A RealtimeObserver has the following methods:

* [volumeDidChange(volumeUpdates:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeObserver.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeObserver(im)volumeDidChangeWithVolumeUpdates:): called when attendees' volume levels change
* [signalStrengthDidChange(signalUpdates:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeObserver.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeObserver(im)signalStrengthDidChangeWithSignalUpdates:): called when attendees' signal strengths change
* [attendeesDidJoin(attendeeInfo:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeObserver.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeObserver(im)attendeesDidJoinWithAttendeeInfo:): called when one or more attendees join the meeting
* [attendeesDidLeave(attendeeInfo:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeObserver.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeObserver(im)attendeesDidLeaveWithAttendeeInfo:): called when one or more attendees leave the meeting
* [attendeesDidDrop(attendeeInfo:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeObserver.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeObserver(im)attendeesDidDropWithAttendeeInfo:): called when one or more attendees get dropped
* [attendeesDidMute(attendeeInfo:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeObserver.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeObserver(im)attendeesDidMuteWithAttendeeInfo:): called when one or more attendee become muted
* [attendeesDidUnmute(attendeeInfo:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeObserver.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeObserver(im)attendeesDidUnmuteWithAttendeeInfo:): called when one or more attendee become unmuted

Note that only attendees whose volume level, mute state, or signal strength has changed will be included. All callbacks provide both the attendee ID and external user ID from [chime:CreateAttendee](https://docs.aws.amazon.com/chime/latest/APIReference/API_CreateAttendee.html) so that you may map between the two IDs.

### 6b. Register an active speaker observer (optional)

If you are interested in detecting the active speaker (e.g. to display the active speaker's video as a large, central tile), implement an [ActiveSpeakerObserver](https://aws.github.io/amazon-chime-sdk-ios/Protocols/ActiveSpeakerObserver.html) and register the observer with the audio video facade.

You will also need to provide an [ActiveSpeakerPolicy](https://aws.github.io/amazon-chime-sdk-ios/Protocols/ActiveSpeakerPolicy.html). You can use [DefaultActiveSpeakerPolicy](https://aws.github.io/amazon-chime-sdk-ios/Classes/DefaultActiveSpeakerPolicy.html) or implement the ActiveSpeakerPolicy interface to customize the policy.

To add an ActiveSpeakerObserver, call meetingSession.audioVideo.[addActiveSpeakerObserver(policy:observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/ActiveSpeakerDetectorFacade.html#/c:@M@AmazonChimeSDK@objc(pl)ActiveSpeakerDetectorFacade(im)addActiveSpeakerObserverWithPolicy:observer:).

To remove an ActiveSpeakerObserver, call meetingSession.audioVideo.[removeActiveSpeakerObserver(observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/ActiveSpeakerDetectorFacade.html#/c:@M@AmazonChimeSDK@objc(pl)ActiveSpeakerDetectorFacade(im)removeActiveSpeakerObserverWithObserver:).

You can also tell the active speaker detector whether or not to prioritize video bandwidth for active speakers by calling [hasBandwidthPriorityCallback(hasBandwidthPriority:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/ActiveSpeakerDetectorFacade.html#/c:@M@AmazonChimeSDK@objc(pl)ActiveSpeakerDetectorFacade(im)hasBandwidthPriorityCallbackWithHasBandwidthPriority:)

An ActiveSpeakerObserver has the following methods:

* [activeSpeakerDidDetect(attendeeInfo:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/ActiveSpeakerObserver.html#/c:@M@AmazonChimeSDK@objc(pl)ActiveSpeakerObserver(im)activeSpeakerDidDetectWithAttendeeInfo:): called when one or more active speakers have been detected
* [activeSpeakerScoreDidChange(scores:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/ActiveSpeakerObserver.html#/c:@M@AmazonChimeSDK@objc(pl)ActiveSpeakerObserver(im)activeSpeakerScoreDidChangeWithScores:): called when active speaker scores change at a given interval

You can control `onActiveSpeakerScoreChanged`'s interval by providing a value for `scoresCallbackIntervalMs` while implementing ActiveSpeakerPolicy. You can prevent this callback from being triggered by using a nil value.

## 7. Mute and unmute audio

To mute the local attendee's audio, call meetingSession.audioVideo.[realtimeLocalMute()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeControllerFacade(im)realtimeLocalMute).

To unmute the local attendee's audio, call meetingSession.audioVideo.[realtimeLocalUnmute()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeControllerFacade(im)realtimeLocalUnmute).

## 8. Share and display video

You can use the following methods in order to send, receive, and display video.

A [VideoTile](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTile.html) is a binding of a tile ID, an attendee ID, that attendee's video, and a video view. The [VideoTileState](https://aws.github.io/amazon-chime-sdk-ios/Classes/VideoTileState.html) will contain further information such as if the video tile is for the local attendee. Video tiles start without a video view bound to it.

You can view content share the same way that you view a remote attendee's video. The video tile state will contain additional information to distinguish if that video tile is for content share.

### 8a. Sending video

Video permissions are required for sending the local attendee's video.

To start sending the local attendee's video, call meetingSession.audioVideo.[startLocalVideo()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)startLocalVideoAndReturnError:).

To stop sending the local attendee's video, call meetingSession.audioVideo.[stopLocalVideo()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)stopLocalVideo).

### 8b. Getting and switching video device

When starting the local attendee's video, the underlying media client will use the active video device or the front facing camera if there is no active video device. You can use the following methods to get or switch the active video device.

To get the active video device, call meetingSession.audioVideo.[getActiveCamera()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/DeviceController.html#/c:@M@AmazonChimeSDK@objc(pl)DeviceController(im)getActiveCamera).

To switch the active video device, call meetingSession.audioVideo.[switchCamera()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/DeviceController.html#/c:@M@AmazonChimeSDK@objc(pl)DeviceController(im)switchCamera).

### 8c. Receiving video

To start receiving video from remote attendees, call meetingSession.audioVideo.[startRemoteVideo()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)startRemoteVideo).

To stop receiving video from remote attendees, call meetingSession.audioVideo.[stopRemoteVideo()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)stopRemoteVideo).

### 8d. Adding a video tile observer

You will need to implement a [VideoTileObserver](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileObserver.html) and register the observer with the audio video facade to receive video tile events for displaying video.

To add a VideoTileObserver, call meetingSession.audioVideo.[addVideoTileObserver(observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileControllerFacade(im)addVideoTileObserverWithObserver:).

To remove a VideoTileObserver, call meetingSession.audioVideo.[removeVideoTileObserver(observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileControllerFacade(im)removeVideoTileObserverWithObserver:).

A VideoTileObserver has the following methods:

* [videoTileDidAdd(tileState:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileObserver.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileObserver(im)videoTileDidAddWithTileState:): called when an attendee starts sharing video
* [videoTileDidRemove(tileState:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileObserver.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileObserver(im)videoTileDidRemoveWithTileState:): called when an attendee stops sharing video
* [videoTileDidPause(tileState:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileObserver.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileObserver(im)videoTileDidPauseWithTileState:): called when a video tile's pause state changes from Unpaused
* [videoTileDidResume(tileState:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileObserver.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileObserver(im)videoTileDidResumeWithTileState:): called when a video tile's pause state changes to Unpaused
* [videoTileSizeDidChange(tileState:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileObserver.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileObserver(im)videoTileSizeDidChangeWithTileState:): called when a video steam content size changes

A pause or resume event can occur when the underlying media client pauses the video tile for connection reasons or when the pause or resume video tile methods are called.

The video tile state is represented with a [VideoPauseState](https://aws.github.io/amazon-chime-sdk-ios/Enums/VideoPauseState.html) that describes whether it is paused and if so why (e.g., paused by user request, or paused for poor connection).

### 8e. Binding a video tile to a video view

To display video, you will also need to bind a video view to a video tile. Create a [VideoRenderView](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoRenderView.html) and bind that view to the video tile in VideoTileObserver's `onVideoTileAdded` method. You can use [DefaultVideoRenderView](https://aws.github.io/amazon-chime-sdk-ios/Classes/DefaultVideoRenderView.html) or customize the behavior by implementing the
VideoRenderView interface.

To bind a video tile to a view, call meetingSession.audioVideo.[bindVideoView(videoView:tileId:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileControllerFacade(im)bindVideoViewWithVideoView:tileId:).

To unbind a video tile from a view, call meetingSession.audioVideo.[unbindVideoView(tileId:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileControllerFacade(im)unbindVideoViewWithTileId:).

### 8f. Pausing a remote video tile

To pause a remote attendee's video tile, call meetingSession.audioVideo.[pauseRemoteVideoTile(tileId:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileControllerFacade(im)pauseRemoteVideoTileWithTileId:).

To resume a remote attendee's video tile, call meetingSession.audioVideo.[resumeRemoteVideoTile(tileId:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoTileControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)VideoTileControllerFacade(im)resumeRemoteVideoTileWithTileId:).

## 9. Receiving metrics (optional)

You can receive events about available audio and video metrics by implementing a [MetricsObserver](https://aws.github.io/amazon-chime-sdk-ios/Protocols/MetricsObserver.html) and registering the observer with the audio video facade. Events occur on a one second interval.

To add a MetricsObserver, call meetingSession.audioVideo.[addMetricsObserver(observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)addMetricsObserverWithObserver:).

To remove a MetricsObserver, call meetingSession.audioVideo.[removeMetricsObserver(observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)removeMetricsObserverWithObserver:).

A MetricsObserver has the following method:

* [onMetricsReceived](https://aws.github.io/amazon-chime-sdk-ios/Protocols/MetricsObserver.html): called when audio/video related metrics are received

## 10. Send and receive data messages (optional)
Attendees can broadcast small (2KB max) data messages to other attendees. Data messages can be used to signal attendees of changes to meeting state or develop custom collaborative features. Each message is sent on a particular topic, which allows you to tag messages according to their function to make it easier to handle messages of different types.

To send a message on a given topic, meetingSession.audioVideo.[realtimeSendDataMessage(topic:data:lifetimeMs:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeControllerFacade(im)realtimeSendDataMessageWithTopic:data:lifetimeMs:error:). When sending a message, the media server stores the messages for the duration of `lifetimeMs` specified. Up to 1024 messages may be stored for a maximum of 5 minutes. Any attendee joining late or reconnecting will automatically receive the messages in this buffer once they connect. You can use this feature to help paper over gaps in connectivity or give attendees some context into messages that were recently received.

To receive messages on a given topic, implement a [DataMessageObserver](https://aws.github.io/amazon-chime-sdk-ios/Protocols/DataMessageObserver.html) and subscribe it to the topic using meetingSession.audioVideo.[addRealtimeDataMessageObserver(topic:observer:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeControllerFacade(im)addRealtimeDataMessageObserverWithTopic:observer:). In the observer, you receive a [DataMessage](https://aws.github.io/amazon-chime-sdk-ios/Classes/DataMessage.html) containing the payload of the message and other metadata about the message.

To unsubscribe the receive message observers, call meetingSession.audioVideo.[removeRealtimeDataMessageObserverFromTopic(topic:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/RealtimeControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)RealtimeControllerFacade(im)removeRealtimeDataMessageObserverFromTopicWithTopic:), which removes all observers for the topic.

If you send too many messages at once, your messages may be returned to you with the [throttled](https://aws.github.io/amazon-chime-sdk-ios/Classes/DataMessage.html#/c:@M@AmazonChimeSDK@objc(cs)DataMessage(py)throttled) flag set. If you continue to exceed the throttle limit, the server may hang up the connection.

Note: You can only send and receive data message when audio video is started. Make sure to call meetingSession.audioVideo.[start()](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)startAndReturnError:) or meetingSession.audioVideo.[start(callKitEnabled:)](https://aws.github.io/amazon-chime-sdk-ios/Protocols/AudioVideoControllerFacade.html#/c:@M@AmazonChimeSDK@objc(pl)AudioVideoControllerFacade(im)startWithCallKitEnabled:error:) before sending messages. To receive messages from the server, subscribe the `DataMessageObserver` to the topic, and do so before starting audio video to avoid missing messages.