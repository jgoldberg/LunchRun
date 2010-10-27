//
//  ScheduledRunCell.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScheduledRunCell : UITableViewCell {
	IBOutlet UILabel *destinationLabel;
	IBOutlet UILabel *cutoffDateLabel;
	IBOutlet UILabel *timeRemainingLabel;
	IBOutlet UILabel *userLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *destinationLabel;
@property (nonatomic, retain) IBOutlet UILabel *cutoffDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeRemainingLabel;
@property (nonatomic, retain) IBOutlet UILabel *userLabel;

@end
