# Event Ingestion

We send the [Amazon Chime SDK meeting events](meeting_events.md) to the Amazon Chime backend to analyze meeting health trends or identify common failures. This helps us to improve your meeting experience.

## Enabled by dafault

Event ingestion is enabled by default when using `DefaultMeetingSession`, provided that the [`ingestionURL`](https://aws.github.io/amazon-chime-sdk-ios/Classes/MeetingSessionURLs.html#/c:@M@AmazonChimeSDK@objc(cs)MeetingSessionURLs(py)ingestionUrl) is properly set in the `MeetingSessionURLs`.

This URL is supplied by the [CreateMeeting API](https://docs.aws.amazon.com/chime-sdk/latest/APIReference/API_meeting-chime_CreateMeeting.html) via the `MediaPlacement.EventIngestionUrl` field. Applications that intend to use event ingestion must ensure that this field is returned and correctly passed into the meeting session configuration.

## Sensitive attributes
The Amazon Chime SDK for iOS will not send below sensitive attributes to the Amazon Chime backend.
|Attribute|Description
|--|--
|`externalMeetingId`|The Amazon Chime SDK external meeting ID.
|`externalUserId`|The Amazon Chime SDK external user ID that can indicate an identity managed by your application.

## Opt out of Event Ingestion

To opt out of event ingestion, provide `NoopEventReporterFactory` to `DefaultMeetingSession` while creating the
meeting session.

See following example code:
```swift
lazy var currentMeetingSession = DefaultMeetingSession(
                                    configuration: meetingSessionConfig, 
                                    logger: logger,
                                    eventReporterFactory: NoopEventReporterFactory()
                                 )
```