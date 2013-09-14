//
//  PMLocationManager.m
//  iPokeMon
//
//  Created by Kaijie Yu on 5/3/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PMLocationManager.h"

#import "LoadingManager.h"
#import "Region+DataController.h"


@interface PMLocationManager () {
 @private
  CLLocationManager * locationManager_;
  CLLocation        * location_;
  NSDictionary      * locationInfo_;
  NSString          * regionCode_;   // current region code. e.g. 'CN:ZJ:HZ:XX:XX'
  NSTimer           * eventTimer_;
  
  BOOL               isUpdatingLocation_;
  BOOL               isPokemonAppeared_;
  CLLocationDistance moveDistance_;
}

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLLocation        * location;
@property (nonatomic, copy)   NSDictionary      * locationInfo;
@property (nonatomic, copy)   NSString          * regionCode;
@property (nonatomic, strong) NSTimer           * eventTimer;

- (void)_setup;
- (void)_enableTracking:(NSNotification *)notification;          // enable tracking
- (void)_disableTracking:(NSNotification *)notification;         // disable ...
- (void)_continueUpdatingLocation;                               // continue updating location after stop for a while
- (void)_resetIsPokemonAppeared:(NSNotification *)notification;  // reset after battle END
- (void)_setEventTimerStatusToRunning:(BOOL)running;             // |eventTimer_| related method
- (void)_generateLocationInfoForLocation:(CLLocation *)location; // generate location info

@end


@implementation PMLocationManager

@synthesize locationManager = locationManager_;
@synthesize location        = location_;
@synthesize locationInfo    = locationInfo_;
@synthesize regionCode      = regionCode_;
@synthesize eventTimer      = eventTimer_;

// singleton
static PMLocationManager * locationManager_ = nil;
+ (PMLocationManager *)sharedInstance {
  if (locationManager_ != nil)
    return locationManager_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    locationManager_ = [[PMLocationManager alloc] init];
  });
  return locationManager_;
}

- (void)dealloc {
  // Remove observers
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNEnableTracking  object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNDisableTracking object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNBattleEnd       object:nil];
}

- (id)init {
  if (self = [super init]) {
    [self _setup];
  }
  return self;
}

#pragma mark - Public Methods

// listen for notifications
- (void)listen {
  // Add observers for notification
  NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
  // Notification from |MainViewController| when |mapButton_| pressed
  [notificationCenter addObserver:self
                         selector:@selector(_enableTracking:)
                             name:kPMNEnableTracking
                           object:nil];
  [notificationCenter addObserver:self
                         selector:@selector(_disableTracking:)
                             name:kPMNDisableTracking
                           object:nil];
  // When game battle END
  [notificationCenter addObserver:self
                         selector:@selector(_resetIsPokemonAppeared:)
                             name:kPMNBattleEnd
                           object:nil];
}

// return current location
- (CLLocation *)currLocation {
  return self.location;
}

// return location info for current location
- (NSDictionary *)currLocationInfo {
  return self.locationInfo;
}

// return current region code
- (NSString *)currRegionCode {
  return self.regionCode;
}

#pragma mark - Private Methods

// Setup
- (void)_setup {
  // Basic settings
  isPokemonAppeared_ = NO;
  moveDistance_      = 0;
  
  // Core Location
  // Create the Manager Object
  locationManager_ = [[CLLocationManager alloc] init];
  locationManager_.delegate = self;
  
  // This is the most important property to set for the manager. It ultimately determines how the manager will
  // attempt to acquire location and thus, the amount of power that will be consumed.
  [locationManager_ setDesiredAccuracy:kCLLocationAccuracyBest];
  //  [locationManager_ setDistanceFilter:kCLDistanceFilterNone];
  [locationManager_ setDistanceFilter:100];
  
  // Create the CLLocation Object
  location_ = [[CLLocation alloc] init];
  
  // if low battery mode, use |startMonitoringSignificantLocationChanges|
  if ([[NSUserDefaults standardUserDefaults] boolForKey:kUDKeyGeneralLocationServices]) {
#ifdef KY_LOCATION_SERVICE_LOW_BATTERY_MODE_ON
    // check whether Significant-Change Location Service is available & use it
    if ([CLLocationManager significantLocationChangeMonitoringAvailable]) {
      NSLog(@"Significant Location Change Monitoring Available");
      [self.locationManager startMonitoringSignificantLocationChanges];
    }
#else
    NSLog(@"Start Tracking Location...");
    isUpdatingLocation_ = NO;
    // Check whether it is updating location after some time interval
    [self _continueUpdatingLocation];
    [self _setEventTimerStatusToRunning:YES];
#endif
  }
}

