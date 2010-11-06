//
//  Order.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/6/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ScheduledRun;

@interface Order :  NSManagedObject  
{
}

@property (nonatomic, retain) ScheduledRun * scheduledRun;
@property (nonatomic, retain) NSSet* orderItems;

@end


@interface Order (CoreDataGeneratedAccessors)
- (void)addOrderItemsObject:(NSManagedObject *)value;
- (void)removeOrderItemsObject:(NSManagedObject *)value;
- (void)addOrderItems:(NSSet *)value;
- (void)removeOrderItems:(NSSet *)value;

@end

