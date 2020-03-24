## Amazon Chime SDK for iOS

### Build video calling, audio calling, and screen sharing applications powered by Amazon Chime.

The Amazon Chime SDK makes it easy to add collaborative audio calling,
video calling, and screen share viewing features to iOS applications by 
using the same infrastructure services that power millions of Amazon Chime
online meetings.

This Amazon Chime SDK for iOS works by connecting to meeting session
resources that you have created in your AWS account. The SDK has everything
you need to build custom calling and collaboration experiences in your
iOS application, including methods to: configure meeting sessions, list 
and select audio devices, switch video devices, start and stop screen share 
viewing, receive callbacks when media events occur such as volume changes, 
and control meeting features such as audio mute and video tile bindings.

To get started, see the following resources:

* [Amazon Chime](https://aws.amazon.com/chime)
* [Amazon Chime Developer Guide](https://docs.aws.amazon.com/chime/latest/dg/what-is-chime.html)
* [Amazon Chime SDK API Reference](http://docs.aws.amazon.com/chime/latest/APIReference/Welcome.html)
* TODO - Link to API documentation

And review the following guides:

* [Getting Started](https://aws.github.io/amazon-chime-sdk-ios/modules/gettingstarted.html)
* TODO - Verify that above link works once in aws org

### Setup

For the purpose of setup, your project's root folder will be referred to as `root`

#### 1. Download binaries

We are working on making the binaries available on Cocoapods and Carthage.

Download the following binaries and copy them to `root`
* TODO - Link to URL for `AmazonChimeSDK.framework`
* TODO - Link to URL for `AmazonChimeSDKMedia.framework`

### 2. Update project file

Under `Build Settings` tab, add the `root` path to `Framework Search Path`

Under `Build Settings` tab, add `@executable_path/Frameworks` to `Runpath Search Paths`

Under `General` tab, look for `Frameworks, Libraries, and Embedded Content` section. Click on `+`, then `Add Others`, then `Add Files`. Specify the location of `AmazonChimeSDK.framework` from Step 1

After adding `AmazonChimeSDK.framework`, verify that `Embed & Sign` is selected under the `Embed` option.

Repeat the above steps with `AmazonChimeSDKMedia.framework`

In `Build Settings` tab, under `Linking` section, add the following two flags in `Other Linker Flags`:
* `-lc++`
* `-ObjC`

### Running the demo app

To run the demo application:

1. Deploy the serverless demo from [amazon-chime-sdk-js](https://github.com/aws/amazon-chime-sdk-js)

2. Update `AppConfiguration.swift` with the URL and region of the serverless demo

## Reporting a suspected vulnerability

If you discover a potential security issue in this project we ask that you notify AWS/Amazon Security via our
[vulnerability reporting page](http://aws.amazon.com/security/vulnerability-reporting/).
Please do **not** create a public GitHub issue.

Copyright 2019-2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
