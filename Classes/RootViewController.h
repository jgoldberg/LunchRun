//
//  RootViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/26/10.
//  Copyright N/A 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
	NSArray *orderList;
}

@property (nonatomic, retain) NSArray *orderList;

@end
