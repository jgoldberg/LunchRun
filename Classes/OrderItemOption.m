// 
//  OrderItemOption.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "OrderItemOption.h"


@implementation OrderItemOption 

@dynamic optionKey;
@dynamic optionValue;

- (NSDictionary *) serialize {
	return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.optionKey,self.optionValue,nil] 
									   forKeys:[NSArray arrayWithObjects:@"option_key", @"option_value", nil]];
}

- (void)unserialize:(NSDictionary *) dictionary {
	self.optionKey = [dictionary objectForKey:@"option_key"];
	self.optionValue = [dictionary objectForKey:@"option_value"];
}

@end