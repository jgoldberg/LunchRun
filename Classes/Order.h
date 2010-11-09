//
//  Order.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/8/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>

@class OrderItem;
@class ScheduledRun;

@interface Order :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) ScheduledRun * scheduledRun;
@property (nonatomic, retain) NSSet* orderItems;

@end


@interface Order (CoreDataGeneratedAccessors)
- (void)addOrderItemsObject:(OrderItem *)value;
- (void)removeOrderItemsObject:(OrderItem *)value;
- (void)addOrderItems:(NSSet *)value;
- (void)removeOrderItems:(NSSet *)value;

@end

