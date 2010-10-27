//
//  RootViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 10/26/10.
//  Copyright N/A 2010. All rights reserved.
//

#import "RootViewController.h"
#import "ScheduledRunCell.h"
#import "LRTimeRemaining.h"
#import "ScheduledRunViewController.h"

@implementation RootViewController

@synthesize orderList;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	
	NSLog(@"Loading test data.");
	NSString *path = [[NSBundle mainBundle] pathForResource:@"testdata" ofType:@"plist"];
	NSDictionary *testdata = [[NSDictionary alloc] initWithContentsOfFile:path];
	NSArray *testOrderList = [testdata objectForKey:@"fulldata"];
	
	self.orderList = testOrderList;
	
	[testdata release];
	
	NSLog(@"Test data loaded.");
	
	[super viewDidLoad];
	
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [orderList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    ScheduledRunCell *cell = (ScheduledRunCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[[NSBundle mainBundle] loadNibNamed:@"ScheduledRunCell" owner:self options:nil] autorelease];
		cell = [nib objectAtIndex:0];
    }
    
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setTimeStyle:NSDateFormatterMediumStyle];
	[dateFormat setDateStyle:NSDateFormatterMediumStyle];
	
	// Configure the cell.
	NSInteger row = [indexPath row];
	NSDictionary *order = [orderList objectAtIndex:row];
	
	cell.destinationLabel.text = [order objectForKey:@"destination"];
	cell.cutoffDateLabel.text =  [dateFormat stringFromDate:[order objectForKey:@"cutoff_date"]];
	cell.userLabel.text = [order objectForKey:@"user_name"];
	
	NSDate *cutoffDate = [order objectForKey:@"cutoff_date"];
	if (cutoffDate == [cutoffDate earlierDate:[NSDate date]])
	{
		cell.timeRemainingLabel.text = @"Expired";
	}
	else
	{
		cell.timeRemainingLabel.text = [[order objectForKey:@"open"] boolValue] ? [LRTimeRemaining stringFromTimeRemaining:[order objectForKey:@"cutoff_date"]] : @"Closed";
	}
	
	[dateFormat release];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 66;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	 ScheduledRunViewController *scheduledRunViewController = [[ScheduledRunViewController alloc] initWithNibName:@"ScheduledRunView" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:scheduledRunViewController animated:YES];
	 [scheduledRunViewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

