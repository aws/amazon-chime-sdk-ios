Pod::Spec.new do |s|
  s.name             = 'AmazonChimeSDKMediaNoVideoCodecs-No-Bitcode'
  s.version          = '0.19.0'
  s.summary          = 'Amazon Chime SDK Media for iOS without Bitcode support.'
  s.description      = 'An iOS client library for integrating multi-party communications powered by the Amazon Chime service.'
  s.homepage         = 'https://github.com/aws/amazon-chime-sdk-ios'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'Amazon Web Services' => 'amazonwebservices' }
  s.source           = { :http => "https://amazon-chime-sdk-ios.s3.amazonaws.com/media-no-video-codecs-without-bitcode/0.19.0/AmazonChimeSDKMediaNoVideoCodecs-0.19.0.tar.gz" }
  s.ios.deployment_target = '11.0'
  s.vendored_frameworks = "AmazonChimeSDKMedia.xcframework"
  s.swift_version    = '5.0'
end
