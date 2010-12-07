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
@synthesize scheduledRunTabBarViewController;
@synthesize menuData;
@synthesize currentScheduledRun;
@synthesize summaryDataLoaded;
@synthesize alertRunning;

#pragma mark -
#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)_navigationController willShowViewController:(UIViewController *)_viewController animated:(BOOL)animated {
	NSLog(@"LunchRunAppDelegate willShowViewController");
	if ([_viewController conformsToProtocol:@protocol(UINavigationControllerDelegate)]) {
		NSLog(@"LunchRunAppDelegate willShowViewController: delegate found");
		id<UINavigationControllerDelegate> *delegate = (id<UINavigationControllerDelegate> *)_viewController;
		[delegate navigationController:_navigationController willShowViewController:_viewController animated:animated];
	}
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
		[managedObjectContext setRetainsRegisteredObjects:YES];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"CoreDataTest.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"menudata" ofType:@"plist"];
	NSDictionary *_menuData = [[NSDictionary alloc] initWithContentsOfFile:path];
	self.menuData = _menuData;
	[_menuData release];
	
	self.summaryDataLoaded = FALSE;
	
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];

	// For testing remote APNS in a simulator env
	//NSString *testData = [NSString stringWithString:@"blah"];
	//[self application:[UIApplication sharedApplication] didRegisterForRemoteNotificationsWithDeviceToken:[testData dataUsingEncoding:NSASCIIStringEncoding]];
	 
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	const unsigned *tokenBytes = [deviceToken bytes];
	NSString *token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
						  ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
						  ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
						  ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
	
	NSLog(@"Token: %@", token);
	
	LRJSONRequest *request = [[LRJSONRequest alloc] initWithURL:@"/services/owner/apns_register" 
													   delegate:self 
													  onSuccess:@selector(registerTokenSuccess:)
													  onFailure:@selector(registerTokenFailure:)];
	
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
	// Reset group if the token is not set
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *resetGroup = [NSNumber numberWithBool:([defaults objectForKey:@"group_token"] == nil ? YES : NO)];
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:token forKey:@"apns_token"];
	[dict setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"device_identifier"];
	[dict setObject:resetGroup forKey:@"reset_group"];
	
	SBJsonWriter *writer = [[SBJsonWriter alloc] init];
	
	[request performPost:[writer stringWithObject:dict]];
	
	[writer release];
	[request release];
	[token release];
}
							  
- (void)registerTokenSuccess:(NSDictionary *)response {
	NSLog(@"Token successfully registered");
}

- (void)registerTokenFailure:(NSError *)response {
	NSLog(@"Error registering APNS token");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"APNS Error: %@", error);
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
	
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

