//
//  OwnerSummary.h
//  LunchRun
//
//  Created by Jason Goldberg on 12/5/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>

@class OrderItemSummary;

@interface OwnerSummary :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * owner_id;
@property (nonatomic, retain) NSString * owner_name;
@property (nonatomic, retain) OrderItemSummary * items;

@end



