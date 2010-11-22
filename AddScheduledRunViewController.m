//
//  AddScheduledRunViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/22/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "AddScheduledRunViewController.h"


@implementation AddScheduledRunViewController

@synthesize scrollView;
@synthesize contentView;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[scrollView setContentSize:CGSizeMake(contentView.bounds.size.width,contentView.bounds.size.height)];
	[scrollView addSubview:contentView];
}

- (IBAction) cancelForm: (id) sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) saveForm: (id) sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) backgroundClick: (id) sender {
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
