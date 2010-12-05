//
//  ScheduledRunSummaryViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "OrderSummaryViewController.h"
#import "OrderItemSummaryTitleCell.h"
#import "OrderItemSummaryCell.h"

#define TITLE_ROW 0

@implementation OrderSummaryViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"OrderSummary";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (nil == cell) {
		if ([indexPath row] == TITLE_ROW) {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderItemSummaryTitleCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
		} else {
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderItemSummaryCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];
		}
	}
	
	if ([indexPath row] == TITLE_ROW) {
		OrderItemSummaryTitleCell *titleCell = (OrderItemSummaryTitleCell*)cell;
		titleCell.nameLabel.text = @"Two Meat Plate";
		titleCell.quantityLabel.text = @"Qty: 2";
	} else {
		OrderItemSummaryCell *summaryCell = (OrderItemSummaryCell*)cell;
		summaryCell.userLabel.text = @"Jason Goldberg";
		summaryCell.quantityLabel.text = @"Qty: 1";
		summaryCell.options1Label.text = @"Brisket (Moist), Sausage, Extra Sauce";
		summaryCell.options2Label.text = @"Extra Sauce";
	}
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Select");
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if ([cell selectionStyle] != UITableViewCellAccessoryCheckmark) {
		[cell setSelectionStyle:UITableViewCellAccessoryCheckmark];
	} else {
		[cell setSelectionStyle:UITableViewCellAccessoryNone];
	}

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] == TITLE_ROW) {
		return 54;
	} else {
		return 64;
	}
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end
