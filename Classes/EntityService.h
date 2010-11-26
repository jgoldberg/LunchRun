//
//  EntityService.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/21/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "EntityFactory.h"
#import "LunchRunAppDelegate.h"

@interface EntityService : NSObject {

}

+ (NSArray *)findAllScheduledRuns;
+ (void) syncScheduledRuns:(NSArray *)remoteScheduledRuns;
+ (void) syncOrderItems:(NSDictionary *)params;

@end
