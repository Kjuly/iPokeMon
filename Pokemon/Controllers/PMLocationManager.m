//
//  PMLocationManager.m
//  iPokemon
//
//  Created by Kaijie Yu on 5/3/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PMLocationManager.h"

@implementation PMLocationManager

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
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
  }
  return self;
}

@end
