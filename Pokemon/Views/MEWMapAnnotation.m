//
//  MEWMapPoint.m
//  iPokeMon
//
//  Created by Kaijie Yu on 5/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MEWMapAnnotation.h"

@implementation MEWMapAnnotation

@synthesize code       = code_;
@synthesize coordinate = coordinate_;
@synthesize title      = title_;
@synthesize subtitle   = subtitle_;

- (id)initWithCode:(NSString *)code
        coordinate:(CLLocationCoordinate2D)coordinate
             title:(NSString *)title
          subtitle:(NSString *)subtitle {
  if (self = [super init]) {
    self.code       = code;
    self.coordinate = coordinate;
    self.title      = title;
    self.subtitle   = subtitle;
  }
  return self;
}

@end
