//
//  OrderItemSummary.h
//  LunchRun
//
//  Created by Jason Goldberg on 12/5/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>

@class OrderItemSummary;
@class ScheduledRun;

@interface OrderItemSummary :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * total_quantity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * order_summary_id;
@property (nonatomic, retain) NSSet* items;
@property (nonatomic, retain) ScheduledRun * scheduled_run;

@end


@interface OrderItemSummary (CoreDataGeneratedAccessors)
- (void)addItemsObject:(OrderItemSummary *)value;
- (void)removeItemsObject:(OrderItemSummary *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;

@end

