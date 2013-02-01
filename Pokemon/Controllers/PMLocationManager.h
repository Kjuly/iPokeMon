//
//  PMLocationManager.h
//  iPokeMon
//
//  Created by Kaijie Yu on 5/3/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface PMLocationManager : NSObject <CLLocationManagerDelegate>

+ (PMLocationManager *)sharedInstance;

- (void)listen;
- (CLLocation *)currLocation;       // return |location_|
- (NSDictionary *)currLocationInfo; // return location info for current location
- (NSString *)currRegionCode;       // return current region code

@end
