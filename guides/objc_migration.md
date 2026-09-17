# Objective-C symbol migration (0.28.0)

Every Objective-C-visible type, protocol and `NS_ENUM` generated from the SDK's Swift now carries an `AWSChime` prefix, as does the Objective-C surface of `AmazonChimeSDKMedia` -- its classes, protocols, `NS_ENUM` types and their constants.

`AmazonChimeSDKMedia` also publishes plain C typedefs and constants through `audio_client_enum.h` and `video_client_enum.h` (`priority_t`, `video_codec_t`, `target_resolution_t`, `app_detailed_info_t`, `turn_session_response_t`, the `remote_video_subscription_*_t` pair, and the `AUDIO_CLIENT_*`/`VIDEO_CLIENT_*` constant families). Those are **unchanged**. They are shared cross-platform C headers, so renaming them reaches the Android, Linux and Windows media builds and has to be verified there; it is deliberately out of scope for an Apple-only change. A plain C typedef collides exactly like an Objective-C class does, so treat this as a known remaining risk rather than a solved one.

One documented exception: `CwtEnum.h` still declares `CwtModelState`, `CwtPredictResult`, the struct `CwtInputModelConfig`, and the bare constants `EMPTY`, `LOADING`, `LOADED`, `SUCCESS`, `ERROR`, `FAILED_TO_INIT_MODEL`, `FAILED_TO_INIT_INTERPRETER`, `FAILED_TO_ALLOC_MEMORY`, `FAILED_TO_DOWNLOAD_MODEL` and `FAILED_TO_PREDICT`. Its declarations are identical to the copy that ships in the prebuilt `AmazonChimeSDKMachineLearning` framework (the two files differ only by a comment and a `static_assert`), so renaming one side would make the declarations diverge and reintroduce this same conflict; it needs a coordinated release of both.

Objective-C entities — classes, protocols and `NS_ENUM` types — share one global namespace, so the
SDK's previous bare names collided with any other framework in the same target that declared the same
name. Building both then failed outright:

```
'Logger' has different definitions in different modules;
first difference is definition in module 'AmazonChimeSDK.Swift' found 0 referenced protocols
```

### What this does not cover

This closes the **compile-time** collision: the names a consumer's translation unit sees. The Objective-C **runtime** still registers a few unprefixed class names that the framework does not export, among them `AudioDevice` and `BluetoothGlue`. Linking another framework that implements a class of the same name produces a runtime `Class X is implemented in both ...` warning rather than a build failure. That is pre-existing and unchanged here.

## Swift callers

**No change is required.** Swift names are unchanged; only the Objective-C spelling moved. The prefix
is applied with `@objc(...)` on Swift declarations and `NS_SWIFT_NAME(...)` on hand-written
Objective-C, both of which leave the Swift name alone.

## Objective-C callers

Add the prefix to each type, protocol and enum constant listed below. Property names are unchanged, and so are the `CwtEnum.h` names noted above. One selector does change -- see `toJsonString` below.

```objc
// before
ConsoleLogger *logger = [[ConsoleLogger alloc] initWithName:@"MyApp" level:LogLevelINFO];
DefaultMeetingSession *session = [[DefaultMeetingSession alloc] initWithConfiguration:config logger:logger];

// after
AWSChimeConsoleLogger *logger = [[AWSChimeConsoleLogger alloc] initWithName:@"MyApp" level:AWSChimeLogLevelINFO];
AWSChimeDefaultMeetingSession *session = [[AWSChimeDefaultMeetingSession alloc] initWithConfiguration:config logger:logger];
```

Two cases do not follow the plain type-prefix rule:

| Before | After | Note |
|---|---|---|
| `[dict toJsonString]` | `[dict awsChimeToJsonString]` | A category method on `NSDictionary` collides by selector, not by type name, so the selector itself is prefixed. The Swift name `toJsonString()` is unchanged. |
| `LogLevelINFO`, `MediaDeviceTypeVideoFrontCamera`, … | `AWSChimeLogLevelINFO`, `AWSChimeMediaDeviceTypeVideoFrontCamera`, … | `NS_ENUM` constants take the prefix with their type. |

Storyboards and XIBs that reference an SDK view class need **no** change: with `customModule` set,
Interface Builder resolves the Swift name, which has not moved.

`NSError` domain **string values** are unchanged, because they derive from the Swift type name. A check such as
`[error.domain isEqual:@"AmazonChimeSDK.PermissionError"]` keeps working, and a unit test asserts it.

The domain **constants** are Objective-C globals, so their names do take the prefix:

