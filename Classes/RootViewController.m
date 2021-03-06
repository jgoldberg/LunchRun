//
//  RootViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 10/26/10.
//  Copyright N/A 2010. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

@synthesize fetchedResultsController=_fetchedResultsController;
@synthesize tableView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSLog(@"Device: %@", [[UIDevice currentDevice] uniqueIdentifier]);
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@: %@", error, [error userInfo]);
		exit(-1);
	}
	
	tableView.rowHeight = 66;
	
	[self reloadRemoteData];
}

- (void) reloadRemoteData {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"group_token"] == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to LunchRun!" 
														message:@"In order to participate, you must be a member of a group.  Use the info button on the bottom right to create or join a group." 
													   delegate:nil 
											  cancelButtonTitle:@"Continue" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	} else {
		hud = [[LRProgressHUD alloc] initWithLabel:@"Loading"];
		[hud show];
		
		LRJSONRequest *request = [[LRJSONRequest alloc] initWithURL:@"/services/scheduledruns/list"
														 groupToken:[defaults objectForKey:@"group_token"]
														  userToken:[defaults objectForKey:@"user_token"]
														   delegate:self 
														  onSuccess:@selector(onFetchScheduledRunsSuccess:) 
														  onFailure:@selector(onFetchScheduledRunsFailure:)];
		[request performGet];
		[request release];
	}
}

- (void) onFetchScheduledRunsSuccess:(NSMutableArray *) response {
	NSLog(@"Success: %@", response);
	[EntityService syncScheduledRuns:response];
	[hud dismiss];
	
}

- (void) onFetchScheduledRunsFailure: (NSError *) error {
	NSLog(@"Failure");
	[hud dismiss];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LunchRun" 
													message:@"Sorry!  Could not connect to remote host." 
												   delegate:nil
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)navigationController:(UINavigationController *)_navigationController willShowViewController:(UIViewController *)_viewController animated:(BOOL)animated {
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadRemoteData)];
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(onShowSettings:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	
	UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[fixed setWidth:250.0];
	
	NSArray *tabBarItems = [NSArray arrayWithObjects:refreshButton,fixed,infoItem,nil];
	[self setToolbarItems:tabBarItems];
	
	[_navigationController setToolbarHidden:FALSE animated:TRUE];
}

- (void) onShowSettings: (id)sender {
	SettingsViewController *controller = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
	controller.parentController = self;
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];	
}

- (IBAction) addScheduledRun:(id)sender {
	AddScheduledRunViewController *controller = [[AddScheduledRunViewController alloc] initWithNibName:@"AddScheduledRunView" bundle:nil];
	controller.delegate = self;
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	[controller release];
}

- (void) didCreateWithModal {
	[self reloadRemoteData];
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController != nil)
		return _fetchedResultsController;
	
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [delegate managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ScheduledRun" inManagedObjectContext:context];
	[fetchRequest setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cutoffDate" ascending:NO];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																				 managedObjectContext:context 
																				   sectionNameKeyPath:nil 
																							cacheName:nil/*@"Root"*/];
	[controller setDelegate:self];
	_fetchedResultsController = controller;
	
	return _fetchedResultsController;	
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//NSLog("count %@", [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects]);
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ScheduledRun";
    
    ScheduledRunCell *cell = (ScheduledRunCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ScheduledRunCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
    }
    
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setTimeStyle:NSDateFormatterMediumStyle];
	[dateFormat setDateStyle:NSDateFormatterMediumStyle];
	
	// Configure the cell.
	ScheduledRun *scheduledRun = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.destinationLabel.text = [scheduledRun destination];
	cell.cutoffDateLabel.text =  [dateFormat stringFromDate:[scheduledRun cutoffDate]];
	cell.userLabel.text = [scheduledRun	ownerName];
	
	NSDate *cutoffDate = [scheduledRun cutoffDate];
	if (cutoffDate == [cutoffDate earlierDate:[NSDate date]]) {
		cell.timeRemainingLabel.text = @"Expired";
	} else {
		cell.timeRemainingLabel.text = [[scheduledRun isOpen] boolValue] ? [LRTimeRemaining stringFromTimeRemaining:[scheduledRun cutoffDate]] : @"Closed";
	}
	
	[dateFormat release];
	
    return cell;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
			//OrderItem *orderItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
			//UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
			//cell.textLabel.text = [NSString stringWithFormat:@"Item %@", [orderItem item]];
            break;
			
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	NSLog(@"Data Changed!");
	[self.tableView endUpdates];
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ScheduledRun *scheduledRun = [self.fetchedResultsController objectAtIndexPath:indexPath];
	[(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] setCurrentScheduledRun:scheduledRun];
	ScheduledRunTabBarViewController *scheduledRunViewController = [[ScheduledRunTabBarViewController alloc] initWithNibName:@"ScheduledRunTabBarView" bundle:nil];
	[(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] setScheduledRunTabBarViewController:scheduledRunViewController];
	[self.navigationController setToolbarHidden:TRUE];
	[self.navigationController pushViewController:scheduledRunViewController animated:YES];
	[scheduledRunViewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

