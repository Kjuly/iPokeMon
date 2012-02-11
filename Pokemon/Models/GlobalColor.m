//
//  GlobalColor.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GlobalColor.h"


@implementation GlobalColor

#pragma mark - Background Color

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

#pragma mark - Text Color

// Orange | #EE9911
+ (UIColor *)textColorOrange {
  return [UIColor colorWithRed:238.0f / 255.0f
                         green:153.0f / 255.0f
                          blue:17.0f  / 255.0f
                         alpha:1.0f];
}

// Blue   | #49627D
+ (UIColor *)textColorBlue {
  return [UIColor colorWithRed:73.0f / 255.0f
                         green:98.0f / 255.0f
                          blue:125.0f/ 255.0f
                         alpha:1.0f];
}

@end
