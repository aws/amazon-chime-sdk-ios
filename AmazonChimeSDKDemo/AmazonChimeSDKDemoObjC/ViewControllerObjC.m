//
//  ViewControllerObjC.m
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

#import "ViewControllerObjC.h"

@interface ViewControllerObjC ()

@property bool isBgBlurEnabled;
@property DefaultCameraCaptureSource * customSource;
@property BackgroundBlurVideoFrameProcessor *bgBlurProcessor;

@property (weak, nonatomic) IBOutlet UIView *joinView;
@property (weak, nonatomic) IBOutlet UIView *meetingView;

@end

@implementation ViewControllerObjC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isBgBlurEnabled = false;
    [self updateUIWithMeetingStarted:NO];
    self.logger = [[ConsoleLogger alloc] initWithName:@"ViewControllerObjC"
                                                level:LogLevelINFO];
    self.versionLabel.text = [NSString stringWithFormat:@"amazon-chime-sdk-ios@%@", [Versioning sdkVersion]];
    BackgroundBlurConfiguration *config = [[BackgroundBlurConfiguration alloc]
                                           initWithLogger:_logger
                                           blurStrength:BackgroundBlurStrengthHigh];
    BackgroundBlurVideoFrameProcessor *processor = [[BackgroundBlurVideoFrameProcessor alloc] initWithBackgroundBlurConfiguration:config];
    self.bgBlurProcessor = processor;
    
    DefaultCameraCaptureSource *customSource = [[DefaultCameraCaptureSource alloc] initWithLogger:_logger];
    self.customSource = customSource;
}

- (IBAction)joinMeeting:(id)sender {
    NSString* meetingId = [self formatInput:self.meetingIDText.text];
    NSString* name = [self formatInput:self.nameText.text];
    
    if (!meetingId.length || !name.length) {
        [self showAlertIn:self withMessage:@"MeetingID and Name cannot be empty." withDelay:0];
        return;
    }

    [self.joinButton setEnabled:NO];
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *url = [[NSString stringWithFormat:@"%sjoin?title=%@&name=%@&region=%s", SERVER_URL, meetingId, name, SERVER_REGION] stringByAddingPercentEncodingWithAllowedCharacters:set];
    [self makeHttpRequest:url withMethod:@"POST" withData:nil withCompletionBlock:^(NSData *data, NSError *error) {
        __weak typeof(self) weakSelf = self;

        if (error != nil) {
            [self showAlertIn:self
                  withMessage:[NSString stringWithFormat:@"Failed to join meeting, error: %@", error.localizedDescription]
                    withDelay:0];

            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.joinButton setEnabled:YES];
            });
            return;
        }

        if (data != nil) {
            // Parse meeting join data from JSON
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *joinInfoDict = [json objectForKey:@"JoinInfo"];
            NSDictionary *meetingInfoDict = [[joinInfoDict objectForKey:@"Meeting"] objectForKey:@"Meeting"];
            NSString *externalMeetingId = [meetingInfoDict objectForKey:@"ExternalMeetingId"];
            NSString *meetingId = [meetingInfoDict objectForKey:@"MeetingId"];
            NSString *mediaRegion = [meetingInfoDict objectForKey:@"MediaRegion"];

            NSDictionary *mediaPlacementDict = [meetingInfoDict objectForKey:@"MediaPlacement"];
            NSString *audioFallbackUrl = [mediaPlacementDict objectForKey:@"AudioFallbackUrl"];
            NSString *audioHostUrl = [mediaPlacementDict objectForKey:@"AudioHostUrl"];
            NSString *turnControlUrl = [mediaPlacementDict objectForKey:@"TurnControlUrl"];
            NSString *signalingUrl = [mediaPlacementDict objectForKey:@"SignalingUrl"];

            NSDictionary *attendeeInfoDict = [[joinInfoDict objectForKey:@"Attendee"] objectForKey:@"Attendee"];
            NSString *attendeeId = [attendeeInfoDict objectForKey:@"AttendeeId"];
            NSString *externalUserId = [attendeeInfoDict objectForKey:@"ExternalUserId"];
            NSString *joinToken = [attendeeInfoDict objectForKey:@"JoinToken"];

            // Initialize meeting session through AmazonChimeSDK
            MediaPlacement *mediaPlacement = [[MediaPlacement alloc] initWithAudioFallbackUrl:audioFallbackUrl
                                                                                 audioHostUrl:audioHostUrl
                                                                                 signalingUrl:signalingUrl
                                                                               turnControlUrl:turnControlUrl];

            Meeting *meeting = [[Meeting alloc] initWithExternalMeetingId:externalMeetingId
                                                           mediaPlacement:mediaPlacement
                                                              mediaRegion:mediaRegion
                                                                meetingId:meetingId];
            CreateMeetingResponse *createMeetingResponse = [[CreateMeetingResponse alloc] initWithMeeting:meeting];
            Attendee *attendee = [[Attendee alloc] initWithAttendeeId:attendeeId
                                                       externalUserId:externalUserId
                                                            joinToken:joinToken];
            CreateAttendeeResponse *createAttendeeResponse = [[CreateAttendeeResponse alloc] initWithAttendee:attendee];
            MeetingSessionConfiguration *meetingSessionConfiguration = [[MeetingSessionConfiguration alloc]
                                                                        initWithCreateMeetingResponse:createMeetingResponse
                                                                               createAttendeeResponse:createAttendeeResponse];

            self.meetingSession = [[DefaultMeetingSession alloc] initWithConfiguration:meetingSessionConfiguration
                                                                                logger:self.logger];
            [self startAudioVideo];

            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.joinButton setEnabled:YES];
            });
        }
    }];
}

