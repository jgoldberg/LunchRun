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

+ (void) syncOrderItems:(NSDictionary *)params {
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [delegate managedObjectContext];
	
	OrderItem *orderItem = [EntityFactory createOrderItem];
	[orderItem setQuantity:[params objectForKey:@"quantity"]];
	[orderItem setItem:[params objectForKey:@"name"]];
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Error Saving");
	}
}

@end
