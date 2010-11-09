//
//  ScheduledRun.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/8/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Order;

@interface ScheduledRun :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * scheduledRunID;
@property (nonatomic, retain) NSNumber * isOpen;
@property (nonatomic, retain) NSString * ownerName;
@property (nonatomic, retain) NSDate * cutoffDate;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSSet* orders;

@end


@interface ScheduledRun (CoreDataGeneratedAccessors)
- (void)addOrdersObject:(Order *)value;
- (void)removeOrdersObject:(Order *)value;
- (void)addOrders:(NSSet *)value;
- (void)removeOrders:(NSSet *)value;

@end

