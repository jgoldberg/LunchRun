//
//  EntityService.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/21/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "EntityService.h"


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
			[results addObject:[orderItem owner]];
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

+ (void) syncOrderSummary:(NSDictionary *)params {
	[EntityService removeAllSummaryObjects];
}

@end
