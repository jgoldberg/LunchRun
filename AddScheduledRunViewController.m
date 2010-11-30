//
//  AddScheduledRunViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/22/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "AddScheduledRunViewController.h"
#import "SearchDestinationViewController.h"
#import "LRJSONRequest.h"
#import "SBJsonWriter.h"

#define DATE_PICKER 10

@implementation AddScheduledRunViewController

@synthesize delegate;
@synthesize scrollView;
@synthesize contentView;
@synthesize destinationButton;
@synthesize dateButton;
@synthesize cutoffText;
@synthesize destination;
@synthesize datePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[scrollView setContentSize:CGSizeMake(contentView.bounds.size.width,contentView.bounds.size.height)];
	[scrollView addSubview:contentView];
}

- (IBAction) cancelForm: (id) sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) saveForm: (id) sender {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM/dd/y HH:mm"];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *groupToken = [defaults objectForKey:@"group_token"];
	NSString *userToken = [defaults objectForKey:@"user_token"];
	
	NSString *destinationID = [destination objectForKey:@"destination_id"];
	NSString *cutoffDate = [formatter stringFromDate:[datePicker date]];
	NSString *cutoffCount = [cutoffText text];
	
	NSDictionary *scheduledRunDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:destinationID,cutoffDate,cutoffCount,nil]
																 forKeys:[NSArray arrayWithObjects:@"destination_id",@"cutoff_datetime",@"cutoff_count",nil]];
	
	SBJsonWriter *writer = [[SBJsonWriter alloc] init];
	
	LRJSONRequest *request = [[LRJSONRequest alloc] initWithURL:@"/services/scheduledruns/create" 
													 groupToken:groupToken 
													  userToken:userToken 
													   delegate:self 
													  onSuccess:@selector(onCreateSuccess:) 
													  onFailure:@selector(onCreateFailure:)];
	[request performPost:[writer stringWithObject:scheduledRunDict]];
	[writer release];
	[formatter release];
}

- (IBAction) backgroundClick: (id) sender {
	[cutoffText resignFirstResponder];
}

- (IBAction) chooseDate: (id) sender {
	UIActionSheet *dateActionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose a cutoff time for orders." 
														delegate:self 
											   cancelButtonTitle:@"Cancel" 
										  destructiveButtonTitle:nil 
											   otherButtonTitles:@"Select", nil];
    [dateActionSheet setTag:DATE_PICKER];
	[dateActionSheet showInView:self.view];
    [dateActionSheet setFrame:CGRectMake(0, 117, 320, 383)];
    [dateActionSheet release];
}

- (IBAction) showDestinationSearch: (id) sender {
	SearchDestinationViewController *searchViewController = [[SearchDestinationViewController alloc] initWithNibName:@"SearchDestinationView" bundle:nil];
	[searchViewController setDelegate:self];
	[searchViewController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	[self presentModalViewController:searchViewController animated:YES];
	[searchViewController release];
}

- (void) onCreateSuccess:(NSDictionary*)response {
	[self dismissModalViewControllerAnimated:YES];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"LunchRun" 
														message:@"Your Lunch Run was successfully created!" 
													   delegate:nil
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	[delegate didCreateWithModal];
}

- (void) onCreateFailure:(NSError*)error {
	
}
																		

- (void) setDestinationFromSearch:(NSDictionary*)dest {
	[self.destinationButton setTitle:[dest objectForKey:@"name"] forState:UIControlStateNormal];
	self.destination = dest;
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    if (self.datePicker == nil) {
		UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 5, 320, 100)];
		[picker setMinuteInterval:15];
		self.datePicker = picker;
		[picker release];
	}
    [actionSheet addSubview:self.datePicker];
	
    NSArray *subviews = [actionSheet subviews];
    
    [[subviews objectAtIndex:0] setFrame:CGRectMake(20, 210, 280, 46)]; 
    [[subviews objectAtIndex:1] setFrame:CGRectMake(20, 245, 280, 46)];
	[[subviews objectAtIndex:2] setFrame:CGRectMake(20, 295, 280, 46)];
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet {
	// Normalize Date to 12:00 PM
	NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit fromDate:[NSDate date]];
	[dateComponent setHour:12];
	[dateComponent setMinute:0];
	NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponent];
	
	[self.datePicker setDate:date animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/y hh:mm a"];
        
        NSDate *selectedDate = [self.datePicker date];
        [self.dateButton setTitle:[formatter stringFromDate:selectedDate] forState:UIControlStateNormal];
        [formatter release];
    }
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
