//
//  OrderItemSummaryTitleCell.m
//  LunchRun
//
//  Created by Jason Goldberg on 12/4/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "OrderItemSummaryTitleCell.h"


@implementation OrderItemSummaryTitleCell

@synthesize nameLabel;
@synthesize quantityLabel;

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
