//
//  GlobalColor.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GlobalColor.h"


@implementation GlobalColor

// Main background color
+ (UIColor *)backgroundColorMain
{
  return [UIColor colorWithRed:73.0f / 255.0f
                         green:98.0f / 255.0f
                          blue:125.0f/ 255.0f
                         alpha:1.0f];
}

// Black transparent background
+ (UIColor *)backgroundColorTransparentBlack {
  return [UIColor colorWithWhite:0.0f alpha:0.6f];
}

// Bar background color
+ (UIColor *)backgroundColorBar
{
  return [UIColor whiteColor];
}

@end
