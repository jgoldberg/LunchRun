//
//  OrderItemSummary.h
//  LunchRun
//
//  Created by Jason Goldberg on 12/5/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>

@class OwnerSummary;

@interface OrderItemSummary :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) OwnerSummary * owner;

@end



