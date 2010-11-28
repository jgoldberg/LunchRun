//
//  RootViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/26/10.
//  Copyright N/A 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ScheduledRunCell.h"
#import "LRTimeRemaining.h"
#import "ScheduledRunViewController.h"
#import "LunchRunAppDelegate.h"
#import "LRJSONRequest.h"
#import "EntityFactory.h"
#import "EntityService.h"
#import "LRProgressHUD.h"
#import "SettingsViewController.h"
#import "AddScheduledRunViewController.h"
#import "ScheduledRunTabBarViewController.h"

@interface RootViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UINavigationControllerDelegate> {
	NSFetchedResultsController *_fetchedResultsController;
	IBOutlet UITableView *tableView;
	LRProgressHUD *hud;
}

- (void) reloadRemoteData;
- (IBAction) addScheduledRun:(id)sender;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