// Enable tracking
- (void)_enableTracking:(NSNotification *)notification {
  NSLog(@"ENABLING TRACKING...");
  [self _setEventTimerStatusToRunning:YES];
}

// Disable tracking
- (void)_disableTracking:(NSNotification *)notification {
  NSLog(@"DISABLING TRACKING...");
  // Stop updating Location
  isUpdatingLocation_ = NO;
  [self.locationManager stopUpdatingLocation];
  
  // Reset basic settings
  isPokemonAppeared_ = NO;
  [self _setEventTimerStatusToRunning:NO];
  
  // Reset |moveDistance_|
  moveDistance_ = 0;
}

// Continue updating location after stop for a while
- (void)_continueUpdatingLocation {
  if (! isUpdatingLocation_) {
    // Standard Location Service
    [self.locationManager startUpdatingLocation];
    isUpdatingLocation_ = YES;
  }
}

// Reset after battle END
- (void)_resetIsPokemonAppeared:(NSNotification *)notification {
  if ([[NSUserDefaults standardUserDefaults] boolForKey:kUDKeyGeneralLocationServices]) {
    NSLog(@"resetIsPokemonAppeared..");
    isPokemonAppeared_ = NO;
    [self _setEventTimerStatusToRunning:YES];
  }
}

// |eventTimer_| related method
- (void)_setEventTimerStatusToRunning:(BOOL)running {
  if (running) {
    if (! self.eventTimer)
      self.eventTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                         target:self
                                                       selector:@selector(_continueUpdatingLocation)
                                                       userInfo:nil
                                                        repeats:YES];
  } else {
    NSLog(@"Stop Timer....");
    [self.eventTimer invalidate];
    self.eventTimer = nil;
  }
}

// Generate location info
- (void)_generateLocationInfoForLocation:(CLLocation *)location {
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray * languages = [userDefaults objectForKey:@"AppleLanguages"];
  NSString * originalLanguage = [languages objectAtIndex:0];
  if (! [originalLanguage isEqualToString:@"en"])
    [languages insertObject:@"en" atIndex:0];
  
  // completion handler block
  void (^completionHandler)(NSArray*, NSError*) = ^(NSArray *placemarks, NSError *error) {
    if (! [originalLanguage isEqualToString:@"en"])
      [languages removeObjectAtIndex:0];
    
#ifndef KY_LOCAL_SERVER_ON
    //if([error code] == kCLErrorLocationUnknown) {}
    if (error) {
      NSLog(@"!!!ERROR: %@", [error localizedDescription]);
      NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSNumber numberWithInt:kPMErrorNetworkNotAvailable], @"error", nil];
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNError object:self userInfo:userInfo];
      [userInfo release];
      // loading done
      [[LoadingManager sharedInstance] hideOverBar];
      return;
    }
#endif
    
    /*
    NSDictionary *addressDictionary  // A dictionary containing the Address Book keys and values for the placemark
    NSString *name;                  // eg. Apple Inc.
    NSString *thoroughfare;          // street address, eg. 1 Infinite Loop
    NSString *subThoroughfare;       // eg. 1
    NSString *locality;              // city, eg. Cupertino
    NSString *subLocality;           // neighborhood, common name, eg. Mission District
    NSString *administrativeArea;    // state, eg. CA
    NSString *subAdministrativeArea; // county, eg. Santa Clara
    NSString *postalCode;            // zip code, eg. 95014
    NSString *ISOcountryCode;        // eg. US
    NSString *country;               // eg. United States
    NSString *inlandWater;           // eg. Lake Tahoe
    NSString *ocean;                 // eg. Pacific Ocean
    NSArray *areasOfInterest;        // eg. Golden Gate Park
    */
    NSMutableDictionary * locationInfo = [[NSMutableDictionary alloc] init];
    CLPlacemark * placemark = [placemarks objectAtIndex:0];
    NSLog(@"placemark:::%@", placemark);
    NSLog(@"addressDictionary:::%@", [placemark addressDictionary]);
    NSLog(@"name:::%@", [placemark name]);
    NSLog(@"thoroughfare:::%@", [placemark thoroughfare]);
    NSLog(@"subThoroughfare:::%@", [placemark subThoroughfare]);
    NSLog(@"locality:::%@", [placemark locality]);
    NSLog(@"subLocality:::%@", [placemark subLocality]);
    NSLog(@"administrativeArea:::%@", [placemark administrativeArea]);
    NSLog(@"administrativeArea:::%@", placemark.administrativeArea);
    NSLog(@"subAdministrativeArea:::%@", [placemark subAdministrativeArea]);
    NSLog(@"postalCode:::%@", [placemark postalCode]);
    NSLog(@"ISOcountryCode:::%@", [placemark ISOcountryCode]);
    NSLog(@"country:::%@", [placemark country]);
    NSLog(@"inlandWater:::%@", [placemark inlandWater]);
    NSLog(@"ocean:::%@", [placemark ocean]);
    NSLog(@"areasOfInterest:::%@", [placemark areasOfInterest]);
    if (placemark) [locationInfo setObject:placemark forKey:@"placemark"];
    self.locationInfo = locationInfo;
    
    // update |regionCode_| when get a different region code
    NSString * regionCode = [Region codeOfRegionWithPlacemark:placemark];
    if (! [self.regionCode isEqualToString:regionCode]) {
      self.regionCode = regionCode;
      // Sync Region Info when necessary
      [Region sync];
      // post notif to |ServerAPIClient| to update region (code)
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdateRegion
                                                          object:self.regionCode];
    }
    
    // loading done
    [[LoadingManager sharedInstance] hideOverBar];
    // post notif to |WildPokemonController| to generate new Wild PM
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNGenerateNewWildPokemon
                                                        object:self.locationInfo];
  };
  // loading start
  [[LoadingManager sharedInstance] showOverBar];
  CLGeocoder * geocoder = [[CLGeocoder alloc] init];
  [geocoder reverseGeocodeLocation:self.location completionHandler:completionHandler];
