//
//  CMMotionActivity+MotionActivityType.m
//  Contextual Vibration Amplification
//
//  Created by Matt Zanchelli on 3/31/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import "CMMotionActivity+MotionActivityType.h"

@implementation CMMotionActivity (MotionActivityType)

- (CMMotionActivityType)motionActivityType
{
	if ( [self stationary] ) {
		return CMMotionActivityTypeStationary;
	} else if ( [self walking] ) {
		return CMMotionActivityTypeWalking;
	} else if ( [self running] ) {
		return CMMotionActivityTypeRunning;
	} else if ( [self automotive ] ) {
		return CMMotionActivityTypeAutomotive;
	} else if ( [self unknown] ) {
		return CMMotionActivityTypeUnknown;
	} else {
		return CMMotionActivityTypeUnknown;
	}
}

@end
