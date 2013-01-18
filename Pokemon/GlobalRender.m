//
//  GlobalColor.m
//  iPokeMon
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
  return [self colorOrangeWithAlpha:1.f];
}

+ (UIColor *)colorOrangeWithAlpha:(CGFloat)alpha {
  return [UIColor colorWithRed:238.0f / 255.0f
                         green:153.0f / 255.0f
                          blue:17.0f  / 255.0f
                         alpha:alpha];
}

+ (UIColor *)colorGolden {
  return [self colorGoldenWithAlpha:1.f];
}

+ (UIColor *)colorGoldenWithAlpha:(CGFloat)alpha {
  return [UIColor colorWithRed:217.0f / 255.0f
                         green:183.0f / 255.0f
                          blue:112.0f  / 255.0f
                         alpha:alpha];
}

+ (UIColor *)colorBlue {
  return [self colorBlueWithAlpha:1.f];
}

+ (UIColor *)colorBlueWithAlpha:(CGFloat)alpha {
  return [UIColor colorWithRed:91.0f / 255.0f
                         green:155.0f / 255.0f
                          blue:209.0f/ 255.0f
                         alpha:alpha];
}

+ (UIColor *)colorRed {
  return [self colorRedWithAlpha:1.f];
}

+ (UIColor *)colorRedWithAlpha:(CGFloat)alpha {
  return [UIColor colorWithRed:225.f / 255.f
                         green:67.f / 255.f
                          blue:67.f / 255.f
                         alpha:alpha];
}

+ (UIColor *)colorGreen {
  return [self colorGreenWithAlpha:1.f];
}

+ (UIColor *)colorGreenWithAlpha:(CGFloat)alpha {
  return [UIColor colorWithRed:116.f / 255.f
                         green:183.f / 255.f
                          blue:36.f / 255.f
                         alpha:alpha];
}

+ (UIColor *)colorGray {
  return [self colorGrayWithAlpha:1.f];
}

+ (UIColor *)colorGrayWithAlpha:(CGFloat)alpha {
//  return [UIColor grayColor];
  return [UIColor colorWithWhite:.5f alpha:alpha];
}

+ (UIColor *)colorWithColorType:(ColorType)colorType {
  return [self colorWithColorType:colorType alpha:1.f];
}

+ (UIColor *)colorWithColorType:(ColorType)colorType
                          alpha:(CGFloat)alpha {
  /*
   kMEWColorTypeNone      = 0,
   kMEWColorTypeBlack     = 1 << 0,
   kMEWColorTypeWhite     = 1 << 1,
   kMEWColorTypeOrange    = 1 << 2,
   kMEWColorTypeGloden    = 1 << 3,
   kMEWColorTypeBlue      = 1 << 4,
   kMEWColorTypeGray      = 1 << 5,
   kMEWColorTypeDarkGray  = 1 << 6,
   kMEWColorTypeLightGray = 1 << 7
   */
  switch (colorType) {
    case kColorTypeBlack:
      return [UIColor colorWithWhite:0.f alpha:alpha];
      break;
      
    case kColorTypeWhite:
      return [UIColor colorWithWhite:1.f alpha:alpha];
      break;
      
    case kColorTypeOrange:
      return [self colorOrangeWithAlpha:alpha];
      break;
      
    case kColorTypeGolden:
      return [self colorGoldenWithAlpha:alpha];
      break;
      
    case kColorTypeBlue:
      return [self colorBlueWithAlpha:alpha];
      break;
      
    case kColorTypeRed:
      return [self colorRedWithAlpha:alpha];
      break;
      
    case kColorTypeGreen:
      return [self colorGreenWithAlpha:alpha];
      break;
      
    case kColorTypeGray:
      return [self colorGrayWithAlpha:alpha];
      break;
      
    case kColorTypeDarkGray:
    case kColorTypeLightGray:
    case kColorTypeNone:
    default:
      return nil;
      break;
  }
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
