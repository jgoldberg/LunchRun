//
//  OrderItemViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/27/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ScheduledRun.h"
#include "OrderItem.h"

@interface OrderItemViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource> {
	IBOutlet UITextField *instructionField;
	IBOutlet UIButton *chooseItemButton;
	IBOutlet UIPickerView *itemPickerView;
	NSArray *currentItems;
	NSArray *currentQuantities;
	ScheduledRun *scheduledRun;
	OrderItem *orderItem;
}

- (IBAction) chooseItem: (id) sender;
- (IBAction) chooseItemForEdit: (id) sender;
- (IBAction) closePicker: (id) sender;
- (IBAction) cancelForm: (id) sender;
- (IBAction) saveForm: (id) sender;
- (IBAction) saveFormForEdit: (id) sender;

@property (nonatomic, retain) IBOutlet UITextField *instructionField;
@property (nonatomic, retain) IBOutlet UIButton *chooseItemButton;
@property (nonatomic, retain) IBOutlet UIPickerView *itemPickerView;
@property (nonatomic, retain) NSArray *currentItems;
@property (nonatomic, retain) NSArray *currentQuantities;
@property (nonatomic, retain) ScheduledRun *scheduledRun;
@property (nonatomic, retain) OrderItem *orderItem;

@end
