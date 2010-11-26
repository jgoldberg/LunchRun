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
	
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8080/destination/franklins_bbq"]];
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
			
			[queryParams setObject:[[pair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding: NSMacOSRomanStringEncoding]
							forKey:[pair objectAtIndex:0]]; 
		}
		
		[EntityService syncOrderItems:queryParams];
		
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
