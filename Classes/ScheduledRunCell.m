//
//  ScheduledRunCell.m
//  LunchRun
//
//  Created by Jason Goldberg on 10/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "ScheduledRunCell.h"

@implementation ScheduledRunCell

@synthesize destinationLabel;
@synthesize cutoffDateLabel;
@synthesize timeRemainingLabel;
@synthesize userLabel;

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
