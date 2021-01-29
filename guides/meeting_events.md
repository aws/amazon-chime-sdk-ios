# Meeting Events

The `eventDidReceive` observer method makes it easy to collect, process, and monitor meeting events.
You can use meeting events to identify and troubleshoot the cause of device and meeting failures.

To receive meeting events, add an observer, and implement the `eventDidReceive` observer method.

```swift
class MyEventAnalyticsObserver: EventAnalyticsObserver {
    func eventDidReceive(name, attributes) {
        // Handle a meeting event.
    }

  meetingSession.audioVideo.addEventAnalyticsObserver(self);
}

```

In the `eventDidReceive` observer method, we recommend that you handle each meeting event so that 
you don't have to worry about how your event processing would scale when the later versions of Chime SDK introduce new meeting events.

For example, the code outputs error information for three failure events at the `error` log level.

```swift
func eventDidReceive(name: EventName, attributes: EventAttributes) {
    switch name {
    case EventName.videoInputFailed:
        print("Video input failed \(name) \(attributes.toJsonString())")
    case EventName.meetingStartFailed:
        print("Meeting start failed \(name) \(attributes.toJsonString())")
    case EventName.meetingFailed:
        print("Meeting failed \(name) \(attributes.toJsonString())")
    default:
        break
    }
}
```

Ensure that you are familiar with the attributes you want to use. See the following two examples.
The code logs the last 5 minutes of the meeting history when a failure event occurs.
It's helpful to reduce the amount of data sent to your server application or analytics tool.
```swift
func eventDidReceive(name: EventName, attributes: EventAttributes) {
        let meetingHistory = meetingSession.audioVideo.getMeetingHistory()
        let lastFiveMinutes = Int64(Date().timeIntervalSince1970 * 1000) - 300_000
        let recentMeetingHistory = meetingHistory.filter { it.timestamp >= lastFiveMinutes }

    switch name {
    case EventName.videoInputFailed,
         EventName.meetingStartFailed,
         EventName.meetingFailed:
            print("Failure \(name) \(attributes.toJsonString()) \(recentMeetingHistory)")
    default:
        break
    }
}
```

There could be case where builders might want to use `EventAnalyticsController` to invoke events on their custom classes. One simple example is `DefaultCameraCaptureSource`. In this case, you can simply do

Pass `meetingSession.eventAnalyticsController` to custom class

```swift
let meetingSessionConfig = /* MeetingSessionConfiguration instance */

let cameraCaptureSource = DefaultCameraCaptureSource(logger)

let meetingSession = DefaultMeetingSession(
    meetingSessionConfig,
    logger
)

cameraCaptureSource.setEventAnalyticsController(eventAnalyticsController: meetingSession.eventAnalyticsController)
```