- (void)startAudioVideo {
    if (self.meetingSession == nil) {
        [self.logger errorWithMsg:@"meetingSession is not initialized"];
        return;
    }

    NSError* error = nil;
    [self.meetingSession.audioVideo addEventAnalyticsObserverWithObserver:self];
    BOOL started = [self.meetingSession.audioVideo startAndReturnError:&error];
    if (started && error == nil) {
        [self.logger infoWithMsg:@"ObjC meeting session was started successfully"];
        [self updateUIWithMeetingStarted:YES];

        [self.meetingSession.audioVideo addRealtimeObserverWithObserver:self];
        [self.meetingSession.audioVideo addMetricsObserverWithObserver:self];
        [self.meetingSession.audioVideo addVideoTileObserverWithObserver:self];
        DefaultActiveSpeakerPolicy *policy = [DefaultActiveSpeakerPolicy new];
        [self.meetingSession.audioVideo addActiveSpeakerObserverWithPolicy:policy
                                                                  observer:self];

        [self startVideoClient];
    } else {
        NSString *errorMsg = [NSString stringWithFormat:@"Failed to start meeting, error: %@", error.description];
        [self.logger errorWithMsg:errorMsg];

        // Handle missing permission error
        if ([error.domain isEqual:@"AmazonChimeSDK.PermissionError"]) {
            AVAudioSessionRecordPermission permissionStatus = [[AVAudioSession sharedInstance] recordPermission];
            if (permissionStatus == AVAudioSessionRecordPermissionUndetermined) {
                [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                    if (granted) {
                        [self.logger infoWithMsg:@"Audio permission granted"];
                        // Retry after permission is granted
                        [self startAudioVideo];
                    }
                    else {
                        [self.logger infoWithMsg:@"Audio permission not granted"];
                        [self showAlertIn:self
                              withMessage:@"Please go to Settings and grant audio permission to this app."
                                withDelay:0];
                    }
                }];
            } else if (permissionStatus == AVAudioSessionRecordPermissionDenied) {
                [self.logger errorWithMsg:@"User did not grant permission, should redirect to Settings"];
                [self showAlertIn:self
                      withMessage:@"Please go to Settings and grant audio permission to this app."
                        withDelay:0];
            }
        } else {
            // Uncaught error
            [self showAlertIn:self
                  withMessage:errorMsg
                    withDelay:0];
        }
    }
}

