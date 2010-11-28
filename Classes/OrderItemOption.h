//
//  OrderItemOption.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface OrderItemOption :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString* optionKey;
@property (nonatomic, retain) NSString* optionValue;

@end


@interface OrderItemOption (JSON)
- (NSDictionary *) serialize;
- (void)unserialize:(NSDictionary *) dictionary;
@end
