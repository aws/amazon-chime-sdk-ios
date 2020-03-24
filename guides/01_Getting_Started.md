# Amazon Chime SDK for iOS

## Getting Started

This guide contains a quick explanation of initializing the meeting session and using that to 
access audio and video features. For more information, please refer to the [SDK Documentation](https://aws.github.io/amazon-chime-sdk-ios/)
or refer to the demo app.

## Permissions
Before calling the APIs to start audio and video, the app will need microphone and camera 
permissions from the user.

In Xcode, open `Info.plist` and add `NSMicrophoneUsageDescription` and `NSCameraUageDescription` 
to the property list. This will allow the app to ask for microphone and camera permissions.

After doing the above, include the following code in your app to request permission:
```
AVAudioSession.sharedInstance().requestRecordPermission

AVCaptureDevice.requestAccess(for: .video)
```

Calling the APIs without having the above permissions granted will result in a `PermissionError`.

## Getting Meeting Info

The first step is to get various parameters about the meeting. The client application will receive 
this information from the server application. It is up to the builder to decide on how the client
application and server application communicates. 

For testing purposes, you can deploy the serverless demo from [amazon-chime-sdk-js](https://github.com/aws/amazon-chime-sdk-js). 
After the deployment you will have a URL (which this guide will refer to as `server_url`)

To get the meeting info make a POST request to:
```
"\(server_url)join?title=\(meetingId)&name=\(attendeeName)&region=\(meetingRegion)"
```

These are the parameters to include in the request:
* title: Meeting ID for the meeting to join
* name: Attendee name to join the meeting with
* region: "One of the 14 regions supported by the AWS SDK, for example "us-east-1""

## Create MeetingSessionConfiguration

Parse the JSON response obtained from your server application to create the `MeetingSessionConfiguration` object. 

```
let meetingResponse = try jsonDecoder.decode(MeetingResponse.self, from: data)
let meetingResp = CreateMeetingResponse(meeting:
    Meeting(meetingId: meetingResponse.joinInfo.meeting.meetingId,
        mediaPlacement: MediaPlacement(audioFallbackUrl: meetingResponse.joinInfo.meeting.mediaPlacement.audioFallbackUrl,
                                       audioHostUrl: meetingResponse.joinInfo.meeting.mediaPlacement.audioHostUrl,
                                       turnControlUrl: meetingResponse.joinInfo.meeting.mediaPlacement.turnControlUrl,
                                       signalingUrl: meetingResponse.joinInfo.meeting.mediaPlacement.signalingUrl)))
let attendeeResp = CreateAttendeeResponse(attendee:
    Attendee(attendeeId: meetingResponse.joinInfo.attendee.attendeeId,
             joinToken: meetingResponse.joinInfo.attendee.joinToken))

return (meetingResp, attendeeResp)
```

```
let meetingSessionConfig = MeetingSessionConfiguration(
    createMeetingResponse: meetingResp,
    createAttendeeResponse: attendeeResp
)
```

## Create MeetingSession

Create the `DefaultMeetingSession` using the `MeetingSessionConfiguration` object.

```
self.currentMeetingSession = DefaultMeetingSession(
    configuration: meetingSessionConfig,
    logger: logger
)
```

## Access AudioVideoFacade

### Audio

To start audio:
```
do {
    try self.currentMeetingSession?.audioVideo.start()
} catch PermissionError.audioPermissionError {
} catch {}
```

To stop audio:
```
self.currentMeetingSession?.audioVideo.stop()
```

To listen to AudioClient’s lifecycle events:
```
self.currentMeetingSession?.audioVideo.addAudioVideoObserver(AudioVideoObserver)

self.currentMeetingSession?.audioVideo.removeAudioVideoObserver(AudioVideoObserver)
```

A class implementing `AudioVideoObserver` would need to implement the following:

```
audioSessionDidStartConnecting(reconnecting: Bool)

audioSessionDidStart(reconnecting: Bool)

audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus)

audioSessionDidCancelReconnect()

connectionDidRecover()

connectionDidBecomePoor()

videoSessionDidStartConnecting()

videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus)

videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus)
```

To Mute the Microphone:
```
self.currentMeetingSession?.audioVideo.realtimeLocalMute()
```

To Unmute the Microphone:
```
self.currentMeetingSession?.audioVideo.realtimeLocalUnmute()
```

To listen to real time events such as volume update, signal update, and attendee join / leave events:
```
self.currentMeetingSession?.audioVideo.addRealtimeObserver(RealtimeObserver)

self.currentMeetingSession?.audioVideo.removeRealtimeObserver(RealtimeObserver)
```

A class implementing `RealtimeObserver` would need to implement the following:

```
volumeDidChange(volumeUpdates: [VolumeUpdate])

signalStrengthDidChange(signalUpdates: [SignalUpdate])

attendeesDidJoin(attendeeInfo: [AttendeeInfo])

attendeesDidLeave(attendeeInfo: [AttendeeInfo])

attendeesDidMute(attendeeInfo: [AttendeeInfo])

attendeesDidUnmute(attendeeInfo: [AttendeeInfo])
```

To detect active speaker:
```
self.currentMeetingSession?.audioVideo.addActiveSpeakerObserver(policy: DefaultActiveSpeakerPolicy(), observer: self)
```

A class implementing `ActiveSpeakerObserver` would need to implement the following:

```
scoresCallbackIntervalMs: Int

activeSpeakerDidDetect(attendeeInfo: [AttendeeInfo])

activeSpeakerScoreDidChange(scores: [AttendeeInfo: Double])
```

That class will also need to provide an `observerId`:
```
extension MeetingViewController: ActiveSpeakerObserver {
    var observerId: String {
        return self.uuid
    }
}
```

You can also define a logic to determine who are the active speakers by implementing `ActiveSpeakerPolicy` or use the default implementation `DefaultActiveSpeakerPolicy`. 

A class implementing `ActiveSpeakerPolicy` would need to implement the following:
```
calculateScore(attendeeInfo: AttendeeInfo, volume: VolumeLevel) -> Double

prioritizeVideoSendBandwidthForActiveSpeaker() -> Bool
```

Note that the default implementations of other components currently do not do anything with the result of `prioritizeVideoSendBandwidthForActiveSpeaker`

### Devices

To list audio devices:
```
self.currentMeetingSession?.audioVideo.listAudioDevices()
```

To select an audio device to use:
```
self.currentMeetingSession?.audioVideo.chooseAudioDevice(MediaDevice)
```

To listen to audio device changes:
```
self.currentMeetingSession?.audioVideo.addDeviceChangeObserver(DeviceChangeObserver)

self.currentMeetingSession?.audioVideo.removeDeviceChangeObserver(DeviceChangeObserver)
```

A class implementing `DeviceChangeObserver` would need to implement the following:

```
audioDeviceDidChange(freshAudioDeviceList: [MediaDevice])
```

### Metrics

To listen to metrics:
```
self.currentMeetingSession?.audioVideo.addMetricsObserver(MetricsObserver)

self.currentMeetingSession?.audioVideo.removeMetricsObserver(MetricsObserver)
```

A class implementing `MetricsObserver` would need to implement the following:
```
metricsDidReceive(metrics: [AnyHashable: Any])
```

### Video

To start self video (local video):
```
self.currentMeetingSession?.audioVideo.startLocalVideo()
```

To stop self video (local video):
```
self.currentMeetingSession?.audioVideo.stopLocalVideo()
```

To start remote video:
```
self.currentMeetingSession?.audioVideo.startRemoteVideo()
```

To stop remote video:
```
self.currentMeetingSession?.audioVideo.stopRemoteVideo()
```

To switch camera:
```
self.currentMeetingSession?.audioVideo.switchCamera()
```

To get active camera:
```
self.currentMeetingSession?.audioVideo.getActiveCamera()
```

### Working with video view
In order to bind a video source to the UI, implement `VideoTileObserver`, which has the following:

```
videoTileDidAdd(tileState: VideoTileState)

videoTileDidRemove(tileState: VideoTileState)

videoTileDidPause(tileState: VideoTileState)

videoTileDidResume(tileState: VideoTileState)
```

To add `VideoTileObserver`:
```
self.currentMeetingSession?.audioVideo.addVideoTileObserver(VideoTileObserver)
```

To remove `VideoTileObserver`:
```
self.currentMeetingSession?.audioVideo.removeVideoTileObserver(VideoTileObserver)
```

After receiving a `VideoTileState` from the video tile events, use it to bind the UI view to the video stream:
```
self.currentMeetingSession?.audioVideo.bindVideoView(videoView: VideoRenderView, tileId: Int)
```

To unbind the UI view from the video stream:
```
self.currentMeetingSession?.audioVideo.unbindVideoView(tileId: Int)
```

To pause remote video:
```
self.currentMeetingSession?.audioVideo.pauseRemoteVideoTile(tileId)
```

To resume remote video:
```
self.currentMeetingSession?.audioVideo.resumeRemoteVideoTile(tileId)
```

### VideoRenderView
In order to render frames from the video client, the UIView needs to implement the `VideoRenderView` protocol:

```
func renderFrame(frame: Any?)
```
