//
//  SearchDestinationViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDestinationDelegate.h"

@interface SearchDestinationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>{
	IBOutlet UISearchBar *searchBar;
	IBOutlet UITableView *tableView;
	NSTimer *timer;
	NSString *lastSearch;
	NSArray *searchResults;
	id<SearchDestinationDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *searchResults;
@property (nonatomic, retain) id<SearchDestinationDelegate> delegate;

@end
