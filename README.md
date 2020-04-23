# Amazon Chime SDK for iOS

## Build video calling, audio calling, and screen sharing applications powered by Amazon Chime.

The Amazon Chime SDK for iOS makes it easy to add collaborative audio calling,
video calling, and screen share viewing features to iOS applications by 
using the same infrastructure services that power meetings on the Amazon 
Chime service.

This Amazon Chime SDK for iOS works by connecting to meeting session
resources that you have created in your AWS account. The SDK has everything
you need to build custom calling and collaboration experiences in your
iOS application, including methods to: configure meeting sessions, list 
and select audio devices, switch video devices, start and stop screen share 
viewing, receive callbacks when media events occur such as volume changes, 
and manage meeting features such as audio mute and video tile bindings.

To get started, see the following resources:

* [Amazon Chime](https://aws.amazon.com/chime)
* [Amazon Chime Developer Guide](https://docs.aws.amazon.com/chime/latest/dg/what-is-chime.html)
* [Amazon Chime SDK API Reference](http://docs.aws.amazon.com/chime/latest/APIReference/Welcome.html)
* [SDK Documentation](https://aws.github.io/amazon-chime-sdk-ios/)

And review the following guides:

* [Getting Started](https://github.com/aws/amazon-chime-sdk-ios/blob/master/guides/01_Getting_Started.md)

## Setup

To include the SDK binaries in your own project, follow these steps.

For the purpose of setup, your project's root folder (where you can find your `.xcodeproj` file) will be referred to as `root`

### 1. Download binaries

Download the following zips:
 * if you need bitcode support:
  * [AmazonChimeSDK-0.5.1.tar.gz](https://amazon-chime-sdk.s3.amazonaws.com/ios/amazon-chime-sdk/0.5.1/AmazonChimeSDK-0.5.1.tar.gz)
  * [AmazonChimeSDKMedia-0.4.1.tar.gz](https://amazon-chime-sdk.s3.amazonaws.com/ios/amazon-chime-sdk-media/0.4.1/AmazonChimeSDKMedia-0.4.1.tar.gz)
 * if you do NOT need bitcode support:
  * [AmazonChimeSDK-0.5.1.tar.gz](https://amazon-chime-sdk.s3.amazonaws.com/ios/amazon-chime-sdk-without-bitcode/0.5.1/AmazonChimeSDK-0.5.1.tar.gz)
  * [AmazonChimeSDKMedia-0.4.1.tar.gz](https://amazon-chime-sdk.s3.amazonaws.com/ios/amazon-chime-sdk-media-without-bitcode/0.4.1/AmazonChimeSDKMedia-0.4.1.tar.gz)

Unzip and copy the `.framework`s to `root`

### 2. Update project file

Open your `.xcodeproj` file in Xcode and click on your build target. Under `Build Settings` tab, add `$(PROJECT_DIR)` to `Framework Search Path`

Under `Build Settings` tab, add `@executable_path/Frameworks` to `Runpath Search Paths`

Under `General` tab, look for `Frameworks, Libraries, and Embedded Content` section. Click on `+`, then `Add Others`, then `Add Files`. Specify the location of `AmazonChimeSDK.framework` and `AmazonChimeSDKMedia.framework` from Step 1

After adding the two frameworks, verify that `Embed & Sign` is selected under the `Embed` option.

In `Build Settings` tab, under `Linking` section, add the following two flags in `Other Linker Flags`:

* `-lc++`
* `-ObjC`

## Running the demo app

To run the demo application, follow these steps.

### 1. Clone the Git repo

`git clone git@github.com:aws/amazon-chime-sdk-ios.git`

### 2. Download binary

Download the following zip:

* [AmazonChimeSDKMedia-0.4.1.tar.gz](https://amazon-chime-sdk.s3.amazonaws.com/ios/amazon-chime-sdk-media-without-bitcode/0.4.1/AmazonChimeSDKMedia-0.4.1.tar.gz)

Unzip and copy the .framework to `AmazonChimeSDK` and `AmazonChimeSDKDemo` folder

### 3. Deploy serverless demo

Deploy the serverless demo from [amazon-chime-sdk-js](https://github.com/aws/amazon-chime-sdk-js)

### 4. Update Demo App

Update `AppConfiguration.swift` with the URL and region of the serverless demo

## Reporting a suspected vulnerability

If you discover a potential security issue in this project we ask that you notify AWS/Amazon Security via our
[vulnerability reporting page](http://aws.amazon.com/security/vulnerability-reporting/). Please do **not** create a public GitHub issue.

Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