- (void)startVideoClient {
    if (self.meetingSession == nil) {
        [self.logger errorWithMsg:@"meetingSession is not initialized"];
        return;
    }
    [self.logger infoWithMsg:@"Starting video client and enabling local and remote video..."];

    [self.meetingSession.audioVideo startRemoteVideo];
    [self.logger infoWithMsg:@"Remote video was started successfully"];

    NSError* error = nil;
    BOOL started = [self startLocalVideo:&error];
    if (started && error == nil) {
        [self.logger infoWithMsg:@"Self video was started successfully"];
    } else {
        NSString *errorMsg = [NSString stringWithFormat:@"Failed to start self video, error: %@", error.description];
        [self.logger errorWithMsg:errorMsg];

        // Handle missing permission error
        if ([error.domain isEqual:@"AmazonChimeSDK.PermissionError"]) {
            AVAuthorizationStatus permissionStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (permissionStatus == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        [self.logger infoWithMsg:@"Camera permission granted"];
                        // Retry after permission is granted
                        [self startVideoClient];
                    }
                    else {
                        [self.logger infoWithMsg:@"Camera permission not granted"];
                        [self showAlertIn:self
                              withMessage:@"Please go to Settings and grant camera permission to this app."
                                withDelay:0];
                    }
                }];
            } else if (permissionStatus == AVAuthorizationStatusDenied) {
                [self.logger errorWithMsg:@"User did not grant permission, should redirect to Settings"];
                [self showAlertIn:self
                      withMessage:@"Please go to Settings and grant camera permission to this app."
                        withDelay:0];
            }
        } else {
            // Uncaught error
            [self showAlertIn:self
                  withMessage:errorMsg
                    withDelay:0];
        }
    }
}

-(BOOL)startLocalVideo:(NSError **)error {
    if(self.isBgBlurEnabled) {
        [self.customSource start];
        [self.customSource addVideoSinkWithSink:self.bgBlurProcessor];
        [self.meetingSession.audioVideo startLocalVideoWithSource:self.bgBlurProcessor];
        return true;
    } else {
        [self.customSource removeVideoSinkWithSink:self.bgBlurProcessor];
        return [self.meetingSession.audioVideo startLocalVideoAndReturnError:error];
    }
}

- (IBAction)bgBlurButtonPressed:(id)sender {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Set video filter"
                                message:@"Choose a video filter for the selected video"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noFilter = [UIAlertAction
                               actionWithTitle:@"None"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
        self.isBgBlurEnabled = false;
        [self startLocalVideo:nil];
    }];
    
    UIAlertAction *bgBlurFilter = [UIAlertAction
                               actionWithTitle:@"Background Blur"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
        self.isBgBlurEnabled = true;
        [self startLocalVideo:nil];
    }];
    
    [alert addAction:noFilter];
    [alert addAction:bgBlurFilter];
    
    [self presentViewController:alert animated:true completion:nil];
}


- (IBAction)leaveMeeting:(id)sender {
    [self.meetingSession.audioVideo removeRealtimeObserverWithObserver:self];
    [self.meetingSession.audioVideo removeMetricsObserverWithObserver:self];
    [self.meetingSession.audioVideo removeVideoTileObserverWithObserver:self];
    [self.meetingSession.audioVideo removeActiveSpeakerObserverWithObserver:self];
    [self.meetingSession.audioVideo removeEventAnalyticsObserverWithObserver:self];
    if(self.isBgBlurEnabled) {
        self.isBgBlurEnabled = false;
        [self.customSource stop];
    }
    [self.meetingSession.audioVideo stop];
    [self updateUIWithMeetingStarted:NO];
}

- (void)updateUIWithMeetingStarted:(BOOL) started {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.joinView setHidden:started];
        [self.joinView endEditing:true];
        
        [self.meetingView setHidden:!started];
        [self.meetingView endEditing:true];
    });
}

