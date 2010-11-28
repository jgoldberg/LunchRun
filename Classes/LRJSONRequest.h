//
//  RootViewRequestDelegate.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/20/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LRJSONRequest : NSObject {
	NSMutableData *_receivedData;
	id _delegate;
	SEL _onSuccess;
	SEL _onFailure;
	NSString *_url;
	NSString *_baseUrl;
}

- (id)initWithURL:(NSString *)url delegate:(id)delegate onSuccess:(SEL)onSuccess onFailure:(SEL)onFailure;
- (id)initWithURL:(NSString *)url groupToken:(NSString *)groupToken userToken:(NSString *)userToken delegate:(id)delegate onSuccess:(SEL)onSuccess onFailure:(SEL)onFailure;
- (void) performGet;
- (void) performPost: (NSString *)postData;

@property (nonatomic, retain) NSMutableData *receivedData;

@end
