//
//  MEWMapPoint.h
//  iPokeMon
//
//  Created by Kaijie Yu on 5/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MEWMapAnnotation : NSObject <MKAnnotation> {
  NSString * code_;
  CLLocationCoordinate2D coordinate_;
  NSString * title_;
  NSString * subtitle_;
}

@property (nonatomic, copy)   NSString * code;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)   NSString * title;
@property (nonatomic, copy)   NSString * subtitle;

- (id)initWithCode:(NSString *)code
        coordinate:(CLLocationCoordinate2D)coordinate
             title:(NSString *)title
          subtitle:(NSString *)subtitle;

@end
