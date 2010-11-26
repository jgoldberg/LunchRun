//
//  ScheduledRun.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EntityFactory.h"

@class Order;

@interface ScheduledRun :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * scheduledRunID;
@property (nonatomic, retain) NSNumber * isOpen;
@property (nonatomic, retain) NSDate * cutoffDate;
@property (nonatomic, retain) NSString * destination;
@property (nonatomic, retain) NSString * ownerName;
@property (nonatomic, retain) Order * myOrder;

@end

@interface ScheduledRun (JSON)
- (NSDictionary *) serialize;
- (void)unserialize:(NSDictionary *) dictionary;
@end