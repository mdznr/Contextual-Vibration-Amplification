//
//  CMMotionActivity+MotionActivityType.h
//  Contextual Vibration Amplification
//
//  Created by Matt Zanchelli on 3/31/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

///	The different types of motion activity the device can interpret.
typedef NS_ENUM(NSUInteger, CMMotionActivityType) {
	///	The type of motion is unknown.
	/// There is no way to estimate the current type of motion. For example, the activity type might be @c CMMotionActivityTypeUnknown if the device was turned on recently and not enough motion data had been gathered to determine the type of motion.
	CMMotionActivityTypeUnknown = 0,
	///	The device is stationary.
	CMMotionActivityTypeStationary,
	///	The device is on a walking person.
	CMMotionActivityTypeWalking,
	///	The device is on a running person.
	CMMotionActivityTypeRunning,
	///	The device is in an automobile.
	CMMotionActivityTypeAutomotive
};

@interface CMMotionActivity (MotionActivityType)

///	The type of motion activity.
@property (readonly) CMMotionActivityType motionActivityType;

@end
