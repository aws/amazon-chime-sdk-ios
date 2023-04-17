# Minimal Demo Application
[Amazon Chime SDK Project Board](https://aws.github.io/amazon-chime-sdk-js/modules/projectboard.html)

> Note: This demo uses 0.23.0 SDK and 0.18.0 media SDK

## Prerequisites

1. Physical iOS device (CallKit requires real device to work)
2. Aws account to deploy backend demo
3. Xcode 14.2
4. Cocoapods

## Steps to run demo application
1. Deploy the backend demo api, it will create an AWS ApiGateway, the url will look like https://xxxxx.xxxxx.xxx.com/prod/.
2. In termianl, go to directory `./AmazonChimeSDKDemo`, run `pod install`.
3. Open `./AmazonChimeSDKDemo/AmazonChimeSDKDemo.xcworkspace` with Xcode.
4. In Xcode, open `AppConfiguration.swift`, set the url to the ApiGateway url, set region to the ApiGateway region.
5. Run the project 

## Notice
You and your end users are responsible for all Content (including any images) uploaded for use with background replacement, and must ensure that such Content does not violate the law, infringe or misappropriate the rights of any third party, or otherwise violate a material term of your agreement with Amazon (including the documentation, the AWS Service Terms, or the Acceptable Use Policy).

---

Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
