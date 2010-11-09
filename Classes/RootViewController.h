//
//  RootViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/26/10.
//  Copyright N/A 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RootViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *_fetchedResultsController;
	IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
