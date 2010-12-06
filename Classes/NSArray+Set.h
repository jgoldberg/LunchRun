//
//  NSArray+Set.h
//  LunchRun
//
//  Created by Jason Goldberg on 12/6/10.
//  Copyright 2010 N/A. All rights reserved.
//

@interface NSArray(Set) 

+ (id)arrayByOrderingSet:(NSSet *)set byKey:(NSString *)key ascending:(BOOL)ascending;

@end
