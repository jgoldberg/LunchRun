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

#define TITLE_ROW 0

@implementation OrderSummaryViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
	expandedSectionIndex = nil;
	rowCount = [[NSMutableArray alloc] initWithCapacity:10];
	for (NSInteger i=0; i<10; i++) {
		[rowCount insertObject:[NSNumber numberWithInt:1] atIndex:i];
	}
	
	// Create Test Data
	// Run only once
	/*
	OwnerSummary *owner = [EntityFactory createOwnerSummary];
	owner.owner_id = @"1";
	owner.owner_name = @"Jason Goldberg";
	
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
	
	[order addItemsObject:orderItem];
	[order addItemsObject:orderItemTwo];
	[order addItemsObject:orderItemThree];
	
	NSManagedObjectContext *context = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"CoreData Error");
	}
	
	*/
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    return 10;
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	NSLog(@"Row Count");
	return [(NSNumber *)[rowCount objectAtIndex:section] intValue];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"OrderSummary";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell) {
		if ([indexPath row] == TITLE_ROW) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderItemSummaryTitleCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
		} else {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderItemSummaryCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
		}
	}
	
	if ([indexPath row] == TITLE_ROW) {
		OrderItemSummaryTitleCell *titleCell = (OrderItemSummaryTitleCell*)cell;
		titleCell.nameLabel.text = @"Two Meat Plate";
		titleCell.quantityLabel.text = @"2";
	} else {
		OrderItemSummaryCell *summaryCell = (OrderItemSummaryCell*)cell;
		summaryCell.userLabel.text = @"Jason Goldberg";
		summaryCell.quantityLabel.text = @"Qty: 1";
		summaryCell.options1Label.text = @"Brisket (Moist), Sausage, Extra Sauce";
		summaryCell.options2Label.text = @"Extra Sauce";
	}
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
		NSLog(@"0");
		[tableView beginUpdates];

		if (nil != expandedSectionIndex) {
			expandedSectionIndex = indexPath;
		}
		NSInteger rowsInSection = [[rowCount objectAtIndex:[expandedSectionIndex section]] intValue];
		if (1 != rowsInSection) {
			NSLog(@"A");
			NSMutableArray *indexesToDelete = [[NSMutableArray alloc] initWithCapacity:rowsInSection];
		    for (NSInteger i=1; i<rowsInSection; i++) {
				[indexesToDelete addObject:[NSIndexPath indexPathForRow:i inSection:[expandedSectionIndex section]]];
			}
			[rowCount replaceObjectAtIndex:[expandedSectionIndex section] withObject:[NSNumber numberWithInt:1]];
			[tableView deleteRowsAtIndexPaths:indexesToDelete withRowAnimation:UITableViewRowAnimationTop];
		}
		NSLog(@"B");
		if (1 == rowsInSection) {
			NSLog(@"C");
			NSMutableArray *indexesToAdd = [[NSMutableArray alloc] initWithCapacity:2];
			for (NSInteger i=1; i<=2; i++) {
				[indexesToAdd addObject:[NSIndexPath indexPathForRow:i inSection:[indexPath section]]];
			}
			[rowCount replaceObjectAtIndex:[indexPath section] withObject:[NSNumber numberWithInt:3]];
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
