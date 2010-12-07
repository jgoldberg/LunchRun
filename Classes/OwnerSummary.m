// 
//  OwnerSummary.m
//  LunchRun
//
//  Created by Jason Goldberg on 12/5/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "OwnerSummary.h"
#import "OrderItemSummary.h"

#define SUBMITTED_SECTION @"Submitted Order"
#define UNSUBMITTED_SECTION @"No Submitted Order"

@implementation OwnerSummary 

@dynamic owner_id;
@dynamic owner_name;
@dynamic items;
@dynamic hasOrders;
@dynamic scheduled_run;

- (void) fillHasOrders {
	NSLog(@"setHasOrders count: %d", [self.items count]);
	self.hasOrders = [self.items count] != 0 ? SUBMITTED_SECTION : UNSUBMITTED_SECTION;
}

@end