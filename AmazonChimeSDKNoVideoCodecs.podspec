Pod::Spec.new do |s|
  s.name             = 'AmazonChimeSDKNoVideoCodecs'
  s.version          = '0.25.2'
  s.summary          = 'Amazon Chime SDK for iOS with no video codecs.'
  s.description      = 'An iOS client library for integrating multi-party communications powered by the Amazon Chime service.Use this one if you do not need video and content share functionality, or software video codec support, this will reduce your application size.'
  s.homepage         = 'https://github.com/aws/amazon-chime-sdk-ios'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'Amazon Web Services' => 'amazonwebservices' }
  s.source           = { :http => "https://amazon-chime-sdk-ios.s3.amazonaws.com/sdk/0.25.2/AmazonChimeSDK-0.25.2.tar.gz" }
  s.ios.deployment_target = '12.0'
  s.vendored_frameworks = "AmazonChimeSDK.xcframework"
  s.swift_version    = '5.0'
  s.dependency 'AmazonChimeSDKMediaNoVideoCodecs', '0.21.0'
end