- (NSString *)formatInput:(NSString *)text {
    return [[text stringByTrimmingCharactersInSet: NSCharacterSet.whitespaceAndNewlineCharacterSet] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (void)showAlertIn:(UIViewController *)controller withMessage:(NSString *)message withDelay:(double)seconds {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];

        if (seconds <= 0) {
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [controller dismissViewControllerAnimated:YES completion:nil];
            });
        }

        [controller presentViewController:alert animated:YES completion:nil];
    });
}

- (void)makeHttpRequest:(NSString *)url withMethod:(NSString *)method withData:(NSData *)data withCompletionBlock:(void (^)(NSData *, NSError *))completion {
    NSURL *serverUrl = [[NSURL alloc] initWithString:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:serverUrl];
    request.HTTPMethod = [method uppercaseString];

    if ([request.HTTPMethod isEqualToString:@"POST"] && data != nil) {
        request.HTTPBody = data;
    }

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            [self showAlertIn:self withMessage:error.localizedDescription withDelay:0];
            completion(nil, error);
            return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode < 200 || httpResponse.statusCode > 299) {
            [self showAlertIn:self withMessage:[NSString stringWithFormat:@"Received status code %ld", (long)httpResponse.statusCode] withDelay:0];
            completion(nil,
                       [NSError errorWithDomain:@"AmazonChimeSDKDemoObjC"
                                           code:httpResponse.statusCode
                                       userInfo:nil]);
        } else {
            completion(data, nil);
        }
    }];
    [task resume];
}

# pragma mark - RealtimeObserver

- (void)attendeesDidJoinWithAttendeeInfo:(NSArray<AttendeeInfo *> * _Nonnull)attendeeInfo {
    for (id currentAttendeeInfo in attendeeInfo) {
        [self.logger infoWithMsg:[NSString stringWithFormat:@"Attendee %@ joined", [currentAttendeeInfo attendeeId]]];
    }
}

- (void)attendeesDidLeaveWithAttendeeInfo:(NSArray<AttendeeInfo *> * _Nonnull)attendeeInfo {
    for (id currentAttendeeInfo in attendeeInfo) {
        [self.logger infoWithMsg:[NSString stringWithFormat:@"Attendee %@ left", [currentAttendeeInfo attendeeId]]];
    }
}

- (void)attendeesDidMuteWithAttendeeInfo:(NSArray<AttendeeInfo *> * _Nonnull)attendeeInfo {
    for (id currentAttendeeInfo in attendeeInfo) {
        [self.logger infoWithMsg:[NSString stringWithFormat:@"Attendee %@ muted", [currentAttendeeInfo attendeeId]]];
    }
}

- (void)attendeesDidUnmuteWithAttendeeInfo:(NSArray<AttendeeInfo *> * _Nonnull)attendeeInfo {
    for (id currentAttendeeInfo in attendeeInfo) {
        [self.logger infoWithMsg:[NSString stringWithFormat:@"Attendee %@ unmuted", [currentAttendeeInfo attendeeId]]];
    }
}

- (void)signalStrengthDidChangeWithSignalUpdates:(NSArray<SignalUpdate *> * _Nonnull)signalUpdates {
    for (id currentSignalUpdate in signalUpdates) {
        [self.logger infoWithMsg:[NSString stringWithFormat:@"Attendee %@ signalStrength changed to %lu", [[currentSignalUpdate attendeeInfo] attendeeId], (unsigned long)[currentSignalUpdate signalStrength]]];
    }
}

- (void)volumeDidChangeWithVolumeUpdates:(NSArray<VolumeUpdate *> * _Nonnull)volumeUpdates {
    for (id currentVolumeUpdate in volumeUpdates) {
        [self.logger infoWithMsg:[NSString stringWithFormat:@"Attendee %@ volumeLevel changed to %lu", [[currentVolumeUpdate attendeeInfo] attendeeId], (unsigned long)[currentVolumeUpdate volumeLevel]]];
    }
}

