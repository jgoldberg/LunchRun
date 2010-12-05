//
//  DestinationInfoViewController.m
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import "DestinationInfoViewController.h"


@implementation DestinationInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	CLLocationDegrees lat = (CLLocationDegrees)37.0625;
	CLLocationDegrees lon = (CLLocationDegrees)-95.677068;
	CLLocationCoordinate2D coord;
	coord.latitude = lat;
	coord.longitude = lon;

	MKCoordinateSpan span;
	span.latitudeDelta = 1;
	span.longitudeDelta = 1;
	
	MKCoordinateRegion region;
	region.center = coord;
	region.span = span;
	
	[mapView setRegion:region];
	[mapView setCenterCoordinate:coord animated:YES];
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
