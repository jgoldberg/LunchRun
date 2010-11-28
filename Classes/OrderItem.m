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
#import "EntityFactory.h"

@implementation OrderItem 

@dynamic quantity;
@dynamic name;
@dynamic instructions;
@dynamic order;
@dynamic options;

- (NSDictionary *) serialize {
	NSMutableArray *optionsArray = [[NSMutableArray alloc] initWithCapacity:[self.options count]];
	int counter = 0;
	for (OrderItemOption *option in self.options) {
		[optionsArray insertObject:[option serialize] atIndex:counter++];
	}
	return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.name, self.quantity, self.instructions, optionsArray, nil] 
									   forKeys:[NSArray arrayWithObjects:@"name", @"quantity", @"instructions", @"item_options", nil]];
}

- (void)unserialize:(NSDictionary *) dictionary {
	self.name = [dictionary objectForKey:@"name"];
	self.quantity = [dictionary objectForKey:@"quantity"];
	self.instructions = [dictionary objectForKey:@"instructions"];
	
	NSArray *optionSetData = [dictionary objectForKey:@"item_options"];
	for (NSDictionary *optionData in optionSetData) {
		OrderItemOption	*option = [EntityFactory createOrderItemOption];
		[option unserialize:optionData];
		[self addOptionsObject:option];
	}
}

@end
