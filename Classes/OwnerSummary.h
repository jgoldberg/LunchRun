//
//  OwnerSummary.h
//  LunchRun
//
//  Created by Jason Goldberg on 12/5/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>

@class OrderItemSummary;
@class ScheduledRun;

@interface OwnerSummary :  NSManagedObject  
{
}

- (void) fillHasOrders;

@property (nonatomic, retain) NSString * owner_id;
@property (nonatomic, retain) NSString * owner_name;
@property (nonatomic, retain) NSString * hasOrders;
@property (nonatomic, retain) NSSet * items;
@property (nonatomic, retain) ScheduledRun * scheduled_run;

@end

@interface OwnerSummary (CoreDataGeneratedAccessors)
- (void)addItemsObject:(OrderItemSummary *)value;
- (void)removeItemsObject:(OrderItemSummary *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end