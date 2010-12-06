//
//  AddScheduledRunViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/22/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchDestinationDelegate.h"
#import "CreateModalDelegate.h"

@interface AddScheduledRunViewController : UIViewController <SearchDestinationDelegate, UIActionSheetDelegate> {
	id<CreateModalDelegate> delegate;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIView *contentView;
	IBOutlet UIButton *destinationButton;
	IBOutlet UIButton *dateButton;
	IBOutlet UITextField *cutoffText;
	IBOutlet UIDatePicker *datePicker;
	NSDictionary *destination;
}

- (IBAction) cancelForm: (id) sender;
- (IBAction) saveForm: (id) sender;
- (IBAction) backgroundClick: (id) sender;
- (IBAction) showDestinationSearch: (id) sender;
- (IBAction) chooseDate: (id) sender;

@property (nonatomic, retain) id<CreateModalDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIButton *destinationButton;
@property (nonatomic, retain) IBOutlet UIButton *dateButton;
@property (nonatomic, retain) IBOutlet UITextField *cutoffText;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) NSDictionary *destination;

@end
