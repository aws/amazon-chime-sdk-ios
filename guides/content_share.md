# Content Share

Builders using the Amazon Chime SDK for iOS can share a second video stream such as screen capture in a meeting without disrupting their applications existing audio/video stream.

## Prerequisites

* You have read the [API overview](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/api_overview.md) and have a basic understanding of the components covered in that document.
* You have completed [Getting Started](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/getting_started.md) and have running application which uses the Amazon Chime SDK.
* You have read the [Custom Video Sources, Processors, and Sinks](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/custom_video.md) and have a basic understanding of APIs such as [VideoSource](https://aws.github.io/amazon-chime-sdk-ios/Protocols/VideoSource.html).
* You have a physical iOS device. Screen sharing is not supported on simulator.
    * iOS 11.0 or later for in application only screen sharing
    * iOS 12.0 or later for device level screen sharing

## Share Screen Capture

There are two options to share screen on iOS, **In Application Only**, and **Device Level** sharing. The main difference between the two options is that Device Level sharing capture the entire device screen view and continues to send screen capture after Customer Application is in the background, including view of other applications subsequently opened. In Application Only sharing only captures and shares the view within the Customer Application when used. This guide goes over each individually. Both options leverage Apple [ReplayKit](https://developer.apple.com/documentation/replaykit) framework to capture the screen and and send the screen video stream to remote participants through the new [Content Share API](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/api_overview.md#13-share-screen-and-other-content-optional) in Amazon Chime SDK for iOS.
**Note**: Physical iOS device is required to test in application only or device level screen sharing.

## In Application Only Screen Sharing

[`InAppScreenCaptureSource`](https://aws.github.io/amazon-chime-sdk-ios/Classes/InAppScreenCaptureSource.html) uses `RPScreenRecorder` and its [startCapture(handler:completionHandler:)](https://developer.apple.com/documentation/replaykit/rpscreenrecorder/2867291-startcapture) method from ReplayKit to capture Customer Application screen. `InAppScreenCaptureSource` and its methods are only available on iOS 11 and above. While `RPScreenRecorder` is capturing the screen, it locks device orientation until it stops capturing. `RPScreenRecorder` does not send video frames to `InAppScreenCaptureSource` when user puts Customer Application in the background, and remote participants see a paused video stream from the sender. 

### Create an InAppScreenCaptureSource and a CaptureSourceObserver

`InAppScreenCaptureSource` takes a `Logger` instance on initialization for logging messages. Builders can also add a `CaptureSourceObserver` which is notified when `RPScreenRecorder` is started, stopped, or failed.

```
let inAppScreenCaptureSource = InAppScreenCaptureSource(logger: logger)
inAppScreenCaptureSource.addCaptureSourceObserver(observer: observer)
```

### Start Screen Share

User will see a system permission dialog when `InAppScreenCaptureSource.start()` is called for the first time. `captureDidStart()` is called after user taps “**Record Screen**” and `RPScreenRecorder` is started. `captureDidFail(error:)` is called with `CaptureSourceError.systemFailure` if user taps “**Don’t Allow**”.

```
func methodToStartScreenShare() {
    inAppScreenCaptureSource.start()
}

// CaptureSourceObserver
func captureDidStart() {
    logger.info(msg: "InAppScreenCaptureSource did start")
    let contentShareSource = ContentShareSource()
    contentShareSource.videoSource = inAppScreenCaptureSource
    
    // Get reference to current MeetingSession object.
    meetingSession.audioVideo.startContentShare(source: contentShareSource)
}
```

### Stop Screen Share

`stop()` on `InAppScreenCaptureSource` only stops `RPScreenRecorder` from capturing the screen, it is still necessary to call `stopContentShare()` on [`ContentShareController`](https://aws.github.io/amazon-chime-sdk-ios/Protocols/ContentShareController.html) to stop the peer connection for sending the screen capture data.

```
func methodToStopScreenShare() {
    inAppScreenCaptureSource.stop()
}

// CaptureSourceObserver
func captureDidStop() {
    logger.info(msg: "InAppScreenCaptureSource did stop")
    
    // Get reference to current MeetingSession object.
    meetingSession.audioVideo.stopContentShare()
}

func captureDidFail(error: CaptureSourceError) {
    logger.error(msg: "InAppScreenCaptureSource did fail: \(error.description)")
    
    // Get reference to current MeetingSession object.
    meetingSession.audioVideo.stopContentShare()
}
```

## Device Level Screen Sharing

Before diving into implementation, please look at this official Apple [programming guide](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionOverview.html#//apple_ref/doc/uid/TP40014214-CH2-SW2) to understand the basics of iOS application extensions, relevant vocabulary and limitations. Even though an application extension is bundled with the containing application when user downloads the application, there is no direct communication between the two while they are running. However, an application extension and its containing application can both access a shared privately defined `UserDefaults` to pass data as long as they are in the same App Group. The following guide uses this mechanism to write necessary data from Customer Application, read from the broadcast upload extension to recreate a `MeetingSession` to upload screen capture. This guide also uses [RPSystemBroadcastPickerView](https://developer.apple.com/documentation/replaykit/rpsystembroadcastpickerview) that is available on iOS 12.0 and above to bring up system broadcast picker.

### Create Broadcast Upload Extension target

With Customer Application project open in Xcode, select **File** → **New** → **Target**
In the pop-up, select **Broadcast Upload Extension**, and fill in necessary fields on the next screen to finish creating.
* Not necessary to include UI Extension
* Embed in Customer Application that uses Amazon Chime SDK for iOS to create meeting session
* Select the newly created broadcast upload extension target in the project
* Open **General** tab and add AmazonChimeSDK in the **Frameworks and Library** section

**Note**: Xcode 12.0 is used when writing this guide.

### Add App Groups Capability 

To add **App Groups** capability to both Customer Application target and broadcast upload extension target: 
1. Select Customer Application target in the project.
2. Open **Signing & Capabilities** tab.
3. Click **+ Capabilities** and select **App Groups** in the pop-up.
4. Create an App Group with identifier: `group.<application bundle id>`.
5. Repeat the same steps and select the same App Group for the broadcast upload extension target.
6. Verify that `.entitlements` files are generated for Customer Application target and the broadcast upload extension target by Xcode, and `App Groups` values are the same in both `.entitlements` files.
7. Regenerate Provisioning Profile for Customer Application in [developer.apple.com](http://developer.apple.com/).
8. Create Provisioning Profile for the broadcast upload extension target.

**Important**: If the broadcast upload extension cannot access app group user defaults while testing in debug or after it’s signed for distribution, it’s very likely one of these steps that went wrong.

### Add RPSystemBroadcastPickerView

[RPSystemBroadcastPickerView](https://developer.apple.com/documentation/replaykit/rpsystembroadcastpickerview) is available on iOS 12 and above, and contains a button that brings up the system broadcast picker when tapped. This button functions the same as the **Screen Recording** button in iOS Control Center. Add this view to the application's view hierachy to be the device level screen sharing entry point.

```
// In the view controller
let pickerViewDiameter: CGFloat = 35
let pickerView = RPSystemBroadcastPickerView(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: pickerViewDiameter,
                                                           height: pickerViewDiameter))
pickerView.preferredExtension = <Your Broadcast Extension Bundle Identifier>

// Microphone audio is passed through Customer Application instead of broadcast extension.
pickerView.showsMicrophoneButton = false

// Set up view constrains as necessary.

view.addSubview(pickerView)
```

### Write MeetingSession data from Customer Application

When there is an active `MeetingSession`, write necessary data into the app group user defaults before sharing screen capture so that the `MeetingSession` can be recreated in the Broadcast Upload Extension. If Customer Application is using `DefaultMeetingSession` from Amazon Chime SDK for iOS, write `meetingId` string, a `MeetingSessionCredentials` instance, and a `MeetingSessionURLs` instance. Here is an example: 

```
// Get reference to current MeetingSession object.
let meetingSessionConfig = meetingSession.configuration
let userDefaultsKeyMeetingId = "demoMeetingId"
let userDefaultsKeyCredentials = "demoMeetingCredentials"
let userDefaultsKeyUrls = "demoMeetingUrls"

if let appGroupUserDefaults = UserDefaults(suiteName: <Your App Group Identifier>) {
    appGroupUserDefaults.set(meetingSessionConfig.meetingId, forKey: userDefaultsKeyMeetingId)
    let encoder = JSONEncoder()
    if let credentials = try? encoder.encode(meetingSessionConfig.credentials) {
        appGroupUserDefaults.set(credentials, forKey: userDefaultsKeyCredentials)
    }
    if let urls = try? encoder.encode(meetingSessionConfig.urls) {
        appGroupUserDefaults.set(urls, forKey: userDefaultsKeyUrls)
    }
}
```

### Read MeetingSession data from the Broadcast Upload Extension

When creating broadcast upload extension, Xcode creates a `SampleHandler` class that handles the screen capture data being captured. To recreate the `MeetingSessionConfiguration`, add code similar to the following:

```
let userDefaultsKeyMeetingId = "demoMeetingId"
let userDefaultsKeyCredentials = "demoMeetingCredentials"
let userDefaultsKeyUrls = "demoMeetingUrls"

class SampleHander {
    func recreatMeetingSessionConfig() -> MeetingSessionConfiguration? {
        guard let appGroupUserDefaults = UserDefaults(suiteName: <Your App Group Identifier>) else {
            logger.error(msg: "App Group User Defaults not found")
            return nil
        }
        let decoder = JSONDecoder()
        if let meetingId = appGroupUserDefaults.demoMeetingId,
           let credentialsData = appGroupUserDefaults.demoMeetingCredentials,
           let urlsData = appGroupUserDefaults.demoMeetingUrls,
           let credentials = try? decoder.decode(MeetingSessionCredentials.self, from: credentialsData),
           let urls = try? decoder.decode(MeetingSessionURLs.self, from: urlsData) {

            // Use the same URLRewriter as Customer Application.
            return MeetingSessionConfiguration(meetingId: meetingId,
                                               credentials: credentials,
                                               urls: urls,
                                               urlRewriter: URLRewriterUtils.defaultUrlRewriter)
        }
        return nil
    }
}

extension UserDefaults {
    @objc dynamic var demoMeetingId: String? {
        return string(forKey: userDefaultsKeyMeetingId)
    }
    @objc dynamic var demoMeetingCredentials: Data? {
        return object(forKey: userDefaultsKeyCredentials) as? Data
    }
    @objc dynamic var demoMeetingUrls: Data? {
        return object(forKey: userDefaultsKeyUrls) as? Data
    }
}
```

### Start Screen Share

After a user starts the broadcast, the following methods are called on `SampleHandler` to start the connection to send screen capture data. `ReplayKitSource` contains the conversion from the `CMSampleBuffer` that `ReplayKit` sends to `VideoFrame` that the Amazon Chime iOS SDK consumes, and handles device rotation. 

```
var currentMeetingSession: MeetingSession?
lazy var replayKitSource: ReplayKitSource = { return ReplayKitSource(logger: logger) }()
lazy var contentShareSource: ContentShareSource = {
    let source = ContentShareSource()
    source.videoSource = replayKitSource
    return source
}()

override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
    guard let config = getSavedMeetingSessionConfig() else {
        logger.error(msg: "Unable to recreate MeetingSessionConfiguration from Broadcast Extension")
        finishBroadcastWithError(NSError(domain: "AmazonChimeSDKDemoBroadcast", code: 0))
        return
    }
    currentMeetingSession = DefaultMeetingSession(configuration: config, logger: logger)
    currentMeetingSession?.audioVideo.startContentShare(source: contentShareSource)
}

override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
    replayKitSource.processSampleBuffer(sampleBuffer: sampleBuffer, type: sampleBufferType)
}
```

### Stop Screen Share

User can stop the broadcast by any one of the following:

* Tapping the `RPSystemBroadcastPickerView` added in Customer Application.
* Tapping the **status bar**.
* Tapping the **Screen Recorder** button in the Control Center.

The following method is called afterwards on the `SampleHandler`:

```
override func broadcastFinished() {
    replayKitSource.stop()
    currentMeetingSession?.audioVideo.stopContentShare()
}
```

To stop broadcast programmatically when the meeting session is ended from Customer Application, delete the meeting session data written in app group user defaults, and use [Key-Value-Observing](https://developer.apple.com/documentation/swift/cocoa_design_patterns/using_key-value_observing_in_swift) pattern in the `SampleHandler` to stop broadcasting after observing a change. 

```
// In the Customer Application
func endMeeting() {
    ...
    guard let appGroupUserDefaults = UserDefaults(suiteName: <Your App Group Identifier>) else {
            logger.error(msg: "App Group User Defaults not found")
            return
        }
    appGroupUserDefaults.removeObject(forKey: userDefaultsKeyMeetingId)
    appGroupUserDefaults.removeObject(forKey: userDefaultsKeyCredentials)
    appGroupUserDefaults.removeObject(forKey: userDefaultsKeyUrls)
}

// In the broadcast upload extension
class SampleHandler: RPBroadcastSampleHandler {
    let userDefaultsObserver: NSKeyValueObservation?

    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        ...

        // If the meetingId is changed from the demo app, we need to observe the meetingId and stop broadcast
        userDefaultsObserver = appGroupUserDefaults?.observe(\.demoMeetingId,
                                                 options: [.new, .old]) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            strongSelf.finishBroadcastWithError(NSError(domain: "<You App Domain>", code: errorCode))
        }
    }

    override func broadcastFinished() {
        ...
        userDefaultsObserver?.invalidate()
    }
}
```

## Viewing the content

Now users can share screen capture from within Customer Application, or bring up system broadcast picker to share device level screen capture. Users can view the screen share from another device by joining the same meeting session, the same way as viewing screen share from Amazon Chime SDK for Javascript. The `attendeeId` of a screen share is the same as the original attendee, but with a suffix of **#content** [videoTileDidAdd(tileState:)](https://github.com/zhinang-amazon/amazon-chime-sdk-ios/blob/content-share/AmazonChimeSDK/AmazonChimeSDK/audiovideo/video/VideoTileObserver.swift#L19) on `VideoTileObserver` is called with `tileState.isContent` being true for the screen share video stream.

```
// Get reference to current MeetingSession object.
// Add VideoTileObserver instance to receive video streams.
meetingSession.audioVideo.addVideoTileObserver(observer: observer)

// Your VideoTileObserver implementation
func videoTileDidAdd(tileState: VideoTileState) {
    if(tileState.isContent) {
        meetingSession.audioVideo.bindVideoView(videoView: videoView, 
                                                tileId: tileState.tileId)
    }
}
```
