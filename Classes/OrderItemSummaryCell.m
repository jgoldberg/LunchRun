//
//  OrderItemSummaryCell.m
//  LunchRun
//
//  Created by Jason Goldberg on 12/4/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "OrderItemSummaryCell.h"


@implementation OrderItemSummaryCell

@synthesize userLabel;
@synthesize quantityLabel;
@synthesize options1Label;
@synthesize options2Label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
