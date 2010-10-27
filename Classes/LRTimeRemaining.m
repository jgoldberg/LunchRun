//
//  LRTimeRemaining.m
//  LunchRun
//
//  Created by Jason Goldberg on 10/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "LRTimeRemaining.h"

@implementation LRTimeRemaining

#define SECS_IN_HOUR 3600
#define SECS_IN_MIN 60

+ (NSString *) stringFromTimeRemaining: (NSDate *)date
{
	NSTimeInterval timeInterval = [date timeIntervalSinceNow];
	
	int seconds = (int)timeInterval;

	int days = (seconds - (seconds % SECS_IN_HOUR))/SECS_IN_HOUR;
	
	seconds = seconds % SECS_IN_HOUR;
	
	int minutes  = (seconds - (seconds % SECS_IN_MIN))/SECS_IN_MIN;
	
	NSString *result = [[[NSString alloc] initWithFormat:@"%i h %i m", days, minutes] autorelease];
	return  result;
}

@end
