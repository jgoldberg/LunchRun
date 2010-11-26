// 
//  OrderItem.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "OrderItem.h"

#import "Order.h"
#import "OrderItemOption.h"

@implementation OrderItem 

@dynamic quantity;
@dynamic name;
@dynamic instructions;
@dynamic order;
@dynamic options;

- (NSDictionary *) serialize {
	return nil;
}

- (void)unserialize:(NSDictionary *) dictionary {
	self.name = [dictionary objectForKey:@"name"];
	self.quantity = [dictionary objectForKey:@"quantity"];
	self.instructions = [dictionary objectForKey:@"instructions"];
}

@end
