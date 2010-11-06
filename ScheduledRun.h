//
//  ScheduledRun.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/6/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface ScheduledRun :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * scheduledRunId;
@property (nonatomic, retain) NSSet* orders;

@end


@interface ScheduledRun (CoreDataGeneratedAccessors)
- (void)addOrdersObject:(NSManagedObject *)value;
- (void)removeOrdersObject:(NSManagedObject *)value;
- (void)addOrders:(NSSet *)value;
- (void)removeOrders:(NSSet *)value;

@end

