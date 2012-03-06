//
//  MapViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MapViewController.h"

#import "GlobalConstants.h"
#import "GlobalNotificationConstants.h"
#import "AFJSONRequestOperation.h"
#import "Pokemon+DataController.h"

#define kLocationServiceLowBatteryMode 0


@interface MapViewController ()
{
 @private
  BOOL                 isUpdatingLocation_;
  BOOL                 isPokemonAppeared_;
  NSTimer            * eventTimer_;
  CLLocationDistance   moveDistance_;
}

@property (nonatomic, assign) BOOL                 isUpdatingLocation;
@property (nonatomic, assign) BOOL                 isPokemonAppeared;
@property (nonatomic, retain) NSTimer            * eventTimer;
@property (nonatomic, assign) CLLocationDistance   moveDistance;

- (void)continueUpdatingLocation;
- (void)resetIsPokemonAppeared:(NSNotification *)notification;
- (void)setEventTimerStatusToRunning:(BOOL)running;
- (NSDictionary *)generateInfoForAppearedPokemon;
- (NSDictionary *)generateInfoForCurrentLocation;

@end


@implementation MapViewController

@synthesize mapView         = mapView_;
@synthesize locationManager = locationManageer_;
@synthesize location        = location_;

@synthesize isUpdatingLocation = isUpdatingLocation_;
@synthesize isPokemonAppeared  = isPokemonAppeared_;
@synthesize eventTimer         = eventTimer_;
@synthesize moveDistance       = moveDistance_;

- (void)dealloc
{
  [mapView_          release];
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
//  [super loadView];
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
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
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(resetIsPokemonAppeared:)
                                               name:kPMNBattleEnd object:nil];
  
  [self.mapView setShowsUserLocation:YES];
  
  isPokemonAppeared_ = NO;
  moveDistance_      = 0;
  
  // Core Location
  // Create the Manager Object 
  locationManageer_ = [[CLLocationManager alloc] init];
  locationManageer_.delegate = self;
  
  // This is the most important property to set for the manager. It ultimately determines how the manager will
  // attempt to acquire location and thus, the amount of power that will be consumed.
  [locationManageer_ setDesiredAccuracy:kCLLocationAccuracyBest];
//  [locationManageer_ setDistanceFilter:kCLDistanceFilterNone];
  [locationManageer_ setDistanceFilter:100];
  
  // Create the CLLocation Object
  location_ = [[CLLocation alloc] init];

  NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"keyAppSettingsLocationServices"]);
  if ([[NSUserDefaults standardUserDefaults] boolForKey:@"keyAppSettingsLocationServices"]) {
    if (kLocationServiceLowBatteryMode && [CLLocationManager significantLocationChangeMonitoringAvailable]) {
      NSLog(@"Significant Location Change Monitoring Available");
      // Significant-Change Location Service
      [self.locationManager startMonitoringSignificantLocationChanges];
    }
    else {
      NSLog(@"Start Tracking Location...");
      isUpdatingLocation_ = NO;
      // Check whether it is updating location after some time interval
      [self setEventTimerStatusToRunning:YES];
    }
  }
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.mapView = nil;
  
  self.locationManager = nil;
  self.location        = nil;
  self.eventTimer      = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UtilityViewControllerDelegate

// Locate user's location
- (void)actionForButtonLocateMe
{
  // Get current location
  self.location = self.locationManager.location;
  
  // Zoom In the |mapView_| & make User's Location as |mapView_| center point
  MKCoordinateRegion region = self.mapView.region;
  region.span.longitudeDelta = 0.01f;
  region.span.latitudeDelta  = 0.01f;
  region.center = CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude);
  [self.mapView setRegion:region animated:YES];  
}

// Show whole world map
- (void)actionForButtonShowWorld
{
  // Get current location
  self.location = self.locationManager.location;
  
  // Zoom Out the |mapView_| & make User's Location as |mapView_| center point
  MKCoordinateRegion region = self.mapView.region;
  region.span.longitudeDelta = 180;
  region.span.latitudeDelta  = 180;
  region.center = CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude);
  [self.mapView setRegion:region animated:YES];
}

#pragma mark - CLLocationManagerDelegate

// Tells the delegate that a new location value is available.
// Available in iOS 2.0 and later.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
  self.location = newLocation;
