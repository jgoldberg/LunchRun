//
//  OrderViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/27/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduledRun.h"


@interface ScheduledRunViewController : UIViewController {
	ScheduledRun *scheduledRun;
	IBOutlet UITextView *textView;
}

- (IBAction) viewMyOrder: (id) sender;
- (IBAction) sendOrder: (id) sender;

@property (nonatomic, retain) ScheduledRun *scheduledRun;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@end
