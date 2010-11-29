//
//  SearchDestinationViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "SearchDestinationViewController.h"
#import "LRJSONRequest.h"


@implementation SearchDestinationViewController

@synthesize searchBar, tableView;
@synthesize searchResults;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[self.searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	if (timer != nil) {
		[timer invalidate];
	}
	timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(doSearch:) userInfo:nil repeats:NO];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
	
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {

}

- (void)doSearch:(NSTimer*)theTimer {
	NSString *searchText = [searchBar text];
	if (![searchText isEqualToString:@""] && ![searchText isEqualToString:lastSearch]) {
		lastSearch = [searchText copy];
		NSString *queryString = [lastSearch stringByAddingPercentEscapesUsingEncoding:NSMacOSRomanStringEncoding];
		NSLog(@"Do Search, query: %@", queryString);
		LRJSONRequest *request = [[LRJSONRequest alloc] initWithURL:[NSString stringWithFormat:@"/services/destinations/search?query=%@",queryString]
														   delegate:self 
														  onSuccess:@selector(onSearchSuccess:)
														  onFailure:@selector(onSearchFailure:)];
		[request performGet];
	} else {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}

	timer = nil;
}

- (void) onSearchSuccess:(NSArray *)response {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	self.searchResults = response;
	[tableView reloadData];
}

- (void) onSearchFailure:(NSError *)error {
	NSLog(@"Error");
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"GroupCell";
	
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	NSDictionary *destination = [searchResults objectAtIndex:[indexPath row]];
	cell.textLabel.text = [destination objectForKey:@"name"];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[delegate setDestinationFromSearch:[searchResults objectAtIndex:[indexPath row]]];
	[self dismissModalViewControllerAnimated:YES];
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
