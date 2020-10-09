# Getting Started

## Prerequisites

* You have read [Building a Meeting Application using the Amazon Chime SDK](https://aws.amazon.com/blogs/business-productivity/building-a-meeting-application-using-the-amazon-chime-sdk/). You understand the basic architecture of Amazon Chime SDK and deployed a serverless/browser demo meeting application.
* You have a basic to intermediate understanding of iOS development and tools.
* You have installed Xcode version 11.0 or later.

Note: Deploying the serverless/browser demo and receiving traffic from the demo created in this post can incur AWS charges.

## Configure your application

To declare the Amazon Chime SDK as a dependency, you must complete the following steps.

1. Follow the steps in the *Setup* section in the [README](https://github.com/aws/amazon-chime-sdk-ios/blob/master/README.md) file to download and import the Amazon Chime SDK.
2. Add `Privacy - Microphone Usage Description` and `Privacy - Camera Usage Description` to the `Info.plist` of your Xcode project.
3. Request microphone and camera permissions. You can use `AVAudioSession.recordPermission` and `AVCaptureDevice.authorizationStatus` by handling the response synchronously and falling back to requesting permissions. You can also use `requestRecordPermission` and `requestAccess` with an asynchronous completion handler.
```
switch AVAudioSession.sharedInstance().recordPermission {
  case AVAudioSessionRecordPermission.granted:
    // You can use audio.
    ...
  case AVAudioSessionRecordPermission.denied:
    // You may not use audio. Your application should handle this.
    ...
  case AVAudioSessionRecordPermission.undetermined:
    // You must request permission.
    AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
      if granted {
        ...
      } else {
        // The user rejected your request.
      }
    })
}

// Request permission for video. You can similarly check
// using AVCaptureDevice.authorizationStatus(for: .video).
AVCaptureDevice.requestAccess(for: .video)
```

## Create a meeting session

To start a meeting, you need to create a meeting session. We provide `DefaultMeetingSession` as an actual implementation of the protocol `MeetingSession`. `DefaultMeetingSession` takes in both `MeetingSessionConfiguration` and `ConsoleLogger`.

1. Create a `ConsoleLogger` for logging.
```
let logger = ConsoleLogger(name: "MeetingViewController")
```
2. Make a POST request to `server_url` to create a meeting and an attendee. The `server_url` is the URL of the serverless demo meeting application you deployed (see Prerequisites section).
Note: use `https://xxxxx.xxxxx.xxx.com/Prod/` instead of v2 url.
```
var url = "\(server_url)join?title=\(meetingId)&name=\(attendeeName)&region=\(meetingRegion)"
url = encodeStrForURL(str: url)

// Helper function for URL encoding.
public static func encodeStrForURL(str: String) -> String {
    return str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? str
}
```
3. Create a `MeetingSessionConfiguration`. JSON response of the POST request contains data required for constructing a `CreateMeetingResponse` and a `CreateAttendeeResponse`.
```
let joinMeetingResponse = try jsonDecoder.decode(MeetingResponse.self, from: data)

// Construct CreatMeetingResponse and CreateAttendeeResponse.
let meetingResp = CreateMeetingResponse(meeting:
    Meeting(
        externalMeetingId: joinMeetingResponse.joinInfo.meeting.meeting.externalMeetingId,
        mediaPlacement: MediaPlacement(
            audioFallbackUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.audioFallbackUrl,
            audioHostUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.audioHostUrl,
            signalingUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.signalingUrl,
            turnControlUrl: joinMeetingResponse.joinInfo.meeting.meeting.mediaPlacement.turnControlUrl
        ),
        mediaRegion: joinMeetingResponse.joinInfo.meeting.meeting.mediaRegion,
        meetingId: joinMeetingResponse.joinInfo.meeting.meeting.meetingId
    )
)

let attendeeResp = CreateAttendeeResponse(attendee:
    Attendee(attendeeId: joinMeetingResponse.joinInfo.attendee.attendee.attendeeId,
        externalUserId: joinMeetingResponse.joinInfo.attendee.attendee.externalUserId,
        joinToken: joinMeetingResponse.joinInfo.attendee.attendee.joinToken
    )
)

// Construct MeetingSessionConfiguration.
let meetingSessionConfig = MeetingSessionConfiguration(
    createMeetingResponse: currentMeetingResponse,
    createAttendeeResponse: currentAttendeeResponse
)
```
4. Now create an instance of `DefaultMeetingSession`.
```
let currentMeetingSession = DefaultMeetingSession(
    configuration: meetingSessionConfig,
    logger: logger
)
```

## Access AudioVideoFacade

`AudioVideoFacade` is used to control audio and video experience. Inside the `DefaultMeetingSession` object, `audioVideo` is an instance variable of type `AudioVideoFacade`.

1. To start audio, you can call start on `AudioVideoFacade`.
```
do {
    try self.currentMeetingSession?.audioVideo.start()
} catch PermissionError.audioPermissionError {
    // Handle the case where no permission is granted.
} catch {
    // Catch other errors.
}
```
2. You can turn local audio on and off by calling the mute and unmute APIs.
```
// Mute audio.
self.currentMeetingSession?.audioVideo.realtimeLocalMute()
// Unmute audio.
self.currentMeetingSession?.audioVideo.realtimeLocalUnmute()
```
3. There are two sets of APIs for starting and stopping video. `startLocalVideo` and `stopLocalVideo` are for turning on and off the camera on the user’s device. `startRemoteVideo` and `stopRemoteVideo` are for receiving videos from other participants on the same meeting.
```
// Start local video.
do {
    try self.currentMeetingSession?.audioVideo.startLocalVideo()
} catch PermissionError.videoPermissionError {
    // Handle the case where no permission is granted.
} catch {
    // Catch some other errors.
}

// Start remote video.
self.currentMeetingSession?.audioVideo.startRemoteVideo()

// Stop local video.
self.currentMeetingSession?.audioVideo.stopLocalVideo()

// Stop remote video.
self.currentMeetingSession?.audioVideo.stopRemoteVideo()
```
4. You can switch the camera for local video between front-facing and rear-facing. Call `switchCamera` and have different logic based on the camera type returned by calling `getActiveCamera`.
```
self.currentMeetingSession?.audioVideo.switchCamera()

// Add logic to respond to camera type change.
switch self.currentMeetingSession?.audioVideo.getActiveCamera().type {
case MediaDeviceType.videoFrontCamera:
    ...
case MediaDeviceType.videoBackCamera:
    ...
default:
    ...
}
```

## Render a video tile

By implementing `videoTileDidAdd` and `videoTileDidRemove` on the `VideoTileObserver`, you can track the currently active video tiles. The video track can come from either camera or screen share.

`DefaultVideoRenderView` is used to render the frames of videos on `UIImageView`. Once you have both `VideoTileState` and a `DefaultVideoRenderView`, you can bind them by calling `bindVideoView`.
```
// Register the observer.
audioVideo.addVideoTileObserver(observer: VideoTileObserver)

func videoTileDidAdd(tileState: VideoTileState) {
    logger.info(msg: "Video tile added, titleId: \(tileState.tileId), attendeeId: \(tileState.attendeeId), isContent: \(tileState.isContent)")

    showVideoTile(tileState)
}

func videoTileDidRemove(tileState: VideoTileState) {
    logger.info(msg: "Video tile removed, titleId: \(tileState.tileId), attendeeId: \(tileState.attendeeId)")

    // Unbind the video tile to release the resource
    audioVideo.unbindVideoView(tileId)
}

// It could be remote or local video.
func showVideoTile(_ tileState: VideoTileState) {
    // Render the DefaultVideoRenderView

    //Bind the video tile to the DefaultVideoRenderView
    audioVideo.bindVideoView(someDefaultVideoRenderView, tileState.tileId)
}
```

## Test

After building and running your iOS application, you can verify the end-to-end behavior. Test it by joining the same meeting from your iOS device and a browser (using the demo application you set up in the prerequisites).

## Cleanup

If you no longer want to keep the demo active in your AWS account and want to avoid incurring AWS charges, the demo resources can be removed. Delete the two [AWS CloudFormation](https://aws.amazon.com/cloudformation/) stacks created in the prerequisites that can be found in the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation/home).
