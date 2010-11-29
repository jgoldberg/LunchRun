//
//  MyGroupTableViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "MyGroupTableViewController.h"

#define SUBMITTED_SECTION 0
#define UNSUBMITTED_SECTION 1

@implementation MyGroupTableViewController

@synthesize tableView;

- (void)viewDidLoad {
	submittedOrders = [[NSArray arrayWithObjects:@"Jason Goldberg", @"Alex Goldberg", nil] retain];
	unsubmittedOrders = [[NSArray arrayWithObjects:@"Diana Goldberg", @"Brad Goldberg", nil] retain];
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == SUBMITTED_SECTION) {
		return @"Submitted Order";
	} else if (section == UNSUBMITTED_SECTION) {
		return @"No Submitted Order";
	}
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == SUBMITTED_SECTION) {
		return [submittedOrders count];
	} else if (section == UNSUBMITTED_SECTION) {
		return [unsubmittedOrders count];
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"GroupCell Section: %d Row: %d", [indexPath section], [indexPath row]);
	static NSString *CellIdentifier = @"GroupCell";
	
	if ([indexPath section] == SUBMITTED_SECTION) {
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		cell.textLabel.text = [submittedOrders objectAtIndex:[indexPath row]];
		return cell;
	} else if ([indexPath section] == UNSUBMITTED_SECTION) {
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.textLabel.text = [unsubmittedOrders objectAtIndex:[indexPath row]];
		return cell;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath section] == SUBMITTED_SECTION) {
		
	}
	[[tableView cellForRowAtIndexPath:indexPath] setSelected:FALSE];
}

- (void)dealloc {
    [super dealloc];
}


@end
