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
#import "ScheduledRunTabBarViewController.h"
#import "EntityService.h"

#define SUBMIT_ORDER_TAG 10
#define CANCEL_ORDER_TAG 20

@implementation ScheduledRunViewController

@synthesize textView;
@synthesize orderStatus;
@synthesize sendButton;
@synthesize cancelButton;

- (void)viewDidLoad {	
	[super viewDidLoad];
	
	hud = [[LRProgressHUD alloc] initWithLabel:@"Loading"];
	
	[self tabBar:nil didSelectItem:nil];
	
	ScheduledRun *scheduledRun = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] currentScheduledRun];
	orderStatus.text = [[scheduledRun myOrder] orderStatus];
}

- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate];
	Order *myOrder = [[delegate currentScheduledRun] myOrder];
	if ([myOrder.orderItems count] == 0) {
		[sendButton setAlpha:.5];
		[sendButton	setEnabled:FALSE];
	}
	
	if ([myOrder.orderStatus isEqualToString:@"Draft"]) {
		[cancelButton setAlpha:.5];
		[cancelButton setEnabled:FALSE];
	}
}

- (IBAction) viewMyOrder: (id) sender
{	
	MyOrderViewController *myOrderViewController = [[MyOrderViewController alloc] initWithNibName:@"MyOrderView" bundle:nil];
	UINavigationController *navController = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] navigationController];
	[navController pushViewController:myOrderViewController animated:YES];
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
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate];
	NSLog(@"Button Index: %d", buttonIndex);
	
	if (buttonIndex != 0) {
		return;
	}
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *groupToken = [defaults objectForKey:@"group_token"];
	NSString *userToken = [defaults objectForKey:@"user_token"];
	
	ScheduledRun *scheduledRun = [delegate currentScheduledRun];
	scheduledRun.myOrder.orderStatus = actionSheet.tag == SUBMIT_ORDER_TAG ? @"Submitted" : @"Canceled";

	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[scheduledRun scheduledRunID] forKey:@"scheduled_run_id"];
	
	NSDictionary *myOrderData = [[scheduledRun myOrder] serialize];
	[dict setObject:myOrderData forKey:@"my_order"];
	
	SBJsonWriter *writer = [[SBJsonWriter alloc] init];
	
	[hud show];
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
	[hud dismiss];
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate];
	orderStatus.text = @"Submitted";
	ScheduledRun *scheduledRun = [delegate currentScheduledRun];
	scheduledRun.myOrder.orderStatus = @"Submitted";
	NSManagedObjectContext *context = [delegate managedObjectContext];
	
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Error Saving");
	}
	
	NSDictionary *orderSummary = [response objectForKey:@"summary"];
	[EntityService syncOrderSummary:orderSummary];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"SummaryContextDidSave" object:nil];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"LunchRun" 
														message:@"Your order was successfully submitted." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	ScheduledRunTabBarViewController *tabController = [(LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate] scheduledRunTabBarViewController];
	[tabController setSelectedIndex:[tabController myGroupTabBarItem]];
}

- (void) onSubmitOrderFailure: (NSError *) error {
	[hud dismiss];
}

- (void) onCancelOrderSuccess: (NSDictionary *) response {
	[hud dismiss];
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate*)[[UIApplication sharedApplication] delegate];
	orderStatus.text = @"Canceled";
	ScheduledRun *scheduledRun = [delegate currentScheduledRun];
	scheduledRun.myOrder.orderStatus = @"Canceled";
	NSManagedObjectContext *context = [delegate managedObjectContext];
	
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Error Saving");
	}
		  
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"LunchRun" 
														message:@"Your order was successfully canceled. Note: You can still re-submit your order if you wish." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void) onCancelOrderFailure: (NSError *) error {
	[hud dismiss];
}

- (void)navigationController:(UINavigationController *)_navigationController willShowViewController:(UIViewController *)_viewController animated:(BOOL)animated {
	NSLog(@"Viewing ScheduledRunView");
	// TODO: refresh the buttons
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