//  NSLog(@"Latitude: %g, Longitude: %g", self.location.coordinate.latitude, self.location.coordinate.longitude);
  self.moveDistance += [self.location distanceFromLocation:oldLocation];
  NSLog(@"Move Distance: %f", self.moveDistance);
  
  if (! self.isPokemonAppeared && self.moveDistance >= 100.0f && arc4random() % 2) {
    // Generate the Info Dictionary for Appeared Pokemon
    NSDictionary * userInfo = [self generateInfoForAppearedPokemon];
    
    ///Send Corresponding Notification: Pokemon Appeared!!!
    // Use |Local Notification| if in Background Mode
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
      UILocalNotification * localNotification = [[UILocalNotification alloc] init];
      // |UILocalNotification| only works on iOS4.0 and later
      if (! localNotification)
        return;
      
      // Set data for Local Notification
      localNotification.fireDate = [NSData data];
      //localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
      localNotification.timeZone = [NSTimeZone defaultTimeZone];
      localNotification.alertBody = @"Pokemon Appeared!!!";
      localNotification.alertAction = @"Go";
      localNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
      localNotification.userInfo = userInfo;
      //[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
      [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
      [localNotification release];
    }
    // Use Post Notification if in Foreground Mode
    else {
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNPokemonAppeared object:nil userInfo:userInfo];
    }
    
    self.isPokemonAppeared = YES;
    [self setEventTimerStatusToRunning:NO];
    
    // Stop updating Location
    self.isUpdatingLocation = NO;
    [self.locationManager stopUpdatingLocation];
    
    // Reset |moveDistance_|
    self.moveDistance = 0;
  }

  // If not in Low Battery Mode, need to check |horizontalAccuracy|
  // Stop updating location when needed
  if (! kLocationServiceLowBatteryMode) {
    // When |horizontalAccuracy| of location is smaller than 100, stop updating location
    if (self.location.horizontalAccuracy < 100 && self.location.verticalAccuracy < 100) {
      [self.locationManager stopUpdatingLocation];
      self.isUpdatingLocation = NO;
    }
  }
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

#pragma mark - Actions

// Continue updating location after some time interval
- (void)continueUpdatingLocation
{
  if (! self.isUpdatingLocation) {
    // Standard Location Service
    [self.locationManager startUpdatingLocation];
    self.isUpdatingLocation = YES;
  }
}

- (void)resetIsPokemonAppeared:(NSNotification *)notification
{
  NSLog(@"resetIsPokemonAppeared");
  self.isPokemonAppeared = NO;
  [self setEventTimerStatusToRunning:YES];
}

- (void)setEventTimerStatusToRunning:(BOOL)running
{
  if (running) {
    if (! self.eventTimer)
      self.eventTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                         target:self
                                                       selector:@selector(continueUpdatingLocation)
                                                       userInfo:nil
                                                        repeats:YES];
  } else {
    NSLog(@"Stop Timer....");
    [self.eventTimer invalidate];
    self.eventTimer = nil;
  }
}

- (NSDictionary *)generateInfoForAppearedPokemon
{
  // Generate an Appeared Pokemon to user
  // TODO:
  // need to be random
  Pokemon * appearedPokemon = [Pokemon queryPokemonDataWithID:1];
  
  NSDictionary * pokemonInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:kCenterMainButtonStatusPokemonAppeared], @"centerMainButtonStatus",
                                appearedPokemon.sid, @"pokemonID",
                                nil];
  appearedPokemon = nil;
  return pokemonInfo;
}

// Request a query to Google Maps API to get a detail info about current location
- (NSDictionary *)generateInfoForCurrentLocation
{
  NSMutableDictionary * locationInfo = [[NSMutableDictionary alloc] init];
  
  ///Fetch Data from server & populate the |locationInfo|
  // Success Block Method
  void (^blockPopulateData)(NSURLRequest *, NSHTTPURLResponse *, id) =
  ^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON) {
    // Set data
    NSLog(@"status: %@", [JSON valueForKey:@"status"]);
    if ([[JSON valueForKey:@"status"] isEqualToString:@"OK"]) {
      NSLog(@"Setting data....");
      NSDictionary * results = [[JSON valueForKey:@"results"] lastObject];
      [locationInfo setValue:[results objectForKey:@"types"] forKey:@"types"];
    }
    NSLog(@"In: %@", locationInfo);
  };
  
  // Failure Block Method
  void (^blockError)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) =
  ^(NSURLRequest *request, NSHTTPURLResponse * response, NSError * error, id JSON) {
    NSLog(@"!!! ERROR: %@", error);
  };
  
  // Fetch Data from server
  NSString * requestURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true", self.location.coordinate.latitude, self.location.coordinate.longitude];
  NSLog(@"%@", requestURL);
  NSURL * url = [[NSURL alloc] initWithString:requestURL];
  NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
  [url release];
  AFJSONRequestOperation * operation =
  [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                  success:blockPopulateData
                                                  failure:blockError];
  [request release];
  [operation start];
  
  return [locationInfo autorelease];
}

@end
