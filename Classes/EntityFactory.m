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
	ScheduledRun *newScheduledRun = [NSEntityDescription
							   insertNewObjectForEntityForName:@"ScheduledRun" 
							   inManagedObjectContext:context];
	return newScheduledRun;
}

+ (Order *)createOrder {
	NSManagedObjectContext *context = [[[UIApplication sharedApplication] delegate] managedObjectContext];
	ScheduledRun *newOrder = [NSEntityDescription
									 insertNewObjectForEntityForName:@"Order" 
									 inManagedObjectContext:context];
	return newOrder;
}

+ (OrderItem *)createOrderItem {
	NSManagedObjectContext *context = [[[UIApplication sharedApplication] delegate] managedObjectContext];
	OrderItem *newOrderItem = [NSEntityDescription
									 insertNewObjectForEntityForName:@"OrderItem" 
									 inManagedObjectContext:context];
	return newOrderItem;
}

@end
