//
//  OrderItem.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Order;
@class OrderItemOption;

@interface OrderItem :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * instructions;
@property (nonatomic, retain) Order * order;
@property (nonatomic, retain) NSSet* options;

@end


@interface OrderItem (CoreDataGeneratedAccessors)
- (void)addOptionsObject:(OrderItemOption *)value;
- (void)removeOptionsObject:(OrderItemOption *)value;
- (void)addOptions:(NSSet *)value;
- (void)removeOptions:(NSSet *)value;

@end


@interface OrderItem (JSON)
- (NSDictionary *) serialize;
- (void)unserialize:(NSDictionary *) dictionary;
@end