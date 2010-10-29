//
//  MyOrderViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/27/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyOrderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
	NSString *scheduledRunId;
}

- (IBAction) addOrderItem: (id) sender;

@property (nonatomic, copy) NSString *scheduledRunId;

@end
