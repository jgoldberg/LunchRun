//
//  ScheduledRunTabBarViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduledRunViewController.h"


@interface ScheduledRunTabBarViewController : UIViewController <UITabBarDelegate> {
	IBOutlet UITabBar *tabBar;
	IBOutlet UITabBarItem *myOrderTabBarItem;
	IBOutlet UITabBarItem *myGroupTabBarItem;
	IBOutlet UITabBarItem *orderSummaryTabBarItem;
	IBOutlet UITabBarItem *destinationTabBarItem;
	IBOutlet UIView *contentView;
	
	UIViewController *selectedController;
	ScheduledRunViewController *scheduledRunViewController;
}

@property (nonatomic, retain) IBOutlet UITabBar *tabBar;
@property (nonatomic, retain) IBOutlet UITabBarItem *myOrderTabBarItem;
@property (nonatomic, retain) IBOutlet UITabBarItem *myGroupTabBarItem;
@property (nonatomic, retain) IBOutlet UITabBarItem *orderSummaryTabBarItem;
@property (nonatomic, retain) IBOutlet UITabBarItem *destinationTabBarItem;
@property (nonatomic, retain) IBOutlet UIView *contentView;

@end