- (void)attendeesDidDropWithAttendeeInfo:(NSArray<AttendeeInfo *> * _Nonnull)attendeeInfo {
    for (id currentAttendeeInfo in attendeeInfo) {
        [self.logger infoWithMsg:[NSString stringWithFormat:@"Attendee %@ dropped", [currentAttendeeInfo attendeeId]]];
    }
}

# pragma mark - MetricsObserver

- (void)metricsDidReceiveWithMetrics:(NSDictionary *)metrics {
    [self.logger infoWithMsg:[NSString stringWithFormat:@"Media metrics have been received: %@", metrics]];
}

# pragma mark - VideoTileObserver

- (void)videoTileDidAddWithTileState:(VideoTileState *)tileState {
    [self.logger infoWithMsg:[NSString stringWithFormat:@"Adding Video Tile tileId: %ld, attendeeId: %@", (long)tileState.tileId, tileState.attendeeId]];

    DefaultVideoRenderView *renderView = nil;
    if (tileState.isLocalTile) {
        [self.logger infoWithMsg:[NSString stringWithFormat:@"Binding self video"]];
        renderView = self.selfVideoView;

        // Flip front camera video on rendering
        if (self.meetingSession.audioVideo.getActiveCamera.type == MediaDeviceTypeVideoFrontCamera) {
            renderView.mirror = YES;
        }
    } else {
        [self.logger infoWithMsg:[NSString stringWithFormat:@"Binding remote video"]];
        renderView = self.remoteVideoView;
    }

    [self.meetingSession.audioVideo bindVideoViewWithVideoView:renderView tileId:tileState.tileId];
}

- (void)videoTileDidRemoveWithTileState:(VideoTileState *)tileState {
    [self.logger infoWithMsg:[NSString stringWithFormat:@"Removing Video Tile tileId: %ld, attendeeId: %@", (long)tileState.tileId, tileState.attendeeId]];
    [self.meetingSession.audioVideo unbindVideoViewWithTileId:tileState.tileId];
    if (![tileState isLocalTile]) {
        [self.remoteVideoView resetImage];
    }
}

- (void)videoTileDidPauseWithTileState:(VideoTileState *)tileState {
    [self.logger infoWithMsg:[NSString stringWithFormat:@"Video Tile paused: tileId: %ld, attendeeId: %@", (long)tileState.tileId, tileState.attendeeId]];
}

- (void)videoTileDidResumeWithTileState:(VideoTileState *)tileState {
    [self.logger infoWithMsg:[NSString stringWithFormat:@"Video Tile resumed: tileId: %ld, attendeeId: %@", (long)tileState.tileId, tileState.attendeeId]];
}

- (void)videoTileSizeDidChangeWithTileState:(VideoTileState *)tileState {
    [self.logger infoWithMsg:[NSString stringWithFormat:@"Video Tile size changed: tileId: %ld, attendeeId: %@", (long)tileState.tileId, tileState.attendeeId]];
}

# pragma mark - ActiveSpeakerObserver

- (void)activeSpeakerScoreDidChangeWithScores:(NSDictionary<AttendeeInfo *, NSNumber *> * _Nonnull)scores {
    [self.logger infoWithMsg:@"activeSpeakerScoreDidChangeWithScores callback invoked"];
}

- (void)activeSpeakerDidDetectWithAttendeeInfo:(NSArray<AttendeeInfo *> * _Nonnull)attendeeInfo {
    [self.logger infoWithMsg:@"activeSpeakerDidDetectWithAttendeeInfo callback invoked"];
}

- (NSInteger)scoresCallbackIntervalMs {
    return 5000;
}

- (NSString*)observerId {
    return [NSUUID new].UUIDString;
}

# pragma mark - EventAnalyticObserver
- (void)eventDidReceiveWithName:(enum EventName)name attributes:(NSDictionary *)attributes {
    [self.logger infoWithMsg:[NSString stringWithFormat:@"%lu %@\n", (unsigned long)name, [attributes toJsonString]]];
}

@end
