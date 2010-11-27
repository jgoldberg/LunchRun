//
//  EntityFactory.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/21/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduledRun.h"
#import "Order.h"
#import "OrderItem.h"
#import "OrderItemOption.h"

@interface EntityFactory : NSObject {
	
}

+ (ScheduledRun *) createScheduledRun;
+ (Order *) createOrder;
+ (OrderItem *) createOrderItem;
+ (OrderItemOption *) createOrderItemOption;

@end
