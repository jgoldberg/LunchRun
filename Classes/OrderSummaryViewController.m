//
//  ScheduledRunSummaryViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "OrderSummaryViewController.h"
#import "OrderItemSummaryTitleCell.h"
#import "OrderItemSummaryCell.h"
#import "OrderSummary.h"
#import "OwnerSummary.h"
#import "OrderItemSummary.h"
#import "EntityFactory.h"
#import "LunchRunAppDelegate.h"
#import "NSArray+Set.h"
#import "LRJSONRequest.h"
#import "EntityService.h"

#define TITLE_ROW 0

@implementation OrderSummaryViewController

@synthesize tableView;
@synthesize fetchedResultsController=_fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];

	LunchRunAppDelegate *delegate = (LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	// Create Test Data
	// Run only once
	/*
	OwnerSummary *owner = [EntityFactory createOwnerSummary];
	owner.owner_id = @"3";
	owner.owner_name = @"Ian Goldberg";
	owner.scheduled_run = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] currentScheduledRun];
	
	OwnerSummary *ownerOne = [EntityFactory createOwnerSummary];
	ownerOne.owner_id = @"3";
	ownerOne.owner_name = @"Jason Goldberg";
	ownerOne.scheduled_run = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] currentScheduledRun];
	
	OrderSummary *order = [EntityFactory createOrderSummary];
	order.order_summary_id = @"1";
	order.name = @"Two Meat Plate";
	order.total_quantity = @"3";
	order.scheduled_run = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] currentScheduledRun];
	
	OrderItemSummary *orderItem = [EntityFactory createOrderItemSummary];
	orderItem.name = @"Two Meat Plate";
	orderItem.notes = @"Brisket, Sausage";
	orderItem.quantity = @"1";
	orderItem.owner = owner;
	
	OrderItemSummary *orderItemTwo = [EntityFactory createOrderItemSummary];
	orderItemTwo.name = @"Two Meat Plate";
	orderItemTwo.notes = @"Ribs, Sausage";
	orderItemTwo.quantity = @"1";
	orderItemTwo.owner = owner;
	
	OrderItemSummary *orderItemThree = [EntityFactory createOrderItemSummary];
	orderItemThree.name = @"Two Meat Plate";
	orderItemThree.notes = @"Pulled Pork, Ribs";
	orderItemThree.quantity = @"1";
	orderItemThree.owner = owner;
	
	[owner addItemsObject:orderItem];
	[owner addItemsObject:orderItemTwo];
	[owner addItemsObject:orderItemThree];

	[owner fillHasOrders];
	[ownerOne fillHasOrders];
	
	[order addItemsObject:orderItem];
	[order addItemsObject:orderItemTwo];
	[order addItemsObject:orderItemThree];
	
	NSManagedObjectContext *context = [delegate managedObjectContext];
	NSError *err;
	if (![context save:&err]) {
		NSLog(@"CoreData Error");
	}
	*/
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@: %@", error, [error userInfo]);
		exit(-1);
	}

	NSInteger sectionCount = [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
	NSLog(@"Section Count: %d", sectionCount);
	
	expandedSectionIndex = nil;
	rowCount = [[NSMutableArray alloc] initWithCapacity:sectionCount];
	for (NSInteger i=0; i<sectionCount; i++) {
		[rowCount insertObject:[NSNumber numberWithInt:1] atIndex:i];
	}
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *paramString = [NSString stringWithFormat:@"scheduled_run_id=%@",[[delegate currentScheduledRun] scheduledRunID]];
	LRJSONRequest *request = [[LRJSONRequest alloc] initWithURL:@"/services/orders/summarize"
													 groupToken:[defaults objectForKey:@"group_token"]
													  userToken:[defaults objectForKey:@"user_token"]
													   delegate:self 
													  onSuccess:@selector(summaryDataSuccess:)
													  onFailure:@selector(summaryDataFailure:)];
	[request performGet:paramString];
}

- (void) summaryDataSuccess:(NSDictionary*)response {
	NSLog(@"Success");
	NSInteger sectionCount = [EntityService syncOrderSummary:response];
	[rowCount release];
	rowCount = [[NSMutableArray alloc] initWithCapacity:sectionCount];
	for (NSInteger i=0; i<sectionCount; i++) {
		[rowCount insertObject:[NSNumber numberWithInt:1] atIndex:i];
	}
	[tableView reloadData];
}

- (void) summaryDataFailure:(NSError*)error {
	NSLog(@"Failure");	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    // Yes, we're abusing fetchedResultsController to do the accordian style tableview
	return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	NSLog(@"Row Count");
	return [(NSNumber *)[rowCount objectAtIndex:section] intValue];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"OrderSummary";
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell) {
		if ([indexPath row] == TITLE_ROW) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderItemSummaryTitleCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
		} else {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderItemSummaryCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
		}
	}
	
	OrderSummary *orderSummary = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[indexPath section] inSection:0]];
	if ([indexPath row] == TITLE_ROW) {		
		OrderItemSummaryTitleCell *titleCell = (OrderItemSummaryTitleCell*)cell;
		titleCell.nameLabel.text = [orderSummary name];
		titleCell.quantityLabel.text = [orderSummary total_quantity];
	} else {
		OrderItemSummary *orderItemSummary = [[NSArray arrayByOrderingSet:orderSummary.items byKey:@"notes" ascending:YES] objectAtIndex:([indexPath row] - 1)];
		NSLog(@"Quantity: %@, Owner: %@", [orderItemSummary quantity], [orderItemSummary.owner valueForKey:@"hasOrders"]);
		OrderItemSummaryCell *summaryCell = (OrderItemSummaryCell*)cell;
		summaryCell.userLabel.text = [orderItemSummary.owner owner_name];
		summaryCell.quantityLabel.text = [NSString stringWithFormat:@"Qty: %@",[orderItemSummary quantity]];
		summaryCell.options1Label.text = [orderItemSummary notes];
		summaryCell.options2Label.text = @"Extra Sauce"; // TODO
	}
	
	return cell;
}

- (void) tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Select %d", [indexPath row]);
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if ([indexPath row] != TITLE_ROW) {
		if ([cell accessoryType] != UITableViewCellAccessoryCheckmark) {
			[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
		} else {
			[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
	}
	else {
		// Lot's of complex logic for the accordian view
		[tableView beginUpdates];

		if (nil != expandedSectionIndex) {
			expandedSectionIndex = indexPath;
		}
		NSInteger rowsInSection = [[rowCount objectAtIndex:[expandedSectionIndex section]] intValue];
		if (1 != rowsInSection) {
			NSMutableArray *indexesToDelete = [[NSMutableArray alloc] initWithCapacity:rowsInSection];
		    for (NSInteger i=1; i<rowsInSection; i++) {
				[indexesToDelete addObject:[NSIndexPath indexPathForRow:i inSection:[expandedSectionIndex section]]];
			}
			[rowCount replaceObjectAtIndex:[expandedSectionIndex section] withObject:[NSNumber numberWithInt:1]];
			[tableView deleteRowsAtIndexPaths:indexesToDelete withRowAnimation:UITableViewRowAnimationTop];
		}
		if (1 == rowsInSection) {
			// Lookup row count from row object, not section
			OrderSummary *orderSummary = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:[indexPath section] inSection:0]];
			NSInteger addRowCount = [orderSummary.items count] + 1;
			NSLog(@"addRowCount: %d", addRowCount);
			NSMutableArray *indexesToAdd = [[NSMutableArray alloc] initWithCapacity:2];
			for (NSInteger i=1; i<addRowCount; i++) {
				[indexesToAdd addObject:[NSIndexPath indexPathForRow:i inSection:[indexPath section]]];
			}
			[rowCount replaceObjectAtIndex:[indexPath section] withObject:[NSNumber numberWithInt:addRowCount]];
			[tableView insertRowsAtIndexPaths:indexesToAdd withRowAnimation:UITableViewRowAnimationTop];
		}
		expandedSectionIndex = [NSIndexPath indexPathForRow:[indexPath row] inSection:[indexPath section]];
		[tableView endUpdates];
	}
	[cell setSelected:NO animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] == TITLE_ROW) {
		return 46;
	} else {
		return 64;
	}
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController != nil)
		return _fetchedResultsController;
	
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [delegate managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"OrderSummary" inManagedObjectContext:context];
	[fetchRequest setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order_summary_id" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"scheduled_run.scheduledRunID == %d",[[[delegate currentScheduledRun] scheduledRunID] intValue]];
	[fetchRequest setPredicate:predicate];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																				 managedObjectContext:context 
																				   sectionNameKeyPath:nil 
																							cacheName:nil/*@"Root"*/];
	[controller setDelegate:self];
	_fetchedResultsController = controller;
	
	return _fetchedResultsController;	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end