//#endif
}

#pragma mark - CLLocationManagerDelegate

// Tells the delegate that a new location value is available.
// Available in iOS 2.0 and later.
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  self.location = newLocation;
  //NSLog(@"Latitude: %g, Longitude: %g", self.location.coordinate.latitude, self.location.coordinate.longitude);
  // If |moveDistance == 0|, set a base distance:10,
  //   this'll fix the bug after restart tracking, the result of |distanceFromLocation:| will much big
  if (moveDistance_ == 0) moveDistance_ = 10;
  else moveDistance_ += [newLocation distanceFromLocation:oldLocation];
  NSLog(@"|||Move Distance: %f", moveDistance_);
  
  // If there's no Wild Pokemon Arreared yet, and got the basic required move distance,
  //   Generate a Wild Pokemon for player
#ifdef KY_PLAYER_MOVEMENT_SIMULATION_ON
  if (! isPokemonAppeared_ && arc4random() % 10 > 5)
#else
  if (! isPokemonAppeared_ && moveDistance_ > 10.0f && arc4random() % 2)
#endif
  {
    // Calculate the info for current location,
    //   so |WildPokemonController| can use the latest data to generate a Wild PM
    [self _generateLocationInfoForLocation:newLocation];
    
    /*/ Generate the Info Dictionary for Appeared Pokemon
    NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInt:kCenterMainButtonStatusPokemonAppeared],
                               @"centerMainButtonStatus", nil];
    
    ///Send Corresponding Notification: Pokemon Appeared!!!
    // Use |Local Notification| if in Background Mode
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
      UILocalNotification * localNotification = [[UILocalNotification alloc] init];
      // |UILocalNotification| only works on iOS4.0 and later
      if (! localNotification) {
        [userInfo release];
        return;
      }
      
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
    [userInfo release];*/
    
    // Mark as a Wild Pokemon appeared & stop tracking
    isPokemonAppeared_ = YES;
    [self _disableTracking:nil];
  }
  
  // If not in Low Battery Mode, need to check |horizontalAccuracy|
  // Stop updating location when needed
#ifndef LOCATION_SERVICE_LOW_BATTERY_MODE
  // When |horizontalAccuracy| of location is smaller than 100, stop updating location
  if (self.location.horizontalAccuracy < 100 && self.location.verticalAccuracy < 100) {
    [self.locationManager stopUpdatingLocation];
    isUpdatingLocation_ = NO;
  }
#endif
}

// Tells the delegate that the location manager received updated heading information.
// Available in iOS 3.0 and later.
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{}

// Tells the delegate that the user entered/exit the specified region.
// Available in iOS 4.0 and later.
- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{}

/*
// Tells the delegate that a new region is being monitored.
// Available in iOS 5.0 and later.
- (void)    locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region
{}
*/

// Tells the delegate that a region monitoring error occurred.
// Available in iOS 4.0 and later.
- (void)   locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(CLRegion *)region
                 withError:(NSError *)error
{}

// Tells the delegate that the authorization status for the application changed.
// Available in iOS 4.2 and later.
- (void)     locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{}

// Asks the delegate whether the heading calibration alert should be displayed.
// Available in iOS 3.0 and later.
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
  return YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"!!! CLLocationManager - Error: %@", [error description]);
}

@end
