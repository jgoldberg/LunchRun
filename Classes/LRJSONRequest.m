//
//  RootViewRequestDelegate.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/20/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "LRJSONRequest.h"
#import "SBJsonParser.h"

@implementation LRJSONRequest

@synthesize receivedData=_receivedData;

- (id)initWithURL:(NSString *)url delegate:(id)delegate onSuccess:(SEL)onSuccess onFailure:(SEL)onFailure {
	if (self = [super init]) {
		_delegate = delegate;
		_onSuccess = onSuccess;
		_onFailure = onFailure;
		_url = url;
		_baseUrl = @"http://localhost:8080";
	}
	return self;
}

- (void) performGet {
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_baseUrl,_url]]];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) {
		_receivedData = [[NSMutableData data] retain];
	} else {
		[_delegate performSelector:_onFailure withObject:nil];
	}
	[request release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
    [connection release];
    [self.receivedData release];
	
	[_delegate performSelector:_onFailure withObject:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	
	NSString *response = [[NSString alloc] initWithData:self.receivedData encoding:NSASCIIStringEncoding];
	NSLog(@"%@",response);
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	
	[_delegate performSelector:_onSuccess withObject:[parser objectWithString:response]];
	
	[parser release];
	
    [connection release];
}

- (void) dealloc
{
    [_receivedData release];
	[super dealloc];
}

@end

