//
//  Order.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>

@class OrderItem;
@class ScheduledRun;

@interface Order :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * myOrder;
@property (nonatomic, retain) ScheduledRun * scheduledRun;
@property (nonatomic, retain) NSSet* orderItems;
@property (nonatomic, retain) NSString * orderStatus;

@end


@interface Order (CoreDataGeneratedAccessors)
- (void)addOrderItemsObject:(OrderItem *)value;
- (void)removeOrderItemsObject:(OrderItem *)value;
- (void)addOrderItems:(NSSet *)value;
- (void)removeOrderItems:(NSSet *)value;

@end


@interface Order (JSON)
- (NSDictionary *) serialize;
- (void)unserialize:(NSDictionary *) dictionary;
@end
