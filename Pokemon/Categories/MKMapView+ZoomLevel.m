//
//  MKMapView+ZoomLevel.h
//  iPokeMon
//
//  Created by Kaijie Yu on 5/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MKMapView+ZoomLevel.h"

// Convert latitude and longitude to pixel values at zoom level 20
#define MERCATOR_OFFSET 268435456         /* (total pixels at zoom level 20) / 2 */
#define MERCATOR_RADIUS 85445659.44705395 /* MERCATOR_OFFSET / pi */
// x = round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
// y = round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) 
//     / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);

@implementation MKMapView (ZoomLevel)

#pragma mark -
#pragma mark Map conversion methods

+ (double)originXForLongitude:(double)longitude {
  return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

+ (double)originYForLatitude:(double)latitude {
	if (latitude == 90.0) {
		return 0;
	} else if (latitude == -90.0) {
		return MERCATOR_OFFSET * 2;
	} else {
		return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
	}
}

+ (double)longitudeForOriginX:(double)originX {
  return ((round(originX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

+ (double)latitudeForOriginY:(double)originY {
  return (M_PI / 2.0 - 2.0 * atan(exp((round(originY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark -
#pragma mark Helper methods

- (MKCoordinateSpan)coordinateSpanWithMapView:(MKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(NSUInteger)zoomLevel {
  // convert center coordiate to pixel space
  double centerPixelX = [MKMapView originXForLongitude:centerCoordinate.longitude];
  double centerPixelY = [MKMapView originYForLatitude:centerCoordinate.latitude];
  
  // determine the scale value from the zoom level
  NSInteger zoomExponent = 20 - zoomLevel;
  double zoomScale = pow(2, zoomExponent);
  
  // scale the map’s size in pixel space
  CGSize mapSizeInPixels = mapView.bounds.size;
  double scaledMapWidth = mapSizeInPixels.width * zoomScale;
  double scaledMapHeight = mapSizeInPixels.height * zoomScale;
  
  // figure out the position of the top-left pixel
  double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
  double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
  
  // find delta between left and right longitudes
  CLLocationDegrees minLng = [MKMapView longitudeForOriginX:topLeftPixelX];
  CLLocationDegrees maxLng = [MKMapView longitudeForOriginX:topLeftPixelX + scaledMapWidth];
  CLLocationDegrees longitudeDelta = maxLng - minLng;
  
  // find delta between top and bottom latitudes
  CLLocationDegrees minLat = [MKMapView latitudeForOriginY:topLeftPixelY];
  CLLocationDegrees maxLat = [MKMapView latitudeForOriginY:topLeftPixelY + scaledMapHeight];
  CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
  
  // create and return the lat/lng span
  MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
  return span;
}

#pragma mark -
#pragma mark Public methods

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated {
  // clamp large numbers to 28
  zoomLevel = MIN(zoomLevel, 28);
  
  // use the zoom level to compute the region
  MKCoordinateSpan span = [self coordinateSpanWithMapView:self
                                         centerCoordinate:centerCoordinate
                                             andZoomLevel:zoomLevel];
  MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
  
  // set the region like normal
  [self setRegion:region animated:animated];
}

//KMapView cannot display tiles that cross the pole (as these would involve wrapping the map from top to bottom, something that a Mercator projection just cannot do).
-(MKCoordinateRegion)coordinateRegionWithMapView:(MKMapView *)mapView
                                centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                    andZoomLevel:(NSUInteger)zoomLevel {
	// clamp lat/long values to appropriate ranges
	centerCoordinate.latitude = MIN(MAX(-90.0, centerCoordinate.latitude), 90.0);
	centerCoordinate.longitude = fmod(centerCoordinate.longitude, 180.0);
  
	// convert center coordiate to pixel space
	double centerPixelX = [MKMapView originXForLongitude:centerCoordinate.longitude];
	double centerPixelY = [MKMapView originYForLatitude:centerCoordinate.latitude];
  
	// determine the scale value from the zoom level
	NSInteger zoomExponent = 20 - zoomLevel;
	double zoomScale = pow(2, zoomExponent);
  
	// scale the map’s size in pixel space
	CGSize mapSizeInPixels = mapView.bounds.size;
	double scaledMapWidth = mapSizeInPixels.width * zoomScale;
	double scaledMapHeight = mapSizeInPixels.height * zoomScale;
  
	// figure out the position of the left pixel
	double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
  
	// find delta between left and right longitudes
	CLLocationDegrees minLng = [MKMapView longitudeForOriginX:topLeftPixelX];
	CLLocationDegrees maxLng = [MKMapView longitudeForOriginX:topLeftPixelX + scaledMapWidth];
	CLLocationDegrees longitudeDelta = maxLng - minLng;
  
	// if we’re at a pole then calculate the distance from the pole towards the equator
	// as MKMapView doesn’t like drawing boxes over the poles
	double topPixelY = centerPixelY - (scaledMapHeight / 2);
	double bottomPixelY = centerPixelY + (scaledMapHeight / 2);
	BOOL adjustedCenterPoint = NO;
	if (topPixelY > MERCATOR_OFFSET * 2) {
		topPixelY = centerPixelY - scaledMapHeight;
		bottomPixelY = MERCATOR_OFFSET * 2;
		adjustedCenterPoint = YES;
	}
  
	// find delta between top and bottom latitudes
	CLLocationDegrees minLat = [MKMapView latitudeForOriginY:topPixelY];
	CLLocationDegrees maxLat = [MKMapView latitudeForOriginY:bottomPixelY];
	CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
  
	// create and return the lat/lng span
	MKCoordinateSpan span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta);
	MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
	// once again, MKMapView doesn’t like drawing boxes over the poles
	// so adjust the center coordinate to the center of the resulting region
	if (adjustedCenterPoint) {
		region.center.latitude = [MKMapView latitudeForOriginY:((bottomPixelY + topPixelY) / 2.0)];
	}
  
	return region;
}

- (NSUInteger)zoomLevel {
  MKCoordinateRegion region = self.region;
  
  double centerPixelX  = [MKMapView originXForLongitude:region.center.longitude];
  double topLeftPixelX = [MKMapView originXForLongitude:region.center.longitude - region.span.longitudeDelta / 2];
  
  double scaledMapWidth = (centerPixelX - topLeftPixelX) * 2;
  CGSize mapSizeInPixels = self.bounds.size;
  double zoomScale = scaledMapWidth / mapSizeInPixels.width;
  double zoomExponent = log(zoomScale) / log(2);
  double zoomLevel = 20 - zoomExponent;
  
  return zoomLevel;
}

@end