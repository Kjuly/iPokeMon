//
//  MapViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MapViewController.h"

#import "PMLocationManager.h"

@interface MapViewController () {
 @private
  CLLocation * location_;
}

@property (nonatomic, retain) CLLocation * location;

- (void)releaseSubviews;

@end


@implementation MapViewController

@synthesize mapView  = mapView_;
@synthesize location = location_;

- (void)dealloc {
  self.location = nil;
  [self releaseSubviews];
  [super dealloc];
}

- (void)releaseSubviews {
  self.mapView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.location = [[PMLocationManager sharedInstance] currLocation];
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  self.view = view;
  [view release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Google Map View
  MKMapView * mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
  [mapView setShowsUserLocation:YES];
  self.mapView = mapView;
  [mapView release];
  [self.view addSubview:self.mapView];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self releaseSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UtilityViewControllerDelegate

// Locate user's location
- (void)actionForButtonLocateMe {
  // Get current location
//  self.location = self.locationManager.location;
  
  // Zoom In the |mapView_| & make User's Location as |mapView_| center point
  MKCoordinateRegion region = self.mapView.region;
  region.span.longitudeDelta = 0.01f;
  region.span.latitudeDelta  = 0.01f;
  region.center = CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude);
  [self.mapView setRegion:region animated:YES];  
}

// Show whole world map
- (void)actionForButtonShowWorld {
  // Get current location
//  self.location = self.locationManager.location;
  
  // Zoom Out the |mapView_| & make User's Location as |mapView_| center point
  MKCoordinateRegion region = self.mapView.region;
  region.span.longitudeDelta = 180;
  region.span.latitudeDelta  = 180;
  region.center = CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude);
  [self.mapView setRegion:region animated:YES];
}

@end
