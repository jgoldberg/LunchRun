// 
//  ScheduledRun.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "ScheduledRun.h"

#import "Order.h"

@implementation ScheduledRun 

@dynamic scheduledRunID;
@dynamic isOpen;
@dynamic cutoffDate;
@dynamic destination;
@dynamic ownerName;
@dynamic myOrder;

- (NSDictionary *) serialize {
	return nil;
}

- (void)unserialize:(NSDictionary *) dictionary {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MM/dd/y HH:mm"];
	
	self.scheduledRunID = [dictionary objectForKey:@"scheduled_run_id"];
	self.isOpen = [dictionary objectForKey:@"is_open"];
	self.cutoffDate = [dateFormat dateFromString:[dictionary objectForKey:@"cutoff_datetime"]];
	self.destination = [dictionary objectForKey:@"destination"];
	self.ownerName = [dictionary objectForKey:@"owner"];
	
	Order *order = [EntityFactory createOrder];
	[order unserialize:[dictionary objectForKey:@"my_order"]];
	[order setScheduledRun:self];
	self.myOrder = order;
	
	[dateFormat release];
}

@end
