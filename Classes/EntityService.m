//
//  EntityService.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/21/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "EntityService.h"

#define SUBMITTED_SECTION @"Submitted Order"
#define UNSUBMITTED_SECTION @"No Submitted Order"

@implementation EntityService

+ (NSArray *) findAllScheduledRuns {
	NSManagedObjectContext *context = [[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription
											  entityForName:@"ScheduledRun" inManagedObjectContext:context];
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entityDescription];
		
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
										initWithKey:@"scheduledRunID" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	NSError *error;
	NSArray *array = [context executeFetchRequest:request error:&error];
	if (array == nil)
	{
		NSLog(@"Error Finding All Scheduled Runs");
	}
	[sortDescriptor release];
	[request release];
	return array;
}

+ (void) syncScheduledRuns:(NSArray *)remoteScheduledRuns {
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [delegate managedObjectContext];
	
	NSArray *localScheduledRuns = [EntityService findAllScheduledRuns];
	
	NSMutableArray *toBeDeleted = [[NSMutableArray alloc] init];
	NSMutableArray *toBeAdded = [[NSMutableArray alloc] init];
	
	// Sync logic
	int maxSize = [localScheduledRuns count] > [remoteScheduledRuns count] ? [localScheduledRuns count] : [remoteScheduledRuns count];
	int localIdx = 0;
	int remoteIdx = 0;
	while (localIdx <= maxSize && remoteIdx <= maxSize) {
		int remoteID = 0;
		int localID = 0;
		
		NSLog(@"Local Index: %d, Remote Index: %d", localIdx, remoteIdx);
		
		if (localIdx < [localScheduledRuns count]) {
			localID = [[[localScheduledRuns objectAtIndex:localIdx] scheduledRunID] intValue];
		}
		if (remoteIdx < [remoteScheduledRuns count]) {
			remoteID = [[[remoteScheduledRuns objectAtIndex:remoteIdx] objectForKey:@"scheduled_run_id"] intValue];
		}
		
		NSLog(@"Local ID: %d, Remote ID: %d", localID, remoteID);
		
		if (remoteID == 0 && localID != 0) {
			NSLog(@"Deleted");
			[toBeDeleted addObject:[localScheduledRuns objectAtIndex:localIdx]];
			localIdx++;
		} else if (remoteID != 0 && localID == 0) {
			NSLog(@"Added");
			[toBeAdded addObject:[remoteScheduledRuns objectAtIndex:remoteIdx]];
			remoteIdx++;
		} else if (remoteID < localID) {
			NSLog(@"Added");
			[toBeAdded addObject:[remoteScheduledRuns objectAtIndex:remoteIdx]];
			remoteIdx++;
		} else if (remoteID > localID) {
			NSLog(@"Deleted");
			[toBeDeleted addObject:[localScheduledRuns objectAtIndex:localIdx]];
			localIdx++;
		} else {
			NSLog(@"Match");
			localIdx++;
			remoteIdx++;
		}
		
	}
	
	for (ScheduledRun *item in toBeDeleted) {
		[context deleteObject:item];
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Error Saving");
		}
	}
	[toBeDeleted release];
	
	for (NSDictionary *item in toBeAdded) {
		NSLog(@"Adding Run: %@", item);
		ScheduledRun *newScheduledRun = [EntityFactory createScheduledRun];
		[newScheduledRun unserialize:item];
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Error Saving");
		}
	}
	[toBeAdded release];
}

+ (void) syncOrderItems:(NSDictionary *)params forScheduledRun:(ScheduledRun *)scheduledRun {
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [delegate managedObjectContext];
		
	// Create Order Item
	OrderItem *orderItem = [EntityFactory createOrderItem];
	[orderItem setQuantity:[params objectForKey:@"quantity"]];
	[orderItem setName:[params objectForKey:@"name"]];
	[orderItem setInstructions:[params objectForKey:@"instructions"]];
	[orderItem setOrder:[scheduledRun myOrder]];
	
	// Find Dynamic Options
	for (NSString *key in [params allKeys]) {
		if ([key hasSuffix:@"_key"]) {
			// Get Label
			NSString *label = [params objectForKey:key];
			// Get Value
			NSRange range = {0,[key length] - 4};
			NSString *valueKey = [NSString stringWithFormat:@"%@_value",[key substringWithRange:range]];
			NSString *value = [params objectForKey:valueKey];
			
			// Create Option
			OrderItemOption *newOption = [EntityFactory createOrderItemOption];
			newOption.optionKey = label;
			newOption.optionValue = value;
			[orderItem addOptionsObject:newOption];
		}
	}
	
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Error Saving");
	}
}

