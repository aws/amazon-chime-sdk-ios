Pod::Spec.new do |s|
  s.name             = 'AmazonChimeSDK-Bitcode'
  s.version          = '0.19.3'
  s.summary          = 'Amazon Chime SDK for iOS with Bitcode support.'
  s.description      = 'An iOS client library for integrating multi-party communications powered by the Amazon Chime service.'
  s.homepage         = 'https://github.com/aws/amazon-chime-sdk-ios'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'Amazon Web Services' => 'amazonwebservices' }
  s.source           = { :http => "https://amazon-chime-sdk-ios.s3.amazonaws.com/sdk/0.19.3/AmazonChimeSDK-0.19.3.tar.gz" }
  s.ios.deployment_target = '10.0'
  s.vendored_frameworks = "AmazonChimeSDK.xcframework"
  s.swift_version    = '5.0'
  s.dependency 'AmazonChimeSDKMedia-Bitcode', '~> 0.15.3'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
