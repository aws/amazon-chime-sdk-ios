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
|`meetingReconnected`    |The meeting reconnected.
|`meetingStartFailed`    |The meeting failed to start.
|`meetingEnded`          |The meeting ended.
|`meetingFailed`         |The meeting ended with one of the following failure [MeetingSessionStatusCode](https://aws.github.io/amazon-chime-sdk-ios/Enums/MeetingSessionStatusCode.html): <br><ul><li>`audioJoinedFromAnotherDevice`</li><li>`audioDisconnectAudio`</li><li>`audioAuthenticationRejected`</li><li>`audioCallAtCapacity`</li><li>`audioCallEnded`</li><li>`audioInternalServerError`</li><li>`audioServiceUnavailable`</li><li>`audioDisconnected`</li></ul>
|`audioInputFailed`      |The microphone selection or access failed.
|`videoInputFailed`      |The camera selection or access failed.
|`videoClientSignalingDropped`      |The video client signaling websocket failed or closed with an error.
|`contentShareSignalingDropped`     |The content share client signaling websocket failed or closed with an error.

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
|`maxVideoTileCount`|The maximum number of simultaneous video tiles shared during the meeting. This includes a local tile (your video), remote tiles, and content shares.<br><br>Unit: Count|`meetingStartSucceeded`, `meetingReconnected`, `meetingStartFailed`, `meetingEnded`, `meetingFailed`
|`meetingStartDurationMs`|The time that elapsed between the start request `meetingSession.audioVideo.start()` and the beginning of the meeting `AudioVideoObserver.audioSessionDidStart()`.<br><br>Unit: Milliseconds|`meetingStartSucceeded`, `meetingReconnected`, `meetingStartFailed`, `meetingEnded`, `meetingFailed`
|`meetingDurationMs`|The time that elapsed between the beginning (`AudioVideoObserver.audioSessionDidStart`) and the end (`AudioVideoObserver.audioSessionDidStop`) of the meeting.<br><br>Unit: Milliseconds|`meetingStartSucceeded`, `meetingStartFailed`, `meetingReconnected`, `meetingEnded`, `meetingFailed`
|`meetingReconnectDurationMs`|The time taken to reconnect the session after dropped.<br><br>Unit: Milliseconds|`meetingReconnected`
|`meetingErrorMessage`|The error message that explains why the meeting has failed.|`meetingFailed`
|`meetingStatus`|The meeting status when the meeting ended or failed. Note that this attribute indicates an enum name in [MeetingSessionStatusCode](https://aws.github.io/amazon-chime-sdk-ios/Enums/MeetingSessionStatusCode.html)| `meetingStartSucceeded`, `meetingReconnected`, `meetingEnded`, `meetingFailed`
|`poorConnectionCount`|The number of times the significant packet loss occurred during the meeting. Per count, you receive `AudioVideoObserver.connectionDidBecomePoor`.<br><br>Unit: Count|`meetingStartSucceeded`, `meetingReconnected`, `meetingStartFailed`, `meetingEnded`, `meetingFailed`
|`retryCount`|The number of connection retries performed during the meeting.<br><br>Unit: Count|`meetingStartSucceeded`, `meetingReconnected`, `meetingStartFailed`, `meetingEnded`, `meetingFailed`
|`signalingDroppedErrorMessage`|The error message that explains why the signaling websocket connection dropped.|`videoClientSignalingDropped`, `contentShareSignalingDropped`


### Device attributes
The following table describes attributes for the microphone and camera.
|Attribute|Description|Included in
|--|--|--
|`audioInputErrorMessage`|The error message that explains why the microphone selection or access failed.|`audioInputFailed`
|`videoInputErrorMessage`|The error that explains why the camera selection or access failed.|`videoInputFailed`
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
|`meetingEnded`                     |The meeting ended.
|`meetingFailed`                    |The meeting ended with the failure status.
|`meetingReconnected`               |The meeting reconnected.
|`meetingStartFailed`               |The meeting failed to start.
|`meetingStartRequested`            |The meeting will start.
|`meetingStartSucceeded`            |The meeting started.
|`audioInputSelected`               |The microphone was selected.
|`audioInputFailed`                 |The microphone selection failed.
|`videoInputSelected`               |The camera was selected.
|`videoInputFailed`                 |The camera selection failed.
|`videoClientSignalingDropped`      |The video client signaling websocket failed or closed with an error.
|`contentShareSignalingDropped`     |The content share client signaling websocket failed or closed with an error.
|`appEnteredForeground`             |The app entered foreground.
|`appEnteredBackground`             |The app entered background.

## Example

This section includes sample code for the [Monitoring and troubleshooting with Amazon Chime SDK meeting events](https://aws.amazon.com/blogs/business-productivity/monitoring-and-troubleshooting-with-amazon-chime-sdk-meeting-events/) blog post.

1. Follow the [blog post](https://aws.amazon.com/blogs/business-productivity/monitoring-and-troubleshooting-with-amazon-chime-sdk-meeting-events/) to deploy the AWS CloudFormation stack. The stack provisions all the infrastructure required to search and analyze meeting events in Amazon CloudWatch.
2. To receive meeting events in your iOS application, add an event analytics observer to implement the `eventDidReceive` method.
    ```
    class MyObserver: EventAnalyticsObserver {
        var meetingEvents = [[String: Any]]()
        func eventDidReceive(name: EventName, attributes: [AnyHashable: Any]) {
            var mutableAttributes = attributes
            let meetingHistory = currentMeetingSession.audioVideo.getMeetingHistory()
            mutableAttributes = mutableAttributes.merging(currentMeetingSession.audioVideo.getCommonEventAttributes(),
                                                             uniquingKeysWith: { (_, newVal) -> Any in
                newVal
            })
            
            switch name {
            case EventName.videoInputFailed,
                 EventName.meetingStartFailed,
                 EventName.meetingFailed:
                    mutableAttributes = mutableAttributes.merging([
                        EventAttributeName.meetingHistory: meetingHistory
                    ] as [EventAttributeName: Any], uniquingKeysWith: { (_, newVal) -> Any in
                        newVal})
            default:
                // TODO 
                break
            }
            
            
            meetingEvents.append([
                "name": "\(name)",
                "attributes": toStringKeyDict(mutableAttributes.merging(currentMeetingSession.audioVideo.getCommonEventAttributes(),
                                                                 uniquingKeysWith: { (_, newVal) -> Any in
                    newVal
                }))
            ])
        }
        
        func toStringKeyDict(_ attributes: [AnyHashable: Any]) -> [String: Any] {
            var jsonDict = [String: Any]()
            attributes.forEach { (key, value) in
                jsonDict[String(describing: key)] = String(describing: value)
            }
            return jsonDict
        }

        meetingSession.audioVideo.addEventAnalyticsObserver(self);
    }
    ```
3. When a meeting ends, upload meeting events to the endpoint that you created in the preceding section. Set the endpoint to the **MeetingEventApiEndpoint** value from the **Outputs** tab of the AWS CloudFormation console. To make a POST request, you can use our helper class [HttpUtils](https://github.com/aws/amazon-chime-sdk-ios/blob/master/AmazonChimeSDKDemo/AmazonChimeSDKDemo/utils/HttpUtils.swift) or a third-party library.
    ```
    class MyObserver: AudioVideoObserver {
        func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
            let url = /* MeetingEventApiEndpoint from the preceding section */

            guard let nonNilData = try? JSONSerialization.data(withJSONObject: meetingEvents) else {
                return
            }
            
            HttpUtils.postRequest(url: url, jsonData: nonNilData) { _, error in
                if let error = error {
                    self.logger.error(msg: "PostLogger post request failed \(error)")
                } else {
                    self.logger.info(msg: "PostLogger post request succeeded")
                    self.meetingEvents.removeAll()
                }
            }
        }

        meetingSession.audioVideo.addAudioVideoObserver(observer: self)
    }
    ```
4. Now that your applications upload meeting events to Amazon CloudWatch. Run several test meetings to collect meeting events. For an example of how to troubleshoot with meeting events, see the [blog post](https://aws.amazon.com/blogs/business-productivity/monitoring-and-troubleshooting-with-amazon-chime-sdk-meeting-events/).
