//
//  OrderItemSummaryTitleCell.h
//  LunchRun
//
//  Created by Jason Goldberg on 12/4/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderItemSummaryTitleCell : UITableViewCell {
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *quantityLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *quantityLabel;

@end
