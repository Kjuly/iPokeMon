//
//  MapViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "UtilityViewController.h"

@interface MapViewController : UIViewController <UtilityViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
  MKMapView * mapView_;
  
  CLLocationManager * locationManageer_;
  CLLocation        * location_;
  BOOL                isUpdatingLocation_;
  BOOL                isPokemonAppeared_;
}

@property (nonatomic, retain) MKMapView * mapView;
@property (nonatomic, retain) CLLocationManager * locationManager;
@property (nonatomic, retain) CLLocation        * location;
@property (nonatomic, assign) BOOL                isUpdatingLocation;
@property (nonatomic, assign) BOOL                isPokemonAppeared;

@end
