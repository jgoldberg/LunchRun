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

- (id)initWithURL:(NSString *)url groupToken:(NSString *)token delegate:(id)delegate onSuccess:(SEL)onSuccess onFailure:(SEL)onFailure {
	[self initWithURL:[NSString stringWithFormat:@"%@?group_token=%@",url,token] delegate:delegate onSuccess:onSuccess onFailure:onFailure];
}

- (id)initWithURL:(NSString *)url delegate:(id)delegate onSuccess:(SEL)onSuccess onFailure:(SEL)onFailure {
	if (self = [super init]) {
		_delegate = [delegate retain];
		_onSuccess = onSuccess;
		_onFailure = onFailure;
		_url = [url retain];
		//_baseUrl = @"http://ec2-50-16-7-104.compute-1.amazonaws.com";
		_baseUrl = @"http://localhost:8080";
	}
	return self;
}

- (void) performGet {
	NSLog(@"HTTP GET");
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_baseUrl,_url]]];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	if (connection) {
		_receivedData = [[NSMutableData data] retain];
	} else {
		[_delegate performSelector:_onFailure withObject:nil];
	}
	[request release];
}

- (void) performPost: (NSString *)postData {
	NSLog(@"HTTP POST: %@", postData);
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",_baseUrl,_url]]];
	[request setHTTPMethod:@"POST"];
	NSData *paramData = [[NSString stringWithFormat:@"%@=%@",@"query",postData] dataUsingEncoding:NSUTF8StringEncoding]; 
	[request setHTTPBody: paramData];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
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
	[response release];
	
    [connection release];
}

- (void) dealloc
{
	[_delegate release];
	[_url release];
	[_receivedData release];
	[super dealloc];
}

@end

