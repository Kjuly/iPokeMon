//
//  GlobalColor.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GlobalRender.h"


@implementation GlobalRender

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

// Normal
+ (UIColor *)textColorNormal {
  return [UIColor colorWithWhite:204.0f / 255.0f alpha:1.0f];
}

// Bulr
+ (UIColor *)textColorBlue {
  return [self colorBlue];
}

// Orange | #EE9911
+ (UIColor *)textColorOrange {
  return [self colorOrange];
}

// Golden
+ (UIColor *)textColorGolden {
  return [self colorGolden];
}

// Red |
+ (UIColor *)textColorRed {
  return [UIColor redColor];
}

// Blue   | #49627D
+ (UIColor *)textColorTitleWhite {
  return [UIColor whiteColor];
}

// Text color for diabled button, etc.
+ (UIColor *)textColorDisabled {
  return [self colorGray];
}

+ (UIColor *)colorOrange {
  return [UIColor colorWithRed:238.0f / 255.0f
                         green:153.0f / 255.0f
                          blue:17.0f  / 255.0f
                         alpha:1.0f];
}

+ (UIColor *)colorGolden {
  return [UIColor colorWithRed:217.0f / 255.0f
                         green:183.0f / 255.0f
                          blue:112.0f  / 255.0f
                         alpha:1.0f];
}

+ (UIColor *)colorBlue {
  return [UIColor colorWithRed:91.0f / 255.0f
                         green:155.0f / 255.0f
                          blue:209.0f/ 255.0f
                         alpha:1.0f];
}

+ (UIColor *)colorGray {
  return [UIColor grayColor];
}

#pragma mark - Font Style
+ (UIFont *)textFontNormalInSizeOf:(CGFloat)fontSize {
  return [UIFont fontWithName:@"Arial" size:fontSize];
}

+ (UIFont *)textFontBoldInSizeOf:(CGFloat)fontSize {
  return [UIFont fontWithName:@"Arial-BoldMT" size:fontSize];
}

+ (UIFont *)textFontItalicInSizeOf:(CGFloat)fontSize {
  return [UIFont fontWithName:@"Arial-ItalicMT" size:fontSize];
}

+ (UIFont *)textFontBoldItalicInSizeOf:(CGFloat)fontSize {
  return [UIFont fontWithName:@"Arial-BoldItalicMT" size:fontSize];
}

+ (UIFont *)textFontRoundedInSizeOf:(CGFloat)fontSize {
  return [UIFont fontWithName:@"ArialRoundedMTBold" size:fontSize];
}

@end
