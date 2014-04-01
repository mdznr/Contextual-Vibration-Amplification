//
//  CVAViewController.m
//  Contextual Vibration Amplification
//
//  Created by Matt on 4/5/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "CVAViewController.h"

#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import "CMMotionActivity+MotionActivityType.h"

#define SQUARE(x) pow(x,2)

void AudioServicesPlaySystemSoundWithVibration(SystemSoundID inSystemSoundID, id arg, NSDictionary *vibratePattern);

@interface CVAViewController ()

// Our motion manager.
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) CGFloat netAcceleration;

@property BOOL isStopped;

@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;

@end

@implementation CVAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	_motionActivityManager = [[CMMotionActivityManager alloc] init];
	[_motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue new]
											withHandler:^(CMMotionActivity *activity) {
												[self performSelector:@selector(handleMotionActivity:) withObject:activity];
											}];
	
	_theText = @"";
	_isStopped = YES;
	_netAcceleration = 0.2f;
	
	[NSTimer scheduledTimerWithTimeInterval:5.0f
									 target:self
								   selector:@selector(vibrate)
								   userInfo:nil
									repeats:YES];
}

- (void)handleMotionActivity:(CMMotionActivity *)activity
{
	NSLog(@"%@", activity);
	CMMotionActivityType motionActivityType = [activity motionActivityType];
}

///	Vibrate with a certain intensity.
///	@param intensity A floating point value from 0 to 1 representing the intensity of the vibration. 0 being the least intense, and 1 being most intense.
- (void)vibrateWithIntensity:(CGFloat)intensity
{
#warning `vibrateWithIntensity:` not yet implemented.
}

