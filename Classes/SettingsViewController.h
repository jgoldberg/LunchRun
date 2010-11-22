//
//  SettingsViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/21/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LRJSONRequest.h"
#import "LRProgressHUD.h"
#import "SBJsonWriter.h"


@interface SettingsViewController : UIViewController {
	IBOutlet UITextField *userFullName;
	IBOutlet UITextField *groupName;
	IBOutlet UITextField *groupPassword;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIView *contentView;
	BOOL keyboardShown;
	LRProgressHUD *hud;
}

- (void) cancelSettings: (id) sender;
- (void) saveSettings: (id) sender;
- (void) backgroundClick: (id) sender;

@property (nonatomic, retain) IBOutlet UITextField *userFullName;
@property (nonatomic, retain) IBOutlet UITextField *groupName;
@property (nonatomic, retain) IBOutlet UITextField *groupPassword;
@property (nonatomic, retain) IBOutlet UIScrollView	*scrollView;
@property (nonatomic, retain) IBOutlet UIView *contentView;

@end
