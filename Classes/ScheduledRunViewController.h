//
//  OrderViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 10/27/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduledRun.h"

@class LRProgressHUD;

@interface ScheduledRunViewController : UIViewController <UIActionSheetDelegate, UITabBarDelegate, UINavigationControllerDelegate>{
	IBOutlet UITextView *textView;
	IBOutlet UILabel *orderStatus;
	IBOutlet UIButton *sendButton;
	IBOutlet UIButton *cancelButton;
	LRProgressHUD *hud;
}

- (IBAction) viewMyOrder: (id) sender;
- (IBAction) sendOrder: (id) sender;
- (IBAction) cancelOrder: (id) sender;
- (IBAction) dismissKeyboard: (id) sender;

@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UILabel *orderStatus;
@property (nonatomic, retain) IBOutlet UIButton *sendButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;

@end
