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

@property (nonatomic, strong) CMMotionActivityManager *motionActivityManager;
@property (atomic) CMMotionActivityType motionActivityType;

@end

@implementation CVAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_motionActivityType = CMMotionActivityTypeUnknown;
	
	_motionActivityManager = [[CMMotionActivityManager alloc] init];
	[_motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue new]
											withHandler:^(CMMotionActivity *activity) {
												_motionActivityType = [activity motionActivityType];
											}];
	
	[NSTimer scheduledTimerWithTimeInterval:2.0f
									 target:self
								   selector:@selector(vibrate)
								   userInfo:nil
									repeats:YES];
}

///	Vibrate with a certain intensity.
///	@param intensity A floating point value from 0 to 1 representing the intensity of the vibration. 0 being the least intense, and 1 being most intense.
- (void)vibrateWithIntensity:(CGFloat)intensity
{
	// The intensity must be between 0 and 1.
	intensity = MIN(MAX(0, intensity), 1);
	
	CGFloat maxMultiplier = 20.0f;
	
	NSMutableArray *vibePattern = [[NSMutableArray alloc] init];
	
	int on = 75;
	int off = 1;
	
	for ( CGFloat i=0; i<intensity; i += 1.0f/maxMultiplier ) {
		[vibePattern addObjectsFromArray:@[@(YES), @(on)]];
		[vibePattern addObjectsFromArray:@[@(NO), @(off)]];
	}
	
	NSDictionary *pulsePatternDict = @{@"VibePattern": vibePattern,
									   @"Intensity": [NSNumber numberWithInt:1]};
	
	AudioServicesPlaySystemSoundWithVibration(4095, nil, pulsePatternDict);
}

- (void)vibrate
{
	NSLog(@"%lu", _motionActivityType);
	
	CGFloat intensity;
	switch (_motionActivityType) {
		case CMMotionActivityTypeStationary:
			intensity = 0.2f;
			break;
		case CMMotionActivityTypeWalking:
			intensity = 0.6;
			break;
		case CMMotionActivityTypeRunning:
			intensity = 1.0f;
			break;
		case CMMotionActivityTypeAutomotive:
			intensity = 0.1f;
			break;
		case CMMotionActivityTypeUnknown:
		default:
			intensity = 0.3f;
			break;
	}
	
	[self vibrateWithIntensity:intensity];
}


#pragma mark - UIViewController Misc.

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

@end
