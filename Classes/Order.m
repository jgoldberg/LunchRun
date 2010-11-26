// 
//  Order.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "Order.h"

#import "OrderItem.h"
#import "ScheduledRun.h"

@implementation Order 

@dynamic userName;
@dynamic myOrder;
@dynamic scheduledRun;
@dynamic orderItems;

- (NSDictionary *) serialize {
	return nil;
}

- (void)unserialize:(NSDictionary *) dictionary {
	NSArray *orderItemSetData = [dictionary objectForKey:@"order_items"];
	for (NSDictionary *orderItemData in orderItemSetData) {
		OrderItem *orderItem = [EntityFactory createOrderItem];
		[orderItem unserialize:orderItemData];
		[orderItem setOrder:self];
		[self addOrderItemsObject:orderItem];
	}
}

@end
