//
//  WebViewOrderItemViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/25/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityService.h"


@interface WebViewOrderItemViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
