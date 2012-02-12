//
//  MapViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

@synthesize mapView = mapView_;

@synthesize locationManager = locationManageer_;
@synthesize location        = location_;

- (void)dealloc
{
  [mapView_ release];
  
  [locationManageer_ release];
  [location_         release];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  [super loadView];
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 200.0f)];
  self.view = view;
  [view release];
  
  // Google Map View
  MKMapView * mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
  self.mapView = mapView;
  [mapView release];
  [self.view addSubview:self.mapView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.mapView setShowsUserLocation:YES];
  
  // Core Location
  // Create the Manager Object 
  locationManageer_ = [[CLLocationManager alloc] init];
  locationManageer_.delegate = self;
  
  // This is the most important property to set for the manager. It ultimately determines how the manager will
  // attempt to acquire location and thus, the amount of power that will be consumed.
  [locationManageer_ setDesiredAccuracy:kCLLocationAccuracyBest];
  [locationManageer_ setDistanceFilter:kCLDistanceFilterNone];
  
  // Create the CLLocation Object
  location_ = [[CLLocation alloc] init];
  
  // Start Updating Location
  [locationManageer_ startUpdatingLocation];
  
  // Stop Updating Location
//  [locationManageer_ stopUpdatingLocation];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.mapView = nil;
  
  self.locationManager = nil;
  self.location        = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UtilityViewControllerDelegate

- (void)actionForButtonLocateMe
{
  NSLog(@"--- MapViewController locateMe ---");
  
}

- (void)actionForButtonShowWorld
{
  NSLog(@"--- MapViewController showWorld ---");
}

#pragma mark - CLLocationManagerDelegate

// Tells the delegate that a new location value is available.
// Available in iOS 2.0 and later.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
  self.location = newLocation;
//  NSLog(@"<<< New Location: %@", [self.location description]);
  NSLog(@"Latitude: %g, Longitude: %g", self.location.coordinate.latitude, self.location.coordinate.longitude);
}

// Tells the delegate that the location manager received updated heading information.
// Available in iOS 3.0 and later.
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
}

// Tells the delegate that the user entered/exit the specified region.
// Available in iOS 4.0 and later.
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
}

/*
// Tells the delegate that a new region is being monitored.
// Available in iOS 5.0 and later.
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
}
*/

// Tells the delegate that a region monitoring error occurred.
// Available in iOS 4.0 and later.
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
}

// Tells the delegate that the authorization status for the application changed.
// Available in iOS 4.2 and later.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
}

// Asks the delegate whether the heading calibration alert should be displayed.
// Available in iOS 3.0 and later.
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
  return YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"!!! CLLocationManager - Error: %@", [error description]);
}

@end
