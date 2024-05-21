Pod::Spec.new do |s|
  s.name             = 'AmazonChimeSDKMachineLearning'
  s.version          = '0.3.1'
  s.summary          = 'Amazon Chime SDK Machine Learning features in iOS for Background Blur and Replacement.'
  s.description      = 'An iOS client library for integrating multi-party communications powered by the Amazon Chime service. This is mainly used for Background Blur and Replacement.'
  s.homepage         = 'https://github.com/aws/amazon-chime-sdk-ios'
  s.license          = 'Apache License, Version 2.0'
  s.author           = { 'Amazon Web Services' => 'amazonwebservices' }
  s.source           = { :http => "https://amazon-chime-sdk-ios.s3.amazonaws.com/machine-learning/0.3.1/AmazonChimeSDKMachineLearning-0.3.1.tar.gz" }
  s.ios.deployment_target = '12.0'
  s.vendored_frameworks = "AmazonChimeSDKMachineLearning.xcframework"
  s.swift_version    = '5.0'
  s.library          = 'c++'
end
