//
//  LunchRunAppDelegate.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/26/10.
//  Copyright N/A 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ScheduledRun.h"
#import "ScheduledRunTabBarViewController.h"

@interface LunchRunAppDelegate : NSObject <UIApplicationDelegate,UINavigationControllerDelegate> {
    // Core Data
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext; // Used for core changes
	NSManagedObjectContext *summaryManagedObjectContext; // Used for summary data
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	// UI
    UIWindow *window;
    UINavigationController *navigationController;
	ScheduledRunTabBarViewController *scheduledRunTabBarViewController;
	NSDictionary *menuData;
	
	// Model
	ScheduledRun *currentScheduledRun;
	
	// Modal State
	BOOL alertRunning;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) ScheduledRunTabBarViewController *scheduledRunTabBarViewController;
@property (nonatomic, retain) NSDictionary *menuData;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *summaryManagedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) ScheduledRun *currentScheduledRun;

@property (nonatomic, getter = isAlertRunning) BOOL alertRunning;

@end

