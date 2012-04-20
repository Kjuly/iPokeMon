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

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
  MKMapView         * mapView_;
  CLLocationManager * locationManager_;
  CLLocation        * location_;
}

@property (nonatomic, retain) MKMapView         * mapView;
@property (nonatomic, retain) CLLocationManager * locationManager;
@property (nonatomic, retain) CLLocation        * location;

- (id)initWithLocationTracking;

@end
