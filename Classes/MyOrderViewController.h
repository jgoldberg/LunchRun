//
//  MyOrderViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/27/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ScheduledRun.h"

@interface MyOrderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>{
	ScheduledRun *scheduledRun;
	NSFetchedResultsController *_fetchedResultsController;
	IBOutlet UITableView *tableView;
}

- (IBAction) addOrderItem: (id) sender;

@property (nonatomic, retain) ScheduledRun *scheduledRun;
@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
