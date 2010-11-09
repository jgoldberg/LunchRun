//
//  OrderItem.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/8/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Order;

@interface OrderItem :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * item;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) Order * order;

@end



