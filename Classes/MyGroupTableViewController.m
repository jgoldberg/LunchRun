//
//  MyGroupTableViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "MyGroupTableViewController.h"
#import "LunchRunAppDelegate.h"

#define SUBMITTED_SECTION @"Submitted Order"
#define UNSUBMITTED_SECTION @"No Submitted Order"

@implementation MyGroupTableViewController

@synthesize tableView;
@synthesize fetchedResultsController=_fetchedResultsController;

- (void)viewDidLoad {
	submittedOrders = [[NSArray arrayWithObjects:@"Jason Goldberg", @"Alex Goldberg", nil] retain];
	unsubmittedOrders = [[NSArray arrayWithObjects:@"Diana Goldberg", @"Brad Goldberg", nil] retain];
    [super viewDidLoad];
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@: %@", error, [error userInfo]);
		exit(-1);
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo	name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"GroupCell Section: %d Row: %d", [indexPath section], [indexPath row]);
	static NSString *CellIdentifier = @"GroupCell";
	
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:[indexPath section]];
	OwnerSummary *owner = [self.fetchedResultsController objectAtIndexPath:indexPath];
	if ([[sectionInfo name] isEqualToString:SUBMITTED_SECTION] ) {
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		cell.textLabel.text = [owner owner_name];
		return cell;
	} else if ([[sectionInfo name] isEqualToString:UNSUBMITTED_SECTION]) {
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.textLabel.text = [owner owner_name];
		return cell;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:[indexPath section]];
	if ([[sectionInfo name] isEqualToString:SUBMITTED_SECTION] ) {
		
	}
	[[self.tableView cellForRowAtIndexPath:indexPath] setSelected:FALSE];
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController != nil)
		return _fetchedResultsController;
	
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [delegate managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"OwnerSummary" inManagedObjectContext:context];
	[fetchRequest setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hasOrders" ascending:NO];
	NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"owner_name" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor,sortDescriptor2,nil]];
	
	// TODO
	//NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduled_run.scheduledRunID == %d",[[[delegate currentScheduledRun] scheduledRunID] intValue]];
	//[fetchRequest setPredicate:predicate];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																				 managedObjectContext:context 
																				   sectionNameKeyPath:@"hasOrders" 
																							cacheName:nil/*@"Root"*/];
	[controller setDelegate:self];
	_fetchedResultsController = controller;
	
	return _fetchedResultsController;	
}

- (void)dealloc {
    [super dealloc];
}


@end
