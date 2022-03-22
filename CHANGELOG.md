## [Unreleased]

### Added
* Added [replicated meeting guide](https://github.com/aws/amazon-chime-sdk-android/blob/master/guides/replicated_meetings.md).

### Fixed
* Added proper call of demotion callback on audio or video disconnection.

## [0.19.1] - 2022-03-10

### Fixed
* [Demo] Added overridden endpoint url capability to live transcription API.

### Added

* Added support to live transcription for new features including personally identifiable information content identification and redaction, partial results stabilization, custom language models, and language identification for Amazon Transcribe and PHI content identification for Amazon Transcribe Medical.
* [Demo] Added language identification configuration for live transcription API.

## [0.19.0] - 2022-02-24

### Added
* Added the meetingStartDurationMs event in ingestionEvents to record the time that elapsed between the start request and the beginning of the meeting.
* Added priority based downlink policy to control the way how a recipient subscribes to the remote video sources. i.e. `updateVideoSourceSubscriptions(_:_:)` in `VideoClientController`.

## [0.18.1] - 2022-02-10

## [0.18.0] - 2021-12-21

### Changed
* Changed ContentShareController to use inbound turn credentials

### Added
* Added APIs for Audio Video configuration i.e `AudioVideoConfiguration` to be used during a meeting session.
* Added support for joining meetings using one of `AudioMode.Mono16K`, `AudioMode.Mono48K` and `AudioMode.Stereo48K` audio modes.
* **Breaking** The `AudioMode.Stereo48K` will be set as the default audio mode if not explicitly specified when starting the audio session. Earlier, Mono/16KHz audio was the default and the only audio mode supported.
* [Demo] Added ways to join a meeting using various audio modes.

## [0.17.0] - 2021-11-01

### Added
* Supports integration with Amazon Transcribe and Amazon Transcribe Medical for live transcription. The Amazon Chime Service uses its active talker algorithm to select the top two active talkers, and sends their audio to Amazon Transcribe (or Amazon Transcribe Medical) in your AWS account. User-attributed transcriptions are then sent directly to every meeting attendee via data messages. Use transcriptions to overlay subtitles, build a transcript, or perform real-time content analysis. For more information, visit [the live transcription guide](https://docs.aws.amazon.com/chime/latest/dg/meeting-transcription.html).
* [Demo] Added meeting captions functionality based on the live transcription APIs. You will need to have a serverless deployment to create new AWS Lambda endpoints for live transcription. Follow [the live transcription guide](https://docs.aws.amazon.com/chime/latest/dg/meeting-transcription.html) to create necessary service-linked role so that the demo app can call Amazon Transcribe and Amazon Transcribe Medical on your behalf.

### Fixed
* Fixed an issue that returns the `Other` type one of 2 duplicate audio devices on iOS 15.

## [0.16.6] - 2021-10-14

### Fixed
* Fixed an issue where sending a ByteArray through data message fails

## [0.16.5] - 2021-09-30

## Changed
* Exposed torch availability 

### Fixed
* Fixed an issue where audio session is stopped when switch between bluetooth device and speaker.
* Fixed an issue on iOS 15 where `DefaultDeviceController` returns a duplicate entry for bluetooth audio device in `listAudioDevices()`.

## [0.16.4] - 2021-07-21
### Removed
* **Breaking (internal APIs)** Removed unused and incorrect `isDeviceFrontFacing` and `setFrontCameraAsCurrentDevice` from internal `VideoClientController`.  Removed internal `VideoDevice` constructors for `MediaDevice`.

## [0.16.3] - 2021-06-24

### Added
* Added events ingestion to report meeting events to Amazon Chime backend.

### Fixed
* [Documentation] Fixed active speaker observer example in README which if used caused a memory leak.
* [Demo] Fixed video flickering when active speaker updates.

## 2021-05-10

### Fixed
* [Documentation] Added sample code to the meeting event guide
* [Documentation] Fixed documentation to say `Amazon Voice Focus` instead of `voice focus`
* [Documentation] Updated instruction of enabling content share in README

## [0.16.2] - 2021-04-14

### Changed
* Disabled simulcast for P2P calls, which helps improving video quality of two-party meetings.

## [0.16.1] - 2021-03-04

### Added
* Added additional constructor of `MeetingSessionConfiguration` to create it without `externalMeetingId`

### Fixed
* Fixed an issue where `VideoCaptureFormat` and `DefaultModality` are not exposed to ObjC.
* Fixed a concurrency issue on `DefaultCameraCaptureSource` between `start()` and `stop()` invocations.
* Fixed an issue where `MeetingHistoryEvent` did not expose its properties.
* Fixed `CreateMeetingResponse` and `MeetingSessionConfiguration` to have nullable `externalMeetingId` since this is not required.
* [Demo] Fixed demo application to handle null `externalMeetingId`.
* [Demo] Fixed demo application where `InAppScreenShare` doesn't restart due to observer not added.

### Changed
* Enabled send-side bandwidth estimation in video client, which improves video quality in poor network conditions.

## [0.16.0] - 2021-02-24

### Added
* Pass SDK metadata to Media AudioClient for metrics.

### Fixed
* Fixed few memory leaks in the SDK layer.
  * Fixed a memory leak that occurred stopping meeting with just audio.
  * Fixed a memory leak that occurred stopping meeting when local video was on.
  * Fixed a memory leak that occurred stopping meeting when content share was on.
  * `DefaultAudioClientController` takes additional parameter of `ActiveSpeakerDetectorFacade`
  * **Breaking** `DefaultAudioVideoController` takes additional parameter of `VideoTileController`.
  * [Demo] Demo application is updated to remove observer or sink it adds.
  * **Breaking** `DefaultActiveSpeaker` no longer depends on `AudioClientObserver`.

## [0.15.0] - 2021-02-04

### Added
* Added support for XCFramework. AmazonChimeSDK and AmazonChimeSDKMedia binaries now contain .xcframework format as well. See `README.md` for updated Setup instructions.
* Added Analytics
    * Added `EventAnalyticsController`, `EventAnalyticsFacade`, `EventAnalyticsObserver` to handle analytics.
    * Added `EventAttributesName`, `EventName` for meeting event information.
    * Added `externalMeetingId` to property of `MeetingSessionConfiguration`.
    * **Breaking** Added `eventAnalyticsController` to property of `MeetingSession`.
    * [Demo] Added `PostLogger` to demonstrate making HTTP POST request to server with logs.
    * [Documentation] Added usage guide for analytics.

### Changed
* Analytics
  * Changed to take `EventAnalyticsController` as an additional parameter of `DefaultAudioClientObserver`, `DefaultAudioClientController` constructor.
  * **Breaking** Changed to take `EventAnalyticsController` as an additional parameter of `DefaultAudioVideoFacade` constructor.

## Fixed
* Fixed data message conversion that sometimes does not handle null terminator when converting from string to c-string. (Issue #217)

## [0.14.0] - 2021-01-21

### Added
* **Breaking** Added content share metrics as new enums in `ObservableMetric`.
* Added content share APIs that supports a 2nd video sending stream such as screen capture, read [content share guide](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/content_share.md) for details.
* Added in app only screen share to demo app.
* Added `AmazonChimeSDKDemoBroadcast` Broadcast Upload Extension to the demo app to share device level screen.
* Added message for video tiles paused by poor network in demo app.
* Update demo application to pause/resume remote videos and stop/start local video when app is in background/foreground
* [Documentation] Added usage documentation.

### Fixed
* Fix the demo application bug that front camera video was not mirrored without selecting video device on the video preview page.
* Fix the ObjC demo application issue that remote VideoRenderView was not cleared when remote video tile was removed.

### Changed
* **Breaking** `AudioVideoFacade` now also implements `ContentShareController`.
* **Breaking** `DefaultAudioVideoFacade` init requires a `ContentShareController` instance.
* Update text of additional options on demo app.
* `MeetingSessionURLs` and `MeetingSessionCredentials` now conform to `Codable`.
* Changes that support a speed up of video client initialization. `videoClientRequestTurnCreds` callback will only be invoked as a backup for media layer logic. The signaling url is now passed into video client start. A new callback `videoClientTurnURIsReceived` will be invoked when TURN uris are received by the client. This allows urls to be modified with urlRewriter or customer builder logic.

## [0.13.1] - 2021-01-08

### Fixed
* Fix a bug that internal capture source was not stopped properly when the video client was being stopped. (Issue [#200](https://github.com/aws/amazon-chime-sdk-ios/issues/200))
* Fix a bug that `self` was weakly-referenced incorrectly in several closures and caused `audioClient.stopSession()` not being called as expected. (Issue [#193](https://github.com/aws/amazon-chime-sdk-ios/issues/193))

## [0.13.0] - 2020-12-17

### Changed
* **Breaking** Remove the internal video tile mapping entry not only when the video is *unbound*, but also when the video is *removed*. This fixes [`videoTileDidAdd(tileState)` is sometimes not called issue](https://github.com/aws/amazon-chime-sdk-android/issues/186), and provides better API symmetry so that builders no longer need to call `unbindVideoView(tileId:)` if they did not call `bindVideoView(videoView:tileId:)`.
  * After this fix, the internal video tile mapping entry will be removed before `videoTileDidRemove(tileState:)` callback is called. Please check your `VideoTileObserver`s and make sure your `videoTileDidRemove(tileState:)` handlers do not call any SDK APIs that depend on the existance of video tiles (e.g. `bindVideoView(videoView:tileId:)`).

## [0.12.2] - 2020-12-11

## [0.12.1] - 2020-11-20

## [0.12.0] - 2020-11-17

### Added
* Added new APIs in `RealtimeControllerFacade` to enable/disable Amazon Voice Focus (ML-based noise suppression) and get the on/off status of Amazon Voice Focus.
* Added Amazon Voice Focus feature in Swift demo app.
* Added more verbose logging from media layer to SDK layer for builders to control log level. Set `LogLevel` to `INFO` or above for production application to not be bombarded with logs.
* Added `getActiveAudioDevice` API in `DefaultDeviceController`.
* Added `VideoFrame`, `VideoRotation`, `VideoContentHint`, `VideoFrameBuffer`, `VideoFramePixelBuffer` classes, enums, and interfaces to hold video frames of various raw types.
* Added `VideoSource` and `VideoSink` to facilitate transfer of `VideoFrame` objects.
* Added `CameraCaptureSource`, `CaptureSourceError`, `CaptureSourceObserver`, `VideoCaptureFormat`, and `VideoCaptureSource` interfaces and enums to facilitate releasing capturers as part of the SDK.
* Added `DefaultCameraCaptureSource` implementation of `CameraCaptureSource`.
* Added `listVideoDevices` and `listSupportedVideoCaptureFormats` to `MediaDevice.Companion`.
* Added TURN uris received callback.

### Fixed
* Fixed `DefaultDeviceController` not removing itself as observer from `NotificationCenter` after deallocation and causes crash in Swift demo app.
* Fixed a crash in Swift demo app when user opens the device selection Action Sheet in iPad.
* Fixed a crash in Swift demo app when building with Xcode 12: `DefaultActiveSpeakerPolicy.init()` not implemented.
* Fixed a bug in Swift demo app: self video disappears when a remote video tile is added.
* Fixed a bug in Swift demo app: MeetingModel is not deallocated properly after meeting ends.
* **Breaking** Changed behavior to no longer call `videoTileSizeDidChange` when a video is paused to fix a bug where pausing triggered this callback with width=0 and height=0.
* Fixed `videoTileDidAdd` not being called for paused tiles.

### Changed
* **Breaking** Changed default log level of `ConsoleLogger` to INFO.
* The render path has been changed to use `VideoFrame`s for consistency with the send side, this includes:
  * **Breaking** `VideoTileController.onReceiveFrame` now takes `VideoFrame?` instead of `CVPixelBuffer?`.
    * Builders with a custom `VideoTileController` will have to update APIs correspondingly. All current `VideoFrame` objects used by the SDK will contain `VideoFramePixelBuffer` buffers, which contain `CVPixelBuffer`s internally.
  * **Breaking** `VideoTile.renderFrame` now takes `VideoFrame` instead of `CVPixelBuffer?` and has been replaced by extending `VideoSink` and using `onReceivedVideoFrame`.
    * Builders with a custom `VideoTile` will have to update APIs correspondingly. All current `VideoFrame` objects used by the SDK will contain `VideoFramePixelBuffer` buffers, which contain `CVPixelBuffer`s internally.
  * **Breaking** `VideoRenderView` is now just a `VideoSink` (i.e. it now accepts `VideoFrame` object via `VideoSink.onReceivedVideoFrame` rather then `CVPixelBuffer?` via `render`).
    * Builders with a custom `VideoTile` will have to update APIs correspondingly. All current `VideoFrame` objects used by the SDK will contain `VideoFramePixelBuffer` buffers, which contain `CVPixelBuffer`s internally.
* If no custom source is provided, the SDK level video client will use a `DefaultCameraCaptureSource` instead of relying on capture implementations within the AmazonChimeSDKMedia framework; though behavior should be identical, please open an issue if any differences are noticed.
* Added additional, optional `id` (unique ID) parameter to `MediaDevice` for video capture devices.

## [0.11.1] - 2020-10-23

### Changed
* Changed the max number of remote video tiles per page in the Swift demo app from 2 to 6.

## [0.11.0] - 2020-10-08

### Changed
* **Breaking** The returned label for the Built-In Speaker `MediaDevice` has been changed from "Build-in Speaker" to "Buil*t*-in Speaker".
* **Breaking** `timestampMs` on `DataMessage` type is changed to `Int64` to prevent overflow on 32-bit system.
* Changed `maxRemoteVideoTileCount` in the Swift demo app from 8 to 16. Now the Swift demo app can support at most 16 remote video tiles.

### Fixed
- Fixed a crash when joining meeting on device with 32-bit system (iPhone 5/5c) due to integer overflow in `DefaultActiveSpeakerDetector`
- Fixed a crash when sending DataMessage on 32-bit system (iPhone 5/5c)
- Fixed a crash when opening ObjC demo app on iPhone 5/5c

## [0.10.0] - 2020-09-10

### Removed
* **Breaking** Removed audio permission check in `DefaultAudioVideoController` which is performed in `DefaultAudioClientController`. For developers who has their own `AudioClientController` implementation, please make sure to check audio permission in `start()`.

## [0.9.0] - 2020-09-01

### Fixed
- Fixed a bug that attendee events got filtered out due to absence of `externalUserId`
- `DefaultDeviceController` now uses the correct `MediaDeviceType` for the default Built-In Speaker. ([#62](https://github.com/aws/amazon-chime-sdk-ios/issues/62))

### Added
* **Breaking** Added additional `externalUserId` field for `MeetingSessionCredentials`
* Added video pagination feature in the Swift demo app. Remote videos will be paginated into several pages. Each page contains at most 2 remote videos, and user can switch between different pages. Videos that are not being displayed will not consume any network bandwidth or computation resource.
* Added active-speaker-based video tile feature in the Swift demo app. Video tiles of active speakers will be promoted to the top of the list automatically.

### Changed
* **Breaking** Changed the behavior of `DefaultVideoRenderView` so that it clears the internal `ImageView` when it receives a nil frame.
* Changed the Swift demo app so that it will not subscribe to video streams when user is not viewing the Videos tab.

### Fixed
* Fixed a bug that attendee events got filtered out due to absence of `externalUserId`
* Fixed the video flicker issue when binding video tile to a recycled `DefaultVideoRenderView`.
* Fixed the local video binding issue when local video was not enabled yet.

## [0.8.2] - 2020-08-13

## [0.8.1] - 2020-07-31

### Added
- Added data message API

## [0.8.0] - 2020-07-20

### Added
- **Breaking** Added `videoTileSizeDidChange` API in `VideoTileObserver` for video stream content size change
- **Breaking** Added `isLocalTile` to constructor of `DefaultVideoTile` and `VideoTileState`
- CallKit integration in demo app. Added options to join meeting as incoming or outgoing call. Since our demo app does not have Push Notification for incoming calls, we mimic the behavior by delaying reporting incoming calls to give user time to background the app or lock screen.
- Added icons and launch screen for demo app
- Added attendee id to local video tile

### Changed
- **Breaking** Throw MediaError.audioFailedToStart when AudioClient fails to start
- **Breaking** Changed the constructor for `DefaultVideoTileController`
- Changed UI for iOS demo app
- `DefaultVideoRenderView` now supports dynamically changing `contentMode` at run time.
- Changed video render frame type from `Any?` to `CVPixelBuffer?`

## [0.7.1] - 2020-06-24

### Changed
- `DefaultAudioClientController` no longer defaults to Speaker as audio output when starting audio session.

## [0.7.0] - 2020-06-05

### Added
- **Breaking** Added `start(callKitEnabled:)` in `AudioVideoControllerFacade` to accept a Bool type `callKitEnabled` parameter, which is set to `false` by default in `DefaultAudioVideoFacade`. Pass in `true` if your VoIP call has CallKit integration so that audio session interruptions are properly handled by the SDK.

### Changed
- `start()` in `DefaultAudioVideoFacade` now assumes the VoIP call to start has no CallKit integration by default to properly handle audio session interruptions. Use `start(callKitEnabled:)` to override the default behavior for calls that have CallKit integration.
- Initializers of all the public SDK classes are now publicly accessible to builders.

### Fixed
- Fixed random crashes caused by concurrency issues.

## [0.6.1] - 2020-05-22

### Added
- **Breaking** Added `attendeesDidDrop` API in `RealtimeObserver` for attendee who got dropped

## [0.6.0] - 2020-05-14

### Added
- **Breaking** Added additional fields for `CreateAttendeeResponse` and `CreateMeetingResponse`
- **Breaking** Added `audioSessionDidDrop` API in `AudioVideoObserver` for temporary disconnects
- Added `Versioning` class and `sdkVersion` API for retrieving current version of SDK
- Added `init(frame: CGRect)` initializer in `DefaultVideoRenderView` to properly initialize `DefaultVideoRenderView` in ObjC code.
- Added basic video features and `MetricsObserver` callback handler in the ObjC demo app.
- Added multiple video tiles support in Swift demo app.
- Added attendee name label in Swift demo app.
- Added new parameter `urlRewriter` in `MeetingSessionConfiguration` for customizing url

### Changed
- Updated demo app to work with updated [amazon-chime-sdk-js serverless demo](https://github.com/aws/amazon-chime-sdk-js/tree/master/demos/serverless). Note that you will need to redeploy the serverless demo to work with the updated demo app
- Updated methods for `AudioVideoObserver`, `RealtimeObserver`, `DeviceChangeObserver`, `VideoTileObserver`, and `MetricsObserver` to be called on main thread. Make sure to dispatch long-running tasks to another thread to avoid blocking the main thread.

### Fixed
- Fixed main thread freezing issue caused by calling `stop()` when in reconnecting state
- Fixed a bug where `audioSessionDidStopWithStatus()` was not getting called after calling `stop()`
- Fixed an issue in `bindVideoView()`, unbind first to prevent unexpected side effect.
- Fixed an issue that blocked user from removing paused video tiles.

## [0.5.2] - 2020-04-28

### Changed
- Turn on library evolution and module stability

## [0.5.1] - 2020-04-23

### Added
- Added full bitcode support in `AmazonChimeSDKMedia.framework` and `AmazonChimeSDK.framework`. Also added corresponding versions without bitcode. Links can be found in the README file.

### Fixed
- Fix bug where external id for self is sometimes empty

## [0.5.0] - 2020-03-27

### Changed
- Enable BUILD_LIBRARY_FOR_DISTRIBUTION to add Xcode 11.4 (Swift 5.2) support

## [0.4.0] - 2020-03-24
