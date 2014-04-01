//
//  CVAViewController.h
//  Contextual Vibration Amplification
//
//  Created by Matt on 4/5/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface CVAViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSString *theText;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIProgressView *x;
@property (strong, nonatomic) IBOutlet UIProgressView *y;
@property (strong, nonatomic) IBOutlet UIProgressView *z;

@property (strong, nonatomic) IBOutlet UIButton *startStopButton;

- (IBAction)startStop:(id)sender;
- (IBAction)submitPressed:(id)sender;

@end
