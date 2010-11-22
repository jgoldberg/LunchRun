//
//  AddScheduledRunViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/22/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddScheduledRunViewController : UIViewController {
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIView *contentView;
}

- (IBAction) cancelForm: (id) sender;
- (IBAction) saveForm: (id) sender;
- (IBAction) backgroundClick: (id) sender;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *contentView;

@end
