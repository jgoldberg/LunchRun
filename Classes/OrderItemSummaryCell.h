//
//  OrderItemSummaryCell.h
//  LunchRun
//
//  Created by Jason Goldberg on 12/4/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderItemSummaryCell : UITableViewCell {
	IBOutlet UILabel *userLabel;
	IBOutlet UILabel *quantityLabel;
	IBOutlet UILabel *options1Label;
	IBOutlet UILabel *options2Label;
}

@property (nonatomic, retain) IBOutlet UILabel *userLabel;
@property (nonatomic, retain) IBOutlet UILabel *quantityLabel;
@property (nonatomic, retain) IBOutlet UILabel *options1Label;
@property (nonatomic, retain) IBOutlet UILabel *options2Label;

@end
