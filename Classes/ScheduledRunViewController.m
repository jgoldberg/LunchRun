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

@synthesize scheduledRun;
@synthesize textView;

- (IBAction) viewMyOrder: (id) sender
{
	NSManagedObjectContext *context = [[[UIApplication sharedApplication] delegate] managedObjectContext];
	if ([self.scheduledRun myOrder] == nil) {
		NSLog(@"Creating Order");
		Order *myOrder = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:context];
		myOrder.myOrder = [NSNumber numberWithBool:TRUE];
		myOrder.scheduledRun = self.scheduledRun;
		self.scheduledRun.myOrder = myOrder;
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Error creating order: %@", [error userInfo]);
		}
	}
	
	MyOrderViewController *myOrderViewController = [[MyOrderViewController alloc] initWithNibName:@"MyOrderView" bundle:nil];
	myOrderViewController.scheduledRun = scheduledRun;
	[self.navigationController pushViewController:myOrderViewController animated:YES];
	[myOrderViewController release];
}

- (IBAction) sendOrder: (id) sender {
	NSManagedObjectContext *context = [[[UIApplication sharedApplication] delegate] managedObjectContext];
	[context refreshObject:scheduledRun mergeChanges:YES];
	
	SBJsonWriter *writer = [[SBJsonWriter alloc] init];

	NSDictionary *d = [[[UIApplication sharedApplication] delegate] menuData];
	
	if ([scheduledRun myOrder] == nil) {
		[textView setText:[NSString stringWithFormat:@"No Order Created: %d %d", [scheduledRun.orders count]]];
	} else {
		[textView setText:[NSString stringWithFormat:@"Order Exists: %d %d %@", [scheduledRun.orders count], [scheduledRun.myOrder.orderItems count], [writer stringWithObject:d ]]];
	}
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
	[scheduledRun release];
    [super dealloc];
}


@end
