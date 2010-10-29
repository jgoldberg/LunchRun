//
//  OrderViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/27/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScheduledRunViewController : UIViewController {
	NSString *scheduledRunId;
}

- (IBAction) viewMyOrder: (id) sender;

@property (nonatomic, copy) NSString *scheduledRunId;

@end