+ (void) removeAllSummaryObjects {
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [delegate managedObjectContext];

	//
	// Mark all summary objects for deletion
	//
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[NSEntityDescription entityForName:@"OrderSummary" inManagedObjectContext:context]];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order_summary_id" ascending:YES];
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	[request setPredicate:[NSPredicate predicateWithFormat:@"scheduled_run.scheduledRunID == %d",[[[delegate currentScheduledRun] scheduledRunID] intValue]]];
	
	NSError *error;
	NSArray *orderArray = [context executeFetchRequest:request error:&error];
	if (orderArray == nil)
	{
		NSLog(@"Error Finding All Scheduled Runs");
	}
	[sortDescriptor release];
	[request release];
	
	NSMutableSet *results = [NSMutableSet setWithArray:orderArray];
	for (NSInteger i = 0; i<[orderArray count]; i++) {
		OrderSummary *orderSummary = [orderArray objectAtIndex:i];
		for (OrderItemSummary *orderItem in [orderSummary items]) {
			[results addObject:orderItem];
			if (nil != [orderItem owner]) {
				[results addObject:[orderItem owner]];
			}
		}
	}

	//
	// Mark all remaining owner objects for deletion
	//
	NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
	[request2 setEntity:[NSEntityDescription entityForName:@"OwnerSummary" inManagedObjectContext:context]];
	
	NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"owner_id" ascending:YES];
	[request2 setSortDescriptors:[NSArray arrayWithObject:sortDescriptor2]];
	
	[request2 setPredicate:[NSPredicate predicateWithFormat:@"scheduled_run.scheduledRunID == %d",[[[delegate currentScheduledRun] scheduledRunID] intValue]]];
	
	NSArray *ownerArray = [context executeFetchRequest:request2 error:&error];
	if (ownerArray == nil)
	{
		NSLog(@"Error Finding All Scheduled Runs");
	}
	[sortDescriptor2 release];
	[request2 release];
	
	for (OwnerSummary *ownerSummary in ownerArray) {
		[results addObject:ownerSummary];
	}
	
	//
	// Finally, delete all objects
	//		
	for (NSManagedObject *object in results) {
		[context deleteObject:object]; 
	}
	
	if (![context save:&error]) {
		NSLog(@"Error Removing All Summary Objects");
	}
}

+ (NSInteger) syncOrderSummary:(NSDictionary *)params {
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [delegate managedObjectContext];
	
	[EntityService removeAllSummaryObjects];
	
	//
	// Owners
	//
	NSDictionary *ownersData = [params objectForKey:@"owners"];
	NSMutableDictionary *createdOwners = [[NSMutableDictionary alloc] initWithCapacity:[ownersData count]];
	for (NSString *key in ownersData) {
		NSDictionary *ownerData = [ownersData objectForKey:key];
		
		OwnerSummary *newOwner = [EntityFactory createOwnerSummary];
		BOOL hasOrders = [[ownerData objectForKey:@"has_orders"] boolValue];
		newOwner.owner_id = key;
		newOwner.owner_name = [ownerData objectForKey:@"owner_name"];
		newOwner.hasOrders = hasOrders ? SUBMITTED_SECTION : UNSUBMITTED_SECTION;
		newOwner.scheduled_run = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] currentScheduledRun];
		
		// Store since we will need to lookup in a bit...
		[createdOwners setObject:newOwner forKey:key];
	}
	
	//
	// Orders
	//
	NSDictionary *ordersData = [params objectForKey:@"orders"];
	NSMutableDictionary *createdOrders = [[NSMutableDictionary alloc] initWithCapacity:[ordersData count]];
	for (NSString *key in ordersData) {
		NSDictionary *orderData = [ordersData objectForKey:key];
		
		OrderSummary *newOrder = [EntityFactory createOrderSummary];
		newOrder.order_summary_id = [NSString stringWithFormat:@"%d",[[orderData objectForKey:@"index"] intValue]];
		newOrder.name = key;
		newOrder.total_quantity = [NSString stringWithFormat:@"%1.2f",[[orderData objectForKey:@"total_quantity"] floatValue]];
		newOrder.scheduled_run = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] currentScheduledRun];
		
		// Store since we will need to lookup in a bit...
		[createdOrders setObject:newOrder forKey:key];
	}
	
	//
	// Order Items
	//
	NSArray *itemsArray = [params objectForKey:@"items"];
	for (NSDictionary *itemData in itemsArray) {
		OwnerSummary *owner = [createdOwners objectForKey:[NSString stringWithFormat:@"%d",[[itemData objectForKey:@"owner_id"] intValue]]];
		OrderSummary *order = [createdOrders objectForKey:[itemData objectForKey:@"name"]]; // Lookup by name since order is merged by name
		
		OrderItemSummary *orderItem = [EntityFactory createOrderItemSummary];
		orderItem.name = [itemData objectForKey:@"name"];
		orderItem.notes = [itemData objectForKey:@"notes"];
		orderItem.instructions = [itemData objectForKey:@"instructions"];
		orderItem.quantity = [NSString stringWithFormat:@"%1.2f",[[itemData objectForKey:@"quantity"] floatValue]];
		orderItem.owner = owner;
		[owner addItemsObject:orderItem];
		[order addItemsObject:orderItem];
	}
	
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Error saving order summary");
	}
	[delegate setSummaryDataLoaded:TRUE];
	return [createdOrders count];
}

@end
