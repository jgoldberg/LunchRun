//
//  SettingsViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/21/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

@synthesize parentController;
@synthesize userFullName, groupName, groupPassword;
@synthesize scrollView;
@synthesize contentView;

- (void) cancelSettings: (id) sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void) saveSettings: (id) sender {
	hud = [[LRProgressHUD alloc] initWithLabel:@"Loading"];
	[hud show];
	
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:[userFullName text] forKey:@"user_name"];
	[dict setObject:[groupName text] forKey:@"group_name"];
	if (nil != [groupPassword text]) {
		[dict setObject:[groupPassword text] forKey:@"group_password"];
	} else {
		[dict setObject:@"" forKey:@"group_password"];		
	}
	[dict setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"device_identifier"];
	
	SBJsonWriter *writer = [[SBJsonWriter alloc] init];
	NSString *postData = [writer stringWithObject:dict];
	
	LRJSONRequest *request = [[LRJSONRequest alloc] initWithURL:@"/services/owner/register" 
													   delegate:self 
													  onSuccess:@selector(onRegisterSuccess:) 
													  onFailure:@selector(onRegisterFailure:)];
	[request performPost:postData];
}

- (void) onRegisterSuccess:(NSMutableArray *) response {
	NSLog(@"Success: %@", response);
	[hud dismiss];
	
	if ([response count] == 1) {
		NSDictionary *dict = [response objectAtIndex:0];
		NSString *responseMsg = [dict objectForKey:@"response"];
		if ([responseMsg isEqualToString:@"success"]) {
			// Retrieve token
			NSString *groupToken = [dict objectForKey:@"group_token"];
			
			// Store successful settings in DB
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			[defaults setObject:[userFullName text] forKey:@"user_name"];
			[defaults setObject:[groupName text] forKey:@"group_name"];
			[defaults setObject:[groupPassword text] forKey:@"group_password"];
			[defaults setObject:groupToken forKey:@"group_token"];
			
			[parentController reloadRemoteData];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LunchRun" 
															message:[NSString stringWithFormat:@"You successfully joined the group \"%@\" as \"%@\"!",[groupName text],[userFullName text]]
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			[self dismissModalViewControllerAnimated:YES];
		}
		else {
			// Only the username got updated
			NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
			[defaults setObject:[userFullName text] forKey:@"user_name"];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LunchRun" 
															message:[NSString stringWithFormat:@"Sorry! The password you entered does not match for group \"%@\".  You were unable to join.",[groupName text]]
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
		}

	}
	else {
		NSLog(@"Assertion failure: response count > 1");
	}
}

- (void) onRegisterFailure: (NSError *) error {
	NSLog(@"Failure");
	[hud dismiss];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LunchRun" 
													message:@"Sorry!  Could not connect to remote host." 
												   delegate:nil
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
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

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	userFullName.text = [defaults objectForKey:@"user_name"];
	groupName.text = [defaults objectForKey:@"group_name"];
	groupPassword.text = [defaults objectForKey:@"group_password"];
	
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
