Pod::Spec.new do |s|
  s.name             = 'AmazonChimeSDKMedia-No-Bitcode'
  s.version          = '0.17.1'
  s.summary          = 'Amazon Chime SDK Media for iOS without Bitcode support.'
  s.description      = 'An iOS client library for integrating multi-party communications powered by the Amazon Chime service.'
  s.homepage         = 'https://github.com/aws/amazon-chime-sdk-ios'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'Amazon Web Services' => 'amazonwebservices' }
  s.source           = { :http => "https://amazon-chime-sdk-ios.s3.amazonaws.com/media-without-bitcode/0.17.1/AmazonChimeSDKMedia-0.17.1.tar.gz" }
  s.ios.deployment_target = '10.0'
  s.vendored_frameworks = "AmazonChimeSDKMedia.xcframework"
  s.swift_version    = '5.0'
end
