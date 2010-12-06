//
//  NSArray+Set.m
//  LunchRun
//
//  Created by Jason Goldberg on 12/6/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "NSArray+Set.h"


@implementation NSArray(Set) + (id)arrayByOrderingSet:(NSSet *)set byKey:(NSString *)key ascending:(BOOL)ascending {
	NSMutableArray *ret = [NSMutableArray arrayWithCapacity:[set count]]; 
	
	for (id oneObject in set)
		[ret addObject:oneObject];
	
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
	
	[ret sortUsingDescriptors:[NSArray arrayWithObject:descriptor]]; 
	[descriptor release]; 
	return ret;
} @end
