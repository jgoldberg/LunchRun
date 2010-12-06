//
//  MyGroupTableViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MyGroupTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
	IBOutlet UITableView *tableView;
	NSArray *submittedOrders;
	NSArray *unsubmittedOrders;
	
	NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
