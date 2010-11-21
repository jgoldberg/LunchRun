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
@synthesize hud;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@: %@", error, [error userInfo]);
		exit(-1);
	}
	
	hud = [[LRProgressHUD alloc] initWithLabel:@"Loading"];
	[hud show];
	
	LRJSONRequest *request = [[LRJSONRequest alloc] initWithURL:@"/services/scheduledruns/list" 
																	delegate:self 
																   onSuccess:@selector(onFetchScheduledRunsSuccess:) 
																   onFailure:@selector(onFetchScheduledRunsFailure:)];
	[request performGet];
}

- (void) onFetchScheduledRunsSuccess:(NSMutableArray *) response {
	NSLog(@"Success: %@", response);
	[EntityService syncScheduledRuns:response];
	[hud dismiss];
	
}

- (void) onFetchScheduledRunsFailure: (NSError *) error {
	NSLog(@"Failure");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LunchRun" 
													message:@"Sorry!  Could not connect to remote host." 
												   delegate:nil
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)navigationController:(UINavigationController *)_navigationController willShowViewController:(UIViewController *)_viewController animated:(BOOL)animated {
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(onShowSettings:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	
	UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	[fixed setWidth:280.0];
	
	NSArray *tabBarItems = [NSArray arrayWithObjects:fixed,infoItem,nil];
	[self setToolbarItems:tabBarItems];
}

- (void) onShowSettings: (id)sender {
	
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

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 66;
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ScheduledRun *scheduledRun = [self.fetchedResultsController objectAtIndexPath:indexPath];
	ScheduledRunViewController *scheduledRunViewController = [[ScheduledRunViewController alloc] initWithNibName:@"ScheduledRunView" bundle:nil];
    scheduledRunViewController.scheduledRun = scheduledRun;
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

