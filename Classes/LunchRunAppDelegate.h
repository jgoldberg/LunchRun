//
//  LunchRunAppDelegate.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/26/10.
//  Copyright N/A 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LunchRunAppDelegate : NSObject <UIApplicationDelegate, UINavigationControllerDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	NSString *currentScheduledRun;
	NSDictionary *menuData;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSString *currentScheduledRun;
@property (nonatomic, retain) NSDictionary *menuData;

@end

