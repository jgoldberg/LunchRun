//
//  EntityFactory.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/21/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "EntityFactory.h"
#import "LunchRunAppDelegate.h"

@implementation EntityFactory

+ (ScheduledRun *)createScheduledRun {
	NSManagedObjectContext *context = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	ScheduledRun *newScheduledRun = [NSEntityDescription
							   insertNewObjectForEntityForName:@"ScheduledRun" 
							   inManagedObjectContext:context];
	return newScheduledRun;
}

+ (Order *)createOrder {
	NSManagedObjectContext *context = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	Order *newOrder = [NSEntityDescription
									 insertNewObjectForEntityForName:@"Order" 
									 inManagedObjectContext:context];
	return newOrder;
}

+ (OrderItem *)createOrderItem {
	NSManagedObjectContext *context = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	OrderItem *newOrderItem = [NSEntityDescription
									 insertNewObjectForEntityForName:@"OrderItem" 
									 inManagedObjectContext:context];
	return newOrderItem;
}

+ (OrderItemOption *) createOrderItemOption {
	NSManagedObjectContext *context = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
	OrderItemOption *newOrderItemOption = [NSEntityDescription
							   insertNewObjectForEntityForName:@"OrderItemOption" 
							   inManagedObjectContext:context];
	return newOrderItemOption;
}

+ (OrderSummary *) createOrderSummary {
	NSManagedObjectContext *context = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] summaryManagedObjectContext];
	OrderSummary *newOrderSummary = [NSEntityDescription
										   insertNewObjectForEntityForName:@"OrderSummary" 
										   inManagedObjectContext:context];
	return newOrderSummary;
}

+ (OrderItemSummary *) createOrderItemSummary {
	NSManagedObjectContext *context = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] summaryManagedObjectContext];
	OrderItemSummary *newOrderItemSummary = [NSEntityDescription
										   insertNewObjectForEntityForName:@"OrderItemSummary" 
										   inManagedObjectContext:context];
	return newOrderItemSummary;
}

+ (OwnerSummary *) createOwnerSummary {
	NSManagedObjectContext *context = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] summaryManagedObjectContext];
	OwnerSummary *newOwnerSummary = [NSEntityDescription
										   insertNewObjectForEntityForName:@"OwnerSummary" 
										   inManagedObjectContext:context];
	return newOwnerSummary;
}

@end
