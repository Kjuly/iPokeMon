//
//  MapViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

// map's min zoom level for different type of terrain
typedef enum {
  kMEWMinZoomLevelOfContinentAndOcean  = 0,  // continent & ocean        : 0
  kMEWMinZoomLevelOfCountryAndSea      = 1,  // country & sea            : 1, 2
  kMEWMinZoomLevelOfAdministrativeArea = 3,  // administrative (province): 3, 4, 5
  kMEWMinZoomLevelOfLocality           = 5,  // locality (city)          : 5, 6, 7
  kMEWMinZoomLevelOfLake               = 6,  // lake                     : 6, 7, 8, 9
  kMEWMinZoomLevelOfSubLocality        = 8,  // sub-locality (district)  : 8, 9, 10
  kMEWMinZoomLevelOfHotPoint           = 10  // hot point: shop, etc.    : 10, ..., 20
}MEWMinZoomLevelOfTerrain;

// map's max zoom level for different type of terrain
typedef enum {
  kMEWMaxZoomLevelOfContinentAndOcean  = 0,  // continent & ocean        : 0
  kMEWMaxZoomLevelOfCountryAndSea      = 2,  // country & sea            : 1, 2
  kMEWMaxZoomLevelOfAdministrativeArea = 5,  // administrative (province): 3, 4, 5
  kMEWMaxZoomLevelOfLocality           = 7,  // locality (city)          : 5, 6, 7
  kMEWMaxZoomLevelOfLake               = 9,  // lake                     : 6, 7, 8, 9
  kMEWMaxZoomLevelOfSubLocality        = 10, // sub-locality (district)  : 8, 9, 10
  kMEWMaxZoomLevelOfHotPoint           = 20  // hot point: shop, etc.    : 10, ..., 20
}MEWMaxZoomLevelOfTerrain;

@interface MapViewController : UIViewController <
  MKMapViewDelegate,
  CLLocationManagerDelegate
>

- (void)reset;

@end
