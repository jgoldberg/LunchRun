//
//  ScheduledRunTabBarViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "ScheduledRunTabBarViewController.h"

@implementation ScheduledRunTabBarViewController

@synthesize tabBar;
@synthesize myOrderTabBarItem, myGroupTabBarItem, orderSummaryTabBarItem, destinationTabBarItem;
@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
	[tabBar setSelectedItem:myOrderTabBarItem];
	scheduledRunViewController = [[ScheduledRunViewController alloc] initWithNibName:@"ScheduledRunView" bundle:nil];
	selectedController = scheduledRunViewController;
	[self.view insertSubview:scheduledRunViewController.view atIndex:0];
}

- (void)setSelectedIndex:(UITabBarItem *)tabBarItem {
	[tabBar setSelectedItem:tabBarItem];
	[self tabBar:tabBar didSelectItem:tabBarItem];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	NSLog(@"Tab Bar Item Selected");
	[selectedController.view removeFromSuperview];
	
	UIViewController *controller = selectedController;
	if (item == myOrderTabBarItem) { 
		if (nil == scheduledRunViewController) {
			scheduledRunViewController = [[ScheduledRunViewController alloc] initWithNibName:@"ScheduledRunView" bundle:nil];
		}
		controller = scheduledRunViewController;
	} else if (item == myGroupTabBarItem) {
		if (nil == myGroupTableViewController) {
			myGroupTableViewController = [[MyGroupTableViewController alloc] initWithNibName:@"MyGroupTableView" bundle:nil];
		}
		controller = myGroupTableViewController;
	} else if (item == orderSummaryTabBarItem) {
		if (nil == orderSummaryViewController) {
			orderSummaryViewController = [[OrderSummaryViewController alloc] initWithNibName:@"OrderSummaryView" bundle:nil];
		}
		controller = orderSummaryViewController;		
	} else {
		if (nil == destinationInfoViewController) {
			destinationInfoViewController = [[DestinationInfoViewController alloc] initWithNibName:@"DestinationInfoView" bundle:nil];
		}
		controller = destinationInfoViewController;
	}
	
	selectedController = controller;
	if ([selectedController conformsToProtocol:@protocol(UITabBarDelegate)]) {
		[selectedController tabBar:tabBar didSelectItem:item];
	}
	[self.view insertSubview:controller.view atIndex:0];
}

- (void)navigationController:(UINavigationController *)_navigationController willShowViewController:(UIViewController *)_viewController animated:(BOOL)animated {
	NSLog(@"Tab Bar willShowViewController");
	if ([selectedController conformsToProtocol:@protocol(UINavigationControllerDelegate)]) {
		id<UINavigationControllerDelegate> *delegate = (id<UINavigationControllerDelegate> *)selectedController;
		[delegate navigationController:_navigationController willShowViewController:_viewController animated:animated];
	}
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
