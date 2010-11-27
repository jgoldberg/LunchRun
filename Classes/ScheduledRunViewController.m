    //
//  OrderViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 10/27/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "ScheduledRunViewController.h"
#import "MyOrderViewController.h"
#import "Order.h"
#import "JSON.h"


@implementation ScheduledRunViewController

@synthesize textView;

- (void)viewDidLoad {	
	[super viewDidLoad];
}

- (IBAction) viewMyOrder: (id) sender
{	
	MyOrderViewController *myOrderViewController = [[MyOrderViewController alloc] initWithNibName:@"MyOrderView" bundle:nil];
	[self.navigationController pushViewController:myOrderViewController animated:YES];
	[myOrderViewController release];
}

- (IBAction) sendOrder: (id) sender {

}

- (IBAction) dismissKeyboard: (id) sender {
	NSLog(@"clicked");
	[textView resignFirstResponder];
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
