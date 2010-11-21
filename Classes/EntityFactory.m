//
//  EntityFactory.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/21/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "EntityFactory.h"

@implementation EntityFactory

+ (ScheduledRun *)createScheduledRun {
	NSManagedObjectContext *context = [[[UIApplication sharedApplication] delegate] managedObjectContext];
	ScheduledRun *newScheduledRun = [[NSEntityDescription
							   insertNewObjectForEntityForName:@"ScheduledRun" 
							   inManagedObjectContext:context] autorelease];
	return newScheduledRun;
}

+ (Order *)createOrder {
	return nil;	
}

+ (OrderItem *)createOrderItem {
	return nil;
}

@end
