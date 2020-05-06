//
//  ViewControllerObjC.h
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AmazonChimeSDK/AmazonChimeSDK-Swift.h>

@interface ViewControllerObjC : UIViewController <RealtimeObserver, MetricsObserver, VideoTileObserver>

#define SERVER_URL "YOUR_SERVER_URL"
#define SERVER_REGION "YOUR_SERVER_REGION"

@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *leaveButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UITextField *meetingIDText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet DefaultVideoRenderView *selfVideoView;
@property (weak, nonatomic) IBOutlet DefaultVideoRenderView *remoteVideoView;

@property (nonatomic, strong) ConsoleLogger *logger;
@property (nonatomic, strong) DefaultMeetingSession *meetingSession;

@end

