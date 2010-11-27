    //
//  MyOrderViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 10/27/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "MyOrderViewController.h"
#import "OrderItemViewController.h"
#import "LunchRunAppDelegate.h"
#import "OrderItem.h"
#import "WebViewOrderItemViewController.h"
#import "OrderItemCell.h"

@implementation MyOrderViewController

@synthesize tableView;
@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewDidLoad {
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																			   target:self 
																			   action:@selector(addOrderItem:)];
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleClose) name:@"OrderItemClose" object:nil];
	
	[tableView setEditing:YES animated:YES];
	tableView.rowHeight = 88;
	
	[super viewDidLoad];
	
	NSError *error;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@: %@", error, [error userInfo]);
		exit(-1);
	}
}

- (IBAction) addOrderItem: (id) sender
{
	NSLog(@"Add Order Item");

	WebViewOrderItemViewController *orderItemView = [[WebViewOrderItemViewController alloc] initWithNibName:@"WebViewOrderItemView" bundle:nil];
	// TODO: Set URL
	[orderItemView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	[self presentModalViewController:orderItemView animated:YES];
	[orderItemView release];
}

- (void)handleClose
{
	NSLog(@"Closed!");
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)_tableView {
    return [[self.fetchedResultsController sections] count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"OrderItem";
    
    OrderItemCell *cell = (OrderItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderItemCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
    }
	
	OrderItem *orderItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSString *title = [NSString stringWithFormat:@"%@ %@", orderItem.quantity,orderItem.name];
	cell.name.text = [NSString stringWithString:title];
	
	NSLog(@"-- Cell Created At %d", [indexPath row]);
	
    return cell;
}

- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController != nil)
		return _fetchedResultsController;
	
	LunchRunAppDelegate *delegate = (LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [delegate managedObjectContext];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"OrderItem" inManagedObjectContext:context];
	[fetchRequest setEntity:entityDescription];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	[fetchRequest setFetchBatchSize:20];
	
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
																				 managedObjectContext:context 
																				   sectionNameKeyPath:nil 
																							cacheName:nil/*@"Root"*/];
	[controller setDelegate:self];
	_fetchedResultsController = controller;
	
	return _fetchedResultsController;	
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeUpdate:
			[tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
    switch(type) {
			
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
			
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
	NSLog(@"Data Changed!");
	[self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	OrderItem *orderItem = [self.fetchedResultsController objectAtIndexPath: indexPath];
	
	OrderItemViewController *orderItemView = [[OrderItemViewController alloc] initWithNibName:@"EditOrderItemView" bundle:nil];
	orderItemView.orderItem = orderItem;
	[orderItemView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
	[self presentModalViewController:orderItemView animated:YES];
	[orderItemView release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       	NSManagedObjectContext *context = [(LunchRunAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
		
		OrderItem *toBeDeleted = [self.fetchedResultsController objectAtIndexPath:indexPath];
		[context deleteObject:toBeDeleted];
		
		NSError *error;
		if (![context save:&error]) {
			NSLog(@"Error");
		}
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
	[_fetchedResultsController release];
	[tableView release];
    
	[super dealloc];
}


@end