- (void)vibrate
{
	CGFloat multiplier;
	int y, n;
	
	if ( [CMMotionActivityManager isActivityAvailable] ) {
		multiplier = 1;
	} else {
		multiplier = SQUARE(MAX(MIN(_netAcceleration, 3), .5));
		
		int y = 200 * multiplier;
		int n = 5 / multiplier;
		
		NSLog(@"%f", _netAcceleration);
		NSLog(@"multiplier: %f y: %d, n: %d", multiplier, y, n);
	}
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	
	if ( multiplier > .25 ) {
		[arr addObjectsFromArray:@[[NSNumber numberWithBool:YES], [NSNumber numberWithInt:y],
								   [NSNumber numberWithBool:NO], [NSNumber numberWithInt:n]]];
		[arr addObjectsFromArray:@[[NSNumber numberWithBool:YES], [NSNumber numberWithInt:y],
								   [NSNumber numberWithBool:NO], [NSNumber numberWithInt:n]]];
		[arr addObjectsFromArray:@[[NSNumber numberWithBool:YES], [NSNumber numberWithInt:y],
								   [NSNumber numberWithBool:NO], [NSNumber numberWithInt:n]]];
		[arr addObjectsFromArray:@[[NSNumber numberWithBool:YES], [NSNumber numberWithInt:y],
								   [NSNumber numberWithBool:NO], [NSNumber numberWithInt:n]]];
		[arr addObjectsFromArray:@[[NSNumber numberWithBool:YES], [NSNumber numberWithInt:y],
								   [NSNumber numberWithBool:NO], [NSNumber numberWithInt:n]]];
	}
	
	[arr addObjectsFromArray:@[[NSNumber numberWithBool:YES], [NSNumber numberWithInt:y],
							   [NSNumber numberWithBool:NO], [NSNumber numberWithInt:n]]];
	[arr addObjectsFromArray:@[[NSNumber numberWithBool:YES], [NSNumber numberWithInt:y],
							   [NSNumber numberWithBool:NO], [NSNumber numberWithInt:n]]];
	[arr addObjectsFromArray:@[[NSNumber numberWithBool:YES], [NSNumber numberWithInt:y],
							   [NSNumber numberWithBool:NO], [NSNumber numberWithInt:n]]];
	[arr addObjectsFromArray:@[[NSNumber numberWithBool:YES], [NSNumber numberWithInt:y],
							   [NSNumber numberWithBool:NO], [NSNumber numberWithInt:n]]];
	[arr addObjectsFromArray:@[[NSNumber numberWithBool:YES], [NSNumber numberWithInt:y],
							   [NSNumber numberWithBool:NO], [NSNumber numberWithInt:n]]];
	
	[dict setObject:arr forKey:@"VibePattern"];
	[dict setObject:[NSNumber numberWithInt:1] forKey:@"Intensity"];
	
	AudioServicesPlaySystemSoundWithVibration(4095, nil, dict);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stopMotionDetection
{
	if ( self.motionManager ) {
		[self.motionManager stopDeviceMotionUpdates];
		self.motionManager = nil;
	}
}

- (void)resumeMotionDetection
{
	if ( self.motionManager != nil ) {
		NSLog(@"Motion is already active.");
		return;
	}
	
	// Set up a motion manager and start motion updates, calling deviceMotionDidUpdate: when updated.
	self.motionManager = [[CMMotionManager alloc] init];
	self.motionManager.deviceMotionUpdateInterval = 1.0/60.0;
	
	if ( self.motionManager.deviceMotionAvailable ) {
		NSOperationQueue *queue = [NSOperationQueue currentQueue];
		[self.motionManager startDeviceMotionUpdatesToQueue:queue
												withHandler:^(CMDeviceMotion *motionData, NSError *error) {
													[self deviceMotionDidUpdate:motionData];
												}];
	}
}

- (void)deviceMotionDidUpdate:(CMDeviceMotion *)motionData
{
	_theText = [_theText stringByAppendingFormat:@"%@\t%f\t%f\t%f\n", [NSDate date], motionData.userAcceleration.x, motionData.userAcceleration.y, motionData.userAcceleration.z];
	
	[_x setProgress:0.5 + (motionData.userAcceleration.x)/2];
	[_y setProgress:0.5 + (motionData.userAcceleration.y)/2];
	[_z setProgress:0.5 + (motionData.userAcceleration.z)/2];
	
	_netAcceleration = sqrt(sqrt(SQUARE(motionData.userAcceleration.x) + SQUARE(motionData.userAcceleration.y)) + SQUARE(motionData.userAcceleration.z));
#warning perhaps take into account pitch (flat on a table)
#warning perhaps take into account microphone levels
}

- (IBAction)startStop:(id)sender
{
	if ( _isStopped == YES ) {
		[self start];
	} else {
		[self stop];
	}
}

- (void)start
{
	[_startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
	[_startStopButton setTitle:@"Stop" forState:UIControlStateHighlighted];
	[_startStopButton setTitle:@"Stop" forState:UIControlStateDisabled];
	[_startStopButton setTitle:@"Stop" forState:UIControlStateSelected];
	
	[self resumeMotionDetection];
	
	_isStopped = NO;
}

- (void)stop
{
	[_startStopButton setTitle:@"Start" forState:UIControlStateNormal];
	[_startStopButton setTitle:@"Start" forState:UIControlStateHighlighted];
	[_startStopButton setTitle:@"Start" forState:UIControlStateDisabled];
	[_startStopButton setTitle:@"Start" forState:UIControlStateSelected];
	
	[self stopMotionDetection];
	
	_isStopped = YES;
	
	_netAcceleration = 0.2f;
}

- (IBAction)submitPressed:(id)sender
{
	[self stop];
	if ( [MFMailComposeViewController canSendMail ]) {
		MFMailComposeViewController* mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
		
        NSArray *toRecipients = [NSArray arrayWithObjects:@"matt@mdznr.com", nil];
        [mailer setToRecipients:toRecipients];
        [mailer setSubject:@"Contextual Vibration Amplification"];
		[mailer setMessageBody:_theText isHTML:NO];
		
		[mailer setModalPresentationStyle:UIModalPresentationPageSheet];
		[mailer setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
		[self presentViewController:mailer animated:YES completion:nil];
    } else {
		[_textView setText:_theText];
    }
	_theText = @"";
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
		  didFinishWithResult:(MFMailComposeResult)result
						error:(NSError*)error
{
	switch ( result ) {
		case MFMailComposeResultCancelled:
			NSLog(@"Support Email Cancelled");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Support Email Failed");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Support Email Saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Support Email Sent");
			break;
		default:
			break;
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