## Meeting events and attributes
Chime SDK sends these meeting events.
|Event name            |Description
|--                    |--
|`meetingStartRequested` |The meeting will start.
|`meetingStartSucceeded` |The meeting started.
|`meetingStartFailed`    |The meeting failed to start.
|`meetingEnded`          |The meeting ended.
|`meetingFailed`         |The meeting ended with one of the following failure [MeetingSessionStatusCode](https://aws.github.io/amazon-chime-sdk-ios/Enums/MeetingSessionStatusCode.html): <br><ul><li>`audioJoinedFromAnotherDevice`</li><li>`audioDisconnectAudio`</li><li>`audioAuthenticationRejected`</li><li>`audioCallAtCapacity`</li><li>`audioCallEnded`</li><li>`audioInternalServerError`</li><li>`audioServiceUnavailable`</li><li>`audioDisconnected`</li></ul>
|`videoInputFailed`      |The camera selection failed.

### Common attributes
Chime SDK stores common attributes for builders to identify/filter events.
```swift
meetingSession.audioVideo.getCommonAttributes()
```

|Attribute|Description
|--|--
|`attendeeId`|The Amazon Chime SDK attendee ID.
|`deviceName`|The manufacturer and model name of the computer or mobile device.
|`deviceManufacturer`|The manufacturer of mobile device `Apple`.
|`deviceModel`|The model name of the computer or mobile device.
|`externalMeetingId`|The Amazon Chime SDK external meeting ID.
|`externalUserId`|The Amazon Chime SDK external user ID that can indicate an identify managed by your application.
|`meetingId`|The Amazon Chime SDK meeting ID.
|`mediaSdkVersion`|The Amazon Chime iOS Media SDK version.
|`osName`|The operating system.
|`osVersion`|The version of the operating system.
|`sdkName`|The Amazon Chime SDK name, such as `amazon-chime-sdk-ios`.
|`sdkVersion`|The Amazon Chime SDK version.


### Standard attributes
Chime SDK sends a meeting event with attributes. These standard attributes are available as part of every event type.
|Attribute|Description
|--|--
|`timestampMs`|The timestamp in milliseconds since 00:00:00 UTC on 1 January 1970, at which an event occurred.<br><br>Unit: Milliseconds

### Meeting attributes
The following table describes attributes for a meeting.
|Attribute|Description|Included in
|--|--|--
|`maxVideoTileCount`|The maximum number of simultaneous video tiles shared during the meeting. This includes a local tile (your video), remote tiles, and content shares.<br><br>Unit: Count|`meetingStartSucceeded`, `meetingStartFailed`, `meetingEnded`, `meetingFailed`
|`meetingDurationMs`|The time that elapsed between the beginning (`AudioVideoObserver.audioSessionDidStart`) and the end (`AudioVideoObserver.audioSessionDidStop`) of the meeting.<br><br>Unit: Milliseconds|`meetingStartSucceeded`, `meetingStartFailed`, `meetingEnded`, `meetingFailed`
|`meetingErrorMessage`|The error message that explains why the meeting has failed.|`meetingFailed`
|`meetingStatus`|The meeting status when the meeting ended or failed. Note that this attribute indicates an enum name in [MeetingSessionStatusCode](https://aws.github.io/amazon-chime-sdk-ios/Enums/MeetingSessionStatusCode.html)| `meetingStartSucceeded`, `meetingEnded`, `meetingFailed`
|`poorConnectionCount`|The number of times the significant packet loss occurred during the meeting. Per count, you receive `AudioVideoObserver.connectionDidBecomePoor`.<br><br>Unit: Count|`meetingStartSucceeded`, `meetingStartFailed`, `meetingEnded`, `meetingFailed`
|`retryCount`|The number of connection retries performed during the meeting.<br><br>Unit: Count|`meetingStartSucceeded`, `meetingStartFailed`, `meetingEnded`, `meetingFailed`



### Device attributes
The following table describes attributes for the camera.
|Attribute|Description|Included in
|--|--|--
|`videoInputError`|The error that explains why the camera selection failed.|`videoInputFailed`
### The meeting history attribute
The meeting history attribute is a list of states. Each state object contains the state name and timestamp.

```swift
meetingSession.audioVideo.getSharedAttributes()
```

```
[
  {
    name: 'audioInputSelected',
    timestampMs: 1612166400000
  },
  {
    name: 'meetingStartSucceeded',
    timestampMs: 1612167400000
  },
  {
    name: 'meetingEnded',
    timestampMs: 1612167900000
  }
]
```
You can use the meeting history to track user actions and events from the creation of the `DefaultMeetingSession` object.
For example, if you started a meeting twice using the same `DefaultMeetingSession` object,
the meeting history will include two `meetingStartSucceeded`.


> Note: that meeting history can have a large number of states. Ensure that you process the meeting history
before sending it to your server application or analytics tool.

The following table lists available states.
|State|Description
|--|--
|`audioInputSelected`|The microphone was selected.
|`meetingEnded`|The meeting ended.
|`meetingFailed`|The meeting ended with the failure status.
|`meetingReconnected`|The meeting reconnected.
|`meetingStartFailed`|The meeting failed to start.
|`meetingStartRequested`|The meeting will start.
|`meetingStartSucceeded`|The meeting started.
|`videoInputFailed`|The camera selection failed.
|`videoInputSelected`|The camera was selected.

## Example
[The Chime SDK serverless demo](https://github.com/aws/amazon-chime-sdk-js/tree/master/demos/serverless) uses Amazon CloudWatch Logs to collect, process, and analyze meeting events. For more information, see [the Meeting Dashboard section](https://github.com/aws/amazon-chime-sdk-js/tree/master/demos/serverless#meeting-dashboard) on the serverless demo page.