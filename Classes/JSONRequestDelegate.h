//
//  JSONRequestDelegate.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/20/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JSONRequestDelegate

- (void)onSuccess:(NSString *)response;
- (void)onFailure:(NSString *)response;

@end
