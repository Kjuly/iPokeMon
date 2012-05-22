//
//  MEWMapPoint.m
//  Mew
//
//  Created by Kaijie Yu on 5/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MEWMapPoint.h"

@interface MEWMapPoint () {
 @private
  NSString * title_;
  NSString * subTitle_;
}

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subTitle;

@end

@implementation MEWMapPoint

@synthesize coordinate = coordinate_;
@synthesize title      = title_;
@synthesize subTitle   = subTitle_;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                   title:(NSString *)title
                subTitle:(NSString *)subTitle {
  if (self = [super init]) {
    self.coordinate = coordinate;
    self.title      = title;
    self.subTitle   = subTitle;
  }
  return self;
}

@end
