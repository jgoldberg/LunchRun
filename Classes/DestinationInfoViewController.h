//
//  DestinationInfoViewController.h
//  LunchRun
//
//  Created by Jason Goldberg on 11/28/10.
//  Copyright 2010 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DestinationInfoViewController : UIViewController {
	IBOutlet MKMapView *mapView;
}

@property (nonatomic, retain) MKMapView *mapView;

@end
