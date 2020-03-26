//
//  ViewControllerObjC.m
//  AmazonChimeSDKDemo
//
//  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
//  SPDX-License-Identifier: Apache-2.0
//

#import "ViewControllerObjC.h"

@interface ViewControllerObjC ()

@end

@implementation ViewControllerObjC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUIWithMeetingStarted:NO];
    self.logger = [[ConsoleLogger alloc] initWithName:@"ViewControllerObjC"
                                                level:LogLevelDEFAULT];
}

- (IBAction)joinMeeting:(id)sender {
    NSString* meetingId = [self formatInput:self.meetingIDText.text];
    NSString* name = [self formatInput:self.nameText.text];

    if (!meetingId.length || !name.length) {
        [self showAlertIn:self withMessage:@"MeetingID and Name cannot be empty." withDelay:0];
        return;
    }

    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *url = [[NSString stringWithFormat:@"%sjoin?title=%@&name=%@&region=%s", SERVER_URL, meetingId, name, SERVER_REGION] stringByAddingPercentEncodingWithAllowedCharacters:set];
    [self makeHttpRequest:url withMethod:@"POST" withData:nil withCompletionBlock:^(NSData *data, NSError *error) {
        if (error != nil) {
            [self showAlertIn:self
                  withMessage:[NSString stringWithFormat:@"Failed to join meeting, error: %@", error.localizedDescription]
                    withDelay:0];
            return;
        }

        if (data != nil) {
            // Parse meeting join data from JSON
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSDictionary *joinInfoDict = [json objectForKey:@"JoinInfo"];
            NSDictionary *meetingInfoDict = [joinInfoDict objectForKey:@"Meeting"];
            NSDictionary *mediaPlacementDict = [meetingInfoDict objectForKey:@"MediaPlacement"];
            NSDictionary *attendeeInfoDict = [joinInfoDict objectForKey:@"Attendee"];

            NSString *meetingId = [meetingInfoDict objectForKey:@"MeetingId"];
            NSString *audioFallbackUrl = [mediaPlacementDict objectForKey:@"AudioFallbackUrl"];
            NSString *audioHostUrl = [mediaPlacementDict objectForKey:@"AudioHostUrl"];
            NSString *turnControlUrl = [mediaPlacementDict objectForKey:@"TurnControlUrl"];
            NSString *signalingUrl = [mediaPlacementDict objectForKey:@"SignalingUrl"];
            NSString *attendeeId = [attendeeInfoDict objectForKey:@"AttendeeId"];
            NSString *joinToken = [attendeeInfoDict objectForKey:@"JoinToken"];

            // Initialize meeting session through AmazonChimeSDK
            MediaPlacement *mediaPlacement = [[MediaPlacement alloc] initWithAudioFallbackUrl:audioFallbackUrl
                                                                                 audioHostUrl:audioHostUrl
                                                                               turnControlUrl:turnControlUrl
                                                                                 signalingUrl:signalingUrl];

            Meeting *meeting = [[Meeting alloc] initWithMeetingId:meetingId
                                                   mediaPlacement:mediaPlacement];
            CreateMeetingResponse *createMeetingResponse = [[CreateMeetingResponse alloc] initWithMeeting:meeting];
            Attendee *attendee = [[Attendee alloc] initWithAttendeeId:attendeeId joinToken:joinToken];
            CreateAttendeeResponse *createAttendeeResponse = [[CreateAttendeeResponse alloc] initWithAttendee:attendee];
            MeetingSessionConfiguration *meetingSessionConfiguration = [[MeetingSessionConfiguration alloc] initWithCreateMeetingResponse:createMeetingResponse
                                                                                                                   createAttendeeResponse:createAttendeeResponse];

            self.meetingSession = [[DefaultMeetingSession alloc] initWithConfiguration:meetingSessionConfiguration
                                                                                logger:self.logger];
            [self startAudioClient];
        }
    }];
}

- (void)startAudioClient {
    if (self.meetingSession == nil) {
        [self.logger errorWithMsg:@"meetingSession is not initialized"];
        return;
    }

    NSError* error = nil;
    BOOL started = [self.meetingSession.audioVideo startAndReturnError:&error];
    if (started && error == nil) {
        [self.logger infoWithMsg:@"ObjC meeting session was started successfully"];
        [self showAlertIn:self
              withMessage:@"Meeting started"
                withDelay:2];
        [self updateUIWithMeetingStarted:YES];
        [self.meetingSession.audioVideo addRealtimeObserverWithObserver:self];
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
                        [self startAudioClient];
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

- (IBAction)leaveMeeting:(id)sender {
    [self.meetingSession.audioVideo stop];
    [self updateUIWithMeetingStarted:NO];
}

- (void)updateUIWithMeetingStarted:(BOOL) started {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.titleLabel setText:started ? @"Meeting started" : @"Join a meeting"];
        [self.meetingIDText setEnabled:!started];
        [self.nameText setEnabled:!started];
        [self.joinButton setHidden:started];
        [self.leaveButton setHidden:!started];
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
            completion(nil, error);
        } else {
            completion(data, nil);
        }
    }];
    [task resume];
}

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
        [self.logger infoWithMsg:[NSString stringWithFormat:@"Attendee %@ signalStrength changed to %lu", [[currentSignalUpdate attendeeInfo] attendeeId], [currentSignalUpdate signalStrength]]];
    }
}

- (void)volumeDidChangeWithVolumeUpdates:(NSArray<VolumeUpdate *> * _Nonnull)volumeUpdates {
    for (id currentVolumeUpdate in volumeUpdates) {
        [self.logger infoWithMsg:[NSString stringWithFormat:@"Attendee %@ volumeLevel changed to %ld", [[currentVolumeUpdate attendeeInfo] attendeeId], [currentVolumeUpdate volumeLevel]]];
    }
}

@end
