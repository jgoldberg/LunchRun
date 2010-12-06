//
//  WebViewOrderItemViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/25/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "WebViewOrderItemViewController.h"


@implementation WebViewOrderItemViewController

@synthesize webView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://ec2-50-16-7-104.compute-1.amazonaws.com/destination/franklins_bbq"]];
	//NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8080/destination/franklins_bbq"]];
	[webView loadRequest:request];
	[request release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *relativePath = [[request URL] relativePath];
	NSLog(@"URL: %@", relativePath);
	
	if ([relativePath isEqualToString:@"/addtocart"]) {
		NSString *queryString = [[request URL] query];
		NSLog(@"Found these parameters: %@", queryString);
		
		[self dismissModalViewControllerAnimated:TRUE];
		
		NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
		NSArray *components = [queryString componentsSeparatedByString:@"&"];
		
		for (NSString *component in components) {
			NSArray *pair = [component componentsSeparatedByString:@"="];
			
			NSString *key = [[pair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding: NSMacOSRomanStringEncoding];
			NSString *value = [[pair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding: NSMacOSRomanStringEncoding];
			
			key = [key stringByReplacingOccurrencesOfString:@"+" withString:@" "];
			value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
			
			[queryParams setObject:value forKey:key]; 
		}
		
		ScheduledRun *scheduledRun = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] currentScheduledRun];
		
		[EntityService syncOrderItems:queryParams forScheduledRun:scheduledRun];
		
		[queryParams release];
		
		return FALSE;
	}
	
	return TRUE;
}

- (void)dealloc {
    [webView setDelegate:nil];
	[webView release];
	[super dealloc];
}


@end