| Before | After |
|---|---|
| `CaptureSourceErrorDomain` | `AWSChimeCaptureSourceErrorDomain` |
| `MediaErrorDomain` | `AWSChimeMediaErrorDomain` |
| `ModalityTypeDomain` | `AWSChimeModalityTypeDomain` |
| `PermissionErrorDomain` | `AWSChimePermissionErrorDomain` |
| `ResourceErrorDomain` | `AWSChimeResourceErrorDomain` |
| `SendDataMessageErrorDomain` | `AWSChimeSendDataMessageErrorDomain` |
| `SignalingDroppedErrorDomain` | `AWSChimeSignalingDroppedErrorDomain` |
| `VideoClientFailedErrorDomain` | `AWSChimeVideoClientFailedErrorDomain` |
| `VideoInterruptionReasonDomain` | `AWSChimeVideoInterruptionReasonDomain` |
| `VoiceFocusErrorDomain` | `AWSChimeVoiceFocusErrorDomain` |


## AmazonChimeSDK (158 symbols)

| Before | After |
|---|---|
| `ActiveSpeakerDetectorFacade` | `AWSChimeActiveSpeakerDetectorFacade` |
| `ActiveSpeakerObserver` | `AWSChimeActiveSpeakerObserver` |
| `ActiveSpeakerPolicy` | `AWSChimeActiveSpeakerPolicy` |
| `AppState` | `AWSChimeAppState` |
| `AppStateMonitor` | `AWSChimeAppStateMonitor` |
| `AppStateMonitorDelegate` | `AWSChimeAppStateMonitorDelegate` |
| `Attendee` | `AWSChimeAttendee` |
| `AttendeeInfo` | `AWSChimeAttendeeInfo` |
| `AttendeeStatus` | `AWSChimeAttendeeStatus` |
| `AudioClientController` | `AWSChimeAudioClientController` |
| `AudioClientObserver` | `AWSChimeAudioClientObserver` |
| `AudioClientProtocol` | `AWSChimeAudioClientProtocol` |
| `AudioDeviceCapabilities` | `AWSChimeAudioDeviceCapabilities` |
| `AudioLock` | `AWSChimeAudioLock` |
| `AudioMode` | `AWSChimeAudioMode` |
| `AudioSession` | `AWSChimeAudioSession` |
| `AudioVideoConfiguration` | `AWSChimeAudioVideoConfiguration` |
| `AudioVideoControllerFacade` | `AWSChimeAudioVideoControllerFacade` |
| `AudioVideoFacade` | `AWSChimeAudioVideoFacade` |
| `AudioVideoObserver` | `AWSChimeAudioVideoObserver` |
| `BackgroundBlurConfiguration` | `AWSChimeBackgroundBlurConfiguration` |
| `BackgroundBlurStrength` | `AWSChimeBackgroundBlurStrength` |
| `BackgroundBlurVideoFrameProcessor` | `AWSChimeBackgroundBlurVideoFrameProcessor` |
| `BackgroundFilter` | `AWSChimeBackgroundFilter` |
| `BackgroundReplacementConfiguration` | `AWSChimeBackgroundReplacementConfiguration` |
| `BackgroundReplacementVideoFrameProcessor` | `AWSChimeBackgroundReplacementVideoFrameProcessor` |
| `BatteryState` | `AWSChimeBatteryState` |
| `CameraCaptureSource` | `AWSChimeCameraCaptureSource` |
| `CaptureSourceError` | `AWSChimeCaptureSourceError` |
| `CaptureSourceObserver` | `AWSChimeCaptureSourceObserver` |
| `ClientMetricsCollector` | `AWSChimeClientMetricsCollector` |
| `ConsoleLogger` | `AWSChimeConsoleLogger` |
| `ContentShareController` | `AWSChimeContentShareController` |
| `ContentShareObserver` | `AWSChimeContentShareObserver` |
| `ContentShareSource` | `AWSChimeContentShareSource` |
| `ContentShareStatus` | `AWSChimeContentShareStatus` |
| `ContentShareStatusCode` | `AWSChimeContentShareStatusCode` |
| `ContentShareVideoClientController` | `AWSChimeContentShareVideoClientController` |
| `CreateAttendeeResponse` | `AWSChimeCreateAttendeeResponse` |
| `CreateMeetingResponse` | `AWSChimeCreateMeetingResponse` |
| `DataMessage` | `AWSChimeDataMessage` |
| `DataMessageObserver` | `AWSChimeDataMessageObserver` |
| `DefaultActiveSpeakerDetector` | `AWSChimeDefaultActiveSpeakerDetector` |
| `DefaultActiveSpeakerPolicy` | `AWSChimeDefaultActiveSpeakerPolicy` |
| `DefaultAudioVideoController` | `AWSChimeDefaultAudioVideoController` |
| `DefaultAudioVideoFacade` | `AWSChimeDefaultAudioVideoFacade` |
| `DefaultCameraCaptureSource` | `AWSChimeDefaultCameraCaptureSource` |
| `DefaultContentShareController` | `AWSChimeDefaultContentShareController` |
| `DefaultContentShareVideoClientController` | `AWSChimeDefaultContentShareVideoClientController` |
| `DefaultDeviceController` | `AWSChimeDefaultDeviceController` |
| `DefaultEventAnalyticsController` | `AWSChimeDefaultEventAnalyticsController` |
| `DefaultEventReporter` | `AWSChimeDefaultEventReporter` |
| `DefaultMeetingSession` | `AWSChimeDefaultMeetingSession` |
| `DefaultMeetingStatsCollector` | `AWSChimeDefaultMeetingStatsCollector` |
| `DefaultModality` | `AWSChimeDefaultModality` |
| `DefaultRealtimeController` | `AWSChimeDefaultRealtimeController` |
| `DefaultVideoRenderView` | `AWSChimeDefaultVideoRenderView` |
| `DefaultVideoTile` | `AWSChimeDefaultVideoTile` |
| `DefaultVideoTileController` | `AWSChimeDefaultVideoTileController` |
| `DeviceChangeObserver` | `AWSChimeDeviceChangeObserver` |
| `DeviceController` | `AWSChimeDeviceController` |
| `DeviceUtils` | `AWSChimeDeviceUtils` |
| `EventAnalyticsController` | `AWSChimeEventAnalyticsController` |
| `EventAnalyticsFacade` | `AWSChimeEventAnalyticsFacade` |
| `EventAnalyticsObserver` | `AWSChimeEventAnalyticsObserver` |
| `EventAttributeName` | `AWSChimeEventAttributeName` |
| `EventBuffer` | `AWSChimeEventBuffer` |
| `EventClientConfiguration` | `AWSChimeEventClientConfiguration` |
| `EventClientType` | `AWSChimeEventClientType` |
| `EventName` | `AWSChimeEventName` |
| `EventReporter` | `AWSChimeEventReporter` |
| `EventReporterFactory` | `AWSChimeEventReporterFactory` |
| `EventSender` | `AWSChimeEventSender` |
| `InAppScreenCaptureSource` | `AWSChimeInAppScreenCaptureSource` |
| `IngestionConfiguration` | `AWSChimeIngestionConfiguration` |
| `IngestionConfigurationBuilder` | `AWSChimeIngestionConfigurationBuilder` |
| `IngestionEvent` | `AWSChimeIngestionEvent` |
| `IngestionEventConverter` | `AWSChimeIngestionEventConverter` |
| `IngestionPayload` | `AWSChimeIngestionPayload` |
| `IngestionRecord` | `AWSChimeIngestionRecord` |
| `IntervalScheduler` | `AWSChimeIntervalScheduler` |
| `LocalVideoConfiguration` | `AWSChimeLocalVideoConfiguration` |
| `LogLevel` | `AWSChimeLogLevel` |
| `Logger` | `AWSChimeLogger` |
| `MediaDevice` | `AWSChimeMediaDevice` |
| `MediaDeviceType` | `AWSChimeMediaDeviceType` |
| `MediaError` | `AWSChimeMediaError` |
| `MediaPlacement` | `AWSChimeMediaPlacement` |
| `Meeting` | `AWSChimeMeeting` |
| `MeetingEventClientConfiguration` | `AWSChimeMeetingEventClientConfiguration` |
| `MeetingFeatures` | `AWSChimeMeetingFeatures` |
| `MeetingHistoryEvent` | `AWSChimeMeetingHistoryEvent` |
| `MeetingHistoryEventName` | `AWSChimeMeetingHistoryEventName` |
| `MeetingSession` | `AWSChimeMeetingSession` |
| `MeetingSessionConfiguration` | `AWSChimeMeetingSessionConfiguration` |
| `MeetingSessionCredentials` | `AWSChimeMeetingSessionCredentials` |
| `MeetingSessionStatus` | `AWSChimeMeetingSessionStatus` |
| `MeetingSessionStatusCode` | `AWSChimeMeetingSessionStatusCode` |
| `MeetingSessionURLs` | `AWSChimeMeetingSessionURLs` |
| `MeetingStatsCollector` | `AWSChimeMeetingStatsCollector` |
| `MetricsObserver` | `AWSChimeMetricsObserver` |
| `ModalityType` | `AWSChimeModalityType` |
| `NetworkConnectionType` | `AWSChimeNetworkConnectionType` |
| `ObservableMetric` | `AWSChimeObservableMetric` |
| `PermissionError` | `AWSChimePermissionError` |
| `PrimaryMeetingPromotionObserver` | `AWSChimePrimaryMeetingPromotionObserver` |
| `RealtimeControllerFacade` | `AWSChimeRealtimeControllerFacade` |
| `RealtimeObserver` | `AWSChimeRealtimeObserver` |
| `RemoteVideoSource` | `AWSChimeRemoteVideoSource` |
| `ResourceError` | `AWSChimeResourceError` |
| `SDKEvent` | `AWSChimeSDKEvent` |
| `Scheduler` | `AWSChimeScheduler` |
| `SendDataMessageError` | `AWSChimeSendDataMessageError` |
| `SignalStrength` | `AWSChimeSignalStrength` |
| `SignalUpdate` | `AWSChimeSignalUpdate` |
| `SignalingDroppedError` | `AWSChimeSignalingDroppedError` |
| `TURNRequestService` | `AWSChimeTURNRequestService` |
| `Transcript` | `AWSChimeTranscript` |
| `TranscriptAlternative` | `AWSChimeTranscriptAlternative` |
| `TranscriptEntity` | `AWSChimeTranscriptEntity` |
| `TranscriptEvent` | `AWSChimeTranscriptEvent` |
| `TranscriptEventObserver` | `AWSChimeTranscriptEventObserver` |
| `TranscriptItem` | `AWSChimeTranscriptItem` |
| `TranscriptItemType` | `AWSChimeTranscriptItemType` |
| `TranscriptLanguageWithScore` | `AWSChimeTranscriptLanguageWithScore` |
| `TranscriptResult` | `AWSChimeTranscriptResult` |
| `TranscriptionStatus` | `AWSChimeTranscriptionStatus` |
| `TranscriptionStatusType` | `AWSChimeTranscriptionStatusType` |
| `URLRewriterUtils` | `AWSChimeURLRewriterUtils` |
| `Versioning` | `AWSChimeVersioning` |
| `VideoBitrateConstants` | `AWSChimeVideoBitrateConstants` |
| `VideoCaptureFormat` | `AWSChimeVideoCaptureFormat` |
| `VideoCaptureSource` | `AWSChimeVideoCaptureSource` |
| `VideoClientController` | `AWSChimeVideoClientController` |
| `VideoClientFailedError` | `AWSChimeVideoClientFailedError` |
| `VideoClientProtocol` | `AWSChimeVideoClientProtocol` |
| `VideoContentHint` | `AWSChimeVideoContentHint` |
| `VideoFrame` | `AWSChimeVideoFrame` |
| `VideoFrameBuffer` | `AWSChimeVideoFrameBuffer` |
| `VideoFramePixelBuffer` | `AWSChimeVideoFramePixelBuffer` |
| `VideoFrameResender` | `AWSChimeVideoFrameResender` |
| `VideoInterruptionReason` | `AWSChimeVideoInterruptionReason` |
| `VideoPauseState` | `AWSChimeVideoPauseState` |
| `VideoPriority` | `AWSChimeVideoPriority` |
| `VideoRenderView` | `AWSChimeVideoRenderView` |
| `VideoResolution` | `AWSChimeVideoResolution` |
| `VideoRotation` | `AWSChimeVideoRotation` |
| `VideoSink` | `AWSChimeVideoSink` |
| `VideoSource` | `AWSChimeVideoSource` |
| `VideoSubscriptionConfiguration` | `AWSChimeVideoSubscriptionConfiguration` |
| `VideoTile` | `AWSChimeVideoTile` |
| `VideoTileController` | `AWSChimeVideoTileController` |
| `VideoTileControllerFacade` | `AWSChimeVideoTileControllerFacade` |
| `VideoTileObserver` | `AWSChimeVideoTileObserver` |
| `VideoTileState` | `AWSChimeVideoTileState` |
| `VoiceFocusError` | `AWSChimeVoiceFocusError` |
| `VolumeLevel` | `AWSChimeVolumeLevel` |
| `VolumeUpdate` | `AWSChimeVolumeUpdate` |


