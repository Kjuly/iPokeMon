//
//  MapViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

typedef enum {
  kMEWMapPlaceTypeContinent = 0,      // continent
  kMEWMapPlaceTypeOcean,              // ocean
  kMEWMapPlaceTypeCountry,            // country
  kMEWMapPlaceTypeSea,                // sea
  kMEWMapPlaceTypeAdministrativeArea, // administrative (province)
  kMEWMapPlaceTypeLocality,           // locality (city)
  kMEWMapPlaceTypeLake,               // lake
  kMEWMapPlaceTypeSubLocality,        // sub-locality (district)
  kMEWMapPlaceTypeHotPoint            // hot point: shop, etc.
}MEWMapPlaceType;

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@end
