Pod::Spec.new do |s|
  s.name             = 'AmazonChimeSDKMedia-Bitcode'
  s.version          = '0.15.3'
  s.summary          = 'Amazon Chime SDK Media for iOS with Bitcode support.'
  s.description      = 'An iOS client library for integrating multi-party communications powered by the Amazon Chime service.'
  s.homepage         = 'https://github.com/aws/amazon-chime-sdk-ios'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'Amazon Web Services' => 'amazonwebservices' }
  s.source           = { :http => "https://amazon-chime-sdk-ios.s3.amazonaws.com/media/0.15.3/AmazonChimeSDKMedia-0.15.3.tar.gz" }
  s.ios.deployment_target = '10.0'
  s.vendored_frameworks = "AmazonChimeSDKMedia.xcframework"
  s.swift_version    = '5.0'
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
