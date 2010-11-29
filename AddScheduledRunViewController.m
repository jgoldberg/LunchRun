//
//  AddScheduledRunViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/22/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "AddScheduledRunViewController.h"
#import "SearchDestinationViewController.h"

#define DATE_PICKER 10

@implementation AddScheduledRunViewController

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
	[self dismissModalViewControllerAnimated:YES];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/YYYY h:mm a"];
        
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
