//
//  SettingsViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/21/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize userFullName, groupName, groupPassword;
@synthesize scrollView;
@synthesize contentView;

- (void) cancelSettings: (id) sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) saveSettings: (id) sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) backgroundClick: (id) sender {
	NSLog(@"Click");
	[userFullName resignFirstResponder];
	[groupName resignFirstResponder];
	[groupPassword resignFirstResponder];
}

- (void)viewDidLoad {
	[scrollView setContentSize:CGSizeMake(contentView.bounds.size.width,contentView.bounds.size.height)];
	[scrollView addSubview:contentView];
	
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end
