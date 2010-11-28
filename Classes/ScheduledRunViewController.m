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
#import "LRJSONRequest.h"
#import "LunchRunAppDelegate.h"

#define SUBMIT_ORDER_TAG 10
#define CANCEL_ORDER_TAG 20

@implementation ScheduledRunViewController

@synthesize textView;
@synthesize orderStatus;
@synthesize sendButton;

- (void)viewDidLoad {	
	[super viewDidLoad];
	
	orderStatus.text = @"Draft";
}

- (IBAction) viewMyOrder: (id) sender
{	
	MyOrderViewController *myOrderViewController = [[MyOrderViewController alloc] initWithNibName:@"MyOrderView" bundle:nil];
	[self.navigationController pushViewController:myOrderViewController animated:YES];
	[myOrderViewController release];
}

- (IBAction) sendOrder: (id) sender {
	UIActionSheet *confirmModal = [[UIActionSheet alloc] initWithTitle:@"Submit this order?" 
															  delegate:self 
													 cancelButtonTitle:@"Cancel" 
												destructiveButtonTitle:@"Submit Order" 
													 otherButtonTitles:nil];
	confirmModal.tag = SUBMIT_ORDER_TAG;
	[confirmModal showInView:self.view];
}

- (IBAction) cancelOrder: (id) sender {
	UIActionSheet *confirmModal = [[UIActionSheet alloc] initWithTitle:@"Cancel this order?" 
															  delegate:self 
													 cancelButtonTitle:@"Nevermind" 
												destructiveButtonTitle:@"Cancel Order"
													 otherButtonTitles:nil];
	confirmModal.tag = CANCEL_ORDER_TAG;
	[confirmModal showInView:self.view];
}

- (IBAction) dismissKeyboard: (id) sender {
	NSLog(@"clicked");
	[textView resignFirstResponder];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"Button Index: %d", buttonIndex);
	
	if (buttonIndex != 0) {
		return;
	}
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *groupToken = [defaults objectForKey:@"group_token"];
	NSString *userToken = [defaults objectForKey:@"user_token"];
	
	ScheduledRun *scheduledRun = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] currentScheduledRun];

	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[scheduledRun scheduledRunID] forKey:@"scheduled_run_id"];
	
	NSDictionary *myOrderData = [[scheduledRun myOrder] serialize];
	[dict setObject:myOrderData forKey:@"my_order"];
	
	SBJsonWriter *writer = [[SBJsonWriter alloc] init];
	
	if (actionSheet.tag == SUBMIT_ORDER_TAG) {
		[dict setObject:@"submit" forKey:@"action"];
		NSString *postData = [writer stringWithObject:dict];
		LRJSONRequest *submitRequest = [[LRJSONRequest alloc] initWithURL:@"/services/orders/save_order" 
															   groupToken:groupToken 
																userToken:userToken 
																 delegate:self 
																onSuccess:@selector(onSubmitOrderSuccess:) 
																onFailure:@selector(onSubmitOrderFailure:)];
		[submitRequest performPost:postData];
		[submitRequest release];
	}		
	else if (actionSheet.tag == CANCEL_ORDER_TAG) {
		[dict setObject:@"cancel" forKey:@"action"];
		NSString *postData = [writer stringWithObject:dict];
		LRJSONRequest *submitRequest = [[LRJSONRequest alloc] initWithURL:@"/services/orders/save_order" 
															   groupToken:groupToken 
																userToken:userToken 
																 delegate:self 
																onSuccess:@selector(onCancelOrderSuccess:) 
																onFailure:@selector(onCancelOrderFailure:)];
		[submitRequest performPost:postData];
		[submitRequest release];
	}
	
	[writer release];
}

- (void) onSubmitOrderSuccess: (NSDictionary *) response {
	
}

- (void) onSubmitOrderFailure: (NSError *) error {
	
}

- (void) onCancelOrderSuccess: (NSDictionary *) response {
	
}

- (void) onCancelOrderFailure: (NSError *) error {
	
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