## AmazonChimeSDKMedia (37 symbols)

Their `NS_ENUM` constants are prefixed the same way.

| Before | After |
|---|---|
| `AppInfo` | `AWSChimeAppInfo` |
| `AttendeeInfoInternal` | `AWSChimeAttendeeInfoInternal` |
| `AttendeeUpdate` | `AWSChimeAttendeeUpdate` |
| `AudioClient` | `AWSChimeAudioClient` |
| `AudioClientDelegate` | `AWSChimeAudioClientDelegate` |
| `AudioClientMetric` | `AWSChimeAudioClientMetric` |
| `AudioDeviceCapabilitiesInternal` | `AWSChimeAudioDeviceCapabilitiesInternal` |
| `AudioModeInternal` | `AWSChimeAudioModeInternal` |
| `DataMessageInternal` | `AWSChimeDataMessageInternal` |
| `PauseState` | `AWSChimePauseState` |
| `PrimaryMeetingEventStatusInternal` | `AWSChimePrimaryMeetingEventStatusInternal` |
| `PrimaryMeetingEventTypeInternal` | `AWSChimePrimaryMeetingEventTypeInternal` |
| `PriorityInternal` | `AWSChimePriorityInternal` |
| `RemoteVideoSourceInternal` | `AWSChimeRemoteVideoSourceInternal` |
| `ResolutionInternal` | `AWSChimeResolutionInternal` |
| `TranscriptAlternativeInternal` | `AWSChimeTranscriptAlternativeInternal` |
| `TranscriptEntityInternal` | `AWSChimeTranscriptEntityInternal` |
| `TranscriptEventInternal` | `AWSChimeTranscriptEventInternal` |
| `TranscriptInternal` | `AWSChimeTranscriptInternal` |
| `TranscriptItemInternal` | `AWSChimeTranscriptItemInternal` |
| `TranscriptItemTypeInternal` | `AWSChimeTranscriptItemTypeInternal` |
| `TranscriptLanguageWithScoreInternal` | `AWSChimeTranscriptLanguageWithScoreInternal` |
| `TranscriptResultInternal` | `AWSChimeTranscriptResultInternal` |
| `TranscriptionStatusInternal` | `AWSChimeTranscriptionStatusInternal` |
| `TranscriptionStatusTypeInternal` | `AWSChimeTranscriptionStatusTypeInternal` |
| `VideoClient` | `AWSChimeVideoClient` |
| `VideoClientDelegate` | `AWSChimeVideoClientDelegate` |
| `VideoClientMetric` | `AWSChimeVideoClientMetric` |
| `VideoCodecCapabilitiesInternal` | `AWSChimeVideoCodecCapabilitiesInternal` |
| `VideoConfiguration` | `AWSChimeVideoConfiguration` |
| `VideoContentHintInternal` | `AWSChimeVideoContentHintInternal` |
| `VideoRendererDelegate` | `AWSChimeVideoRendererDelegate` |
| `VideoRotationInternal` | `AWSChimeVideoRotationInternal` |
| `VideoSinkInternal` | `AWSChimeVideoSinkInternal` |
| `VideoSourceInternal` | `AWSChimeVideoSourceInternal` |
| `VideoSubscriptionConfigurationInternal` | `AWSChimeVideoSubscriptionConfigurationInternal` |
| `loglevel_t` | `AWSChimeAudioClientLogLevel` |

Its `NS_ENUM` constants take the prefix with their type, with two deviations:

1. A constant that started with a lower-case letter is capitalised after the prefix, because Swift only strips a whole leading word. `videoSendBitrate` becomes `AWSChimeVideoSendBitrate` and `clientRttMs` becomes `AWSChimeClientRttMs` -- not `AWSChimevideoSendBitrate`. The Swift names are unchanged.
2. The `loglevel_t` constants are renamed with their type, which became `AWSChimeAudioClientLogLevel`:

| Before | After |
|---|---|
| `LOGGER_DEBUG` | `AWSChimeAudioClientLogLevelDebug` |
| `LOGGER_ERROR` | `AWSChimeAudioClientLogLevelError` |
| `LOGGER_FATAL` | `AWSChimeAudioClientLogLevelFatal` |
| `LOGGER_INFO` | `AWSChimeAudioClientLogLevelInfo` |
| `LOGGER_NOTIFY` | `AWSChimeAudioClientLogLevelNotify` |
| `LOGGER_TRACE` | `AWSChimeAudioClientLogLevelTrace` |
| `LOGGER_WARNING` | `AWSChimeAudioClientLogLevelWarning` |
