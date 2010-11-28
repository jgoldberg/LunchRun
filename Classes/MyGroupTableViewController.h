//
//  MyGroupTableViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyGroupTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *tableView;
	NSArray *submittedOrders;
	NSArray *unsubmittedOrders;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
