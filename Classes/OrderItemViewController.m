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
#import "OrderItem.h"

#define QUANTITY_COMPONENT 0
#define ITEM_COMPONENT 1

@implementation OrderItemViewController

@synthesize instructionField;
@synthesize chooseItemButton;
@synthesize itemPickerView;
@synthesize currentQuantities;
@synthesize currentItems;
@synthesize scheduledRun;
@synthesize orderItem;

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

- (IBAction) chooseItemForEdit: (id) sender
{
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
	
	NSManagedObjectContext *context = [[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	OrderItem *newOrderItem = [NSEntityDescription
							insertNewObjectForEntityForName:@"OrderItem" 
							inManagedObjectContext:context];
	
	NSInteger itemIndex = [itemPickerView selectedRowInComponent:ITEM_COMPONENT];
	NSInteger quantityIndex = [itemPickerView selectedRowInComponent:QUANTITY_COMPONENT];
	
	NSString *quantity = (NSString *)[currentQuantities objectAtIndex:quantityIndex];
	NSString *item = (NSString *)[currentItems objectAtIndex:itemIndex];
	
	newOrderItem.name = [item copy];
	newOrderItem.quantity = [quantity copy];
	newOrderItem.order = [scheduledRun myOrder];
	
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Error saving");
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"OrderItemClose" object:self];
}

- (IBAction) saveFormForEdit: (id) sender
{
	[self dismissModalViewControllerAnimated:YES];
	
	if (orderItem != nil) {

		NSManagedObjectContext *context = [[[UIApplication sharedApplication] delegate] managedObjectContext];
		
		NSInteger itemIndex = [itemPickerView selectedRowInComponent:ITEM_COMPONENT];
		NSInteger quantityIndex = [itemPickerView selectedRowInComponent:QUANTITY_COMPONENT];
		
		NSString *quantity = (NSString *)[currentQuantities objectAtIndex:quantityIndex];
		NSString *item = (NSString *)[currentItems objectAtIndex:itemIndex];
		
		self.orderItem.name = [item copy];
		self.orderItem.quantity = [quantity copy];
		
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Error saving");
		}
	}
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
		NSArray *menuList = [menuTable objectForKey:[NSString stringWithFormat:@"%@",[scheduledRun scheduledRunID]]];
		NSDictionary *menuItem = [menuList objectAtIndex:row];
		
		NSArray *quantity = [menuItem objectForKey:@"quantity_options"];
		// Set default if no quantity array exists
		quantity = quantity != nil ? quantity : [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];		
		self.currentQuantities = quantity;
		
		[self.itemPickerView selectRow: 0 inComponent:QUANTITY_COMPONENT animated:TRUE];
		[self.itemPickerView reloadComponent:QUANTITY_COMPONENT];
	}
	
	NSInteger itemIndex = [pickerView selectedRowInComponent:ITEM_COMPONENT];
	NSInteger quantityIndex = component == ITEM_COMPONENT ? 0 : [pickerView selectedRowInComponent:QUANTITY_COMPONENT];
	
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
	NSLog(@"Menu Data Loaded: scheduled run id: %@", [scheduledRun scheduledRunID]);
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSDictionary *menuTable = [delegate menuData];
	NSString *key = [NSString stringWithFormat:@"%@",[scheduledRun scheduledRunID]];
	NSArray *menuList = [menuTable objectForKey:key];
	
	NSMutableArray *nameList = [[NSMutableArray alloc] initWithCapacity:[menuList count]];
	for (NSInteger i=0; i<[menuList count]; i++)
	{
		NSDictionary *menuEntry= [menuList objectAtIndex:i];
		[nameList insertObject:[menuEntry objectForKey:@"name"] atIndex:i];
		
		if (i == 0)
		{
			NSArray *quantity = [menuEntry objectForKey:@"quantity_options"];
			self.currentQuantities = quantity != nil ? quantity : [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];
		}
	}
	
	self.currentItems = [NSArray arrayWithArray:nameList];
	
	[nameList release];
	
	
	if (orderItem != nil) {
		NSLog(@"Reading State From OrderItem");
		for (NSInteger i=0; i<[menuList count]; i++) {
			NSDictionary *menuEntry = [menuList objectAtIndex:i];
			NSString *menuName = [menuEntry objectForKey:@"name"];
			NSArray *menuQuantities = [menuEntry objectForKey:@"quantity_options"];
			
			if ([menuName isEqualToString:[orderItem name]]) {
				self.currentQuantities = menuQuantities != nil ? menuQuantities : [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];;
				
				NSInteger itemIndex = [currentItems indexOfObject:[orderItem name]];
				NSInteger quantityIndex = [currentQuantities indexOfObject:[orderItem quantity]];
				
				[itemPickerView selectRow: itemIndex inComponent:ITEM_COMPONENT animated:TRUE];
				[itemPickerView selectRow: quantityIndex inComponent:QUANTITY_COMPONENT animated:TRUE];
				//[itemPickerView reloadAllComponents];
				
				NSString *title = [NSString stringWithFormat:@"%@ %@", [currentQuantities objectAtIndex:quantityIndex],[currentItems objectAtIndex:itemIndex]];
				[chooseItemButton setTitle:title forState:UIControlStateNormal];
			}
		}
	}
	
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
    [instructionField release];
	[chooseItemButton release];
	[itemPickerView release];
	[currentQuantities release];
	[currentItems release];
	[scheduledRun release];
	[super dealloc];
}


@end
