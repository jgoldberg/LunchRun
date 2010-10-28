//
//  LunchRunAppDelegate.m
//  LunchRun
//
//  Created by Jason Goldberg on 10/26/10.
//  Copyright N/A 2010. All rights reserved.
//

#import "LunchRunAppDelegate.h"
#import "RootViewController.h"


@implementation LunchRunAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize currentScheduledRun;
@synthesize menuData;

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	NSLog(@"Clicked");
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"menudata" ofType:@"plist"];
	NSDictionary *_menuData = [[NSDictionary alloc] initWithContentsOfFile:path];
	self.menuData = _menuData;
	
	[_menuData release];
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

