Pod::Spec.new do |s|
  s.name             = 'AmazonChimeSDK'
  s.version          = '0.25.0001'
  s.summary          = 'Amazon Chime SDK for iOS.'
  s.description      = 'An iOS client library for integrating multi-party communications powered by the Amazon Chime service.'
  s.homepage         = 'https://github.com/aws/amazon-chime-sdk-ios'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'Amazon Web Services' => 'amazonwebservices' }
  s.source           = { :http => "https://amazon-chime-sdk-ios.s3.amazonaws.com/sdk/0.25.0001/AmazonChimeSDK-0.25.0001.tar.gz" }
  s.ios.deployment_target = '12.0'
  s.vendored_frameworks = "AmazonChimeSDK.xcframework"
  s.swift_version    = '5.0'
  s.dependency 'AmazonChimeSDKMedia', '0.20.0001'
end
