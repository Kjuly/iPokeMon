//
//  MapViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "UtilityViewController.h"

@interface MapViewController : UIViewController <UtilityViewControllerDelegate, MKMapViewDelegate>
{
  MKMapView * mapView_;
}

@property (nonatomic, retain) MKMapView * mapView;

@end
