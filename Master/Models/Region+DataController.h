//
//  Region+DataController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 5/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Region.h"
#import <CoreLocation/CoreLocation.h>

@interface Region (DataController)

+ (void)sync;
+ (NSString *)codeOfRegionWithPlacemark:(CLPlacemark *)placemark;

@end
