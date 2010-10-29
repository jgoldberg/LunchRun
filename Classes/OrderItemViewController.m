    //
//  OrderItemViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 10/27/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "OrderItemViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "LunchRunAppDelegate.h"

#define QUANTITY_COMPONENT 0
#define ITEM_COMPONENT 1

@implementation OrderItemViewController

@synthesize instructionField;
@synthesize chooseItemButton;
@synthesize itemPickerView;
@synthesize currentQuantities;
@synthesize currentItems;
@synthesize scheduledRunId;

#pragma mark -
#pragma mark Actions

- (IBAction) chooseItem: (id) sender
{
	NSInteger itemIndex = [itemPickerView selectedRowInComponent:ITEM_COMPONENT];
	NSInteger quantityIndex = [itemPickerView selectedRowInComponent:QUANTITY_COMPONENT];
	
	NSString *title = [NSString stringWithFormat:@"%@ %@", [currentQuantities objectAtIndex:quantityIndex],[currentItems objectAtIndex:itemIndex]];
	[chooseItemButton setTitle:title forState:UIControlStateNormal];
	
	[itemPickerView setHidden:FALSE];
}

- (IBAction) closePicker: (id) sender
{
	[itemPickerView setHidden:TRUE];
	[instructionField resignFirstResponder];
}

- (IBAction) cancelForm: (id) sender
{
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) saveForm: (id) sender
{
	[self dismissModalViewControllerAnimated:YES];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"OrderItemClose" object:self];
}

#pragma mark -
#pragma mark Picker Data Source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == QUANTITY_COMPONENT)
	{
		return [currentQuantities count];
	}
	
	if (component == ITEM_COMPONENT) 
	{
		return [currentItems count];
	}
	
	return 0;
}

#pragma mark -
#pragma mark Picker Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	if (component == QUANTITY_COMPONENT)
	{
		return 50;
	}
	
	if (component == ITEM_COMPONENT)
	{
		return 270;
	}
	
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if (component == QUANTITY_COMPONENT)
	{
		return [currentQuantities objectAtIndex:row];
	}
	
	if (component == ITEM_COMPONENT) 
	{
		return [currentItems objectAtIndex:row];
	}
	
	return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{		
	if (component == ITEM_COMPONENT)
	{
		LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
		NSDictionary *menuTable = [delegate menuData];
		NSArray *menuList = [menuTable objectForKey:scheduledRunId];
		NSDictionary *menuItem = [menuList objectAtIndex:row];
		
		NSArray *quantity = [menuItem objectForKey:@"quantity_options"];
		// Set default if no quantity array exists
		quantity = quantity != nil ? quantity : [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];		
		self.currentQuantities = quantity;
		
		[self.itemPickerView selectRow: 0 inComponent:QUANTITY_COMPONENT animated:TRUE];
		[self.itemPickerView reloadComponent:QUANTITY_COMPONENT];
	}
	
	NSInteger itemIndex = [pickerView selectedRowInComponent:ITEM_COMPONENT];
	NSInteger quantityIndex = [pickerView selectedRowInComponent:QUANTITY_COMPONENT];
	
	NSString *title = [NSString stringWithFormat:@"%@ %@", [currentQuantities objectAtIndex:quantityIndex],[currentItems objectAtIndex:itemIndex]];
	[chooseItemButton setTitle:title forState:UIControlStateNormal];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSDictionary *menuTable = [delegate menuData];
	NSArray *menuList = [menuTable objectForKey:scheduledRunId];
	
	NSMutableArray *nameList = [[NSMutableArray alloc] initWithCapacity:[menuList count]];
	for (NSInteger i=0; i<[menuList count]; i++)
	{
		NSDictionary *menuItem = [menuList objectAtIndex:i];
		[nameList insertObject:[menuItem objectForKey:@"name"] atIndex:i];
		
		if (i == 0)
		{
			NSArray *quantity = [menuItem objectForKey:@"quantity_options"];
			self.currentQuantities = quantity != nil ? quantity : [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];
		}
	}
	
	self.currentItems = [NSArray arrayWithArray:nameList];
	
	[nameList release];
	
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
