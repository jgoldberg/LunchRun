//
//  OrderItemCell.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/26/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrderItemCell : UITableViewCell {
	IBOutlet UILabel *name;
	IBOutlet UILabel *note1;
	IBOutlet UILabel *note2;
	IBOutlet UILabel *note3;
}

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *note1;
@property (nonatomic, retain) IBOutlet UILabel *note2;
@property (nonatomic, retain) IBOutlet UILabel *note3;

@end
