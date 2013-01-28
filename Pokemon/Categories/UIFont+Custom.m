//
//  UIFont+Custom.m
//  iPokeMon
//
//  Created by Kaijie Yu on 6/25/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "UIFont+Custom.h"

@implementation UIFont (Custom)

+ (UIFont *)customNormalFontOfSize:(CGFloat)fontSize {
  return [self fontWithName:@"Arial" size:fontSize];
}

+ (UIFont *)customBoldFontOfSize:(CGFloat)fontSize {
  return [self fontWithName:@"Arial-BoldMT" size:fontSize];
}

+ (UIFont *)customItalicFontOfSize:(CGFloat)fontSize {
  return [self fontWithName:@"Arial-ItalicMT" size:fontSize];
}

+ (UIFont *)customBoldItalicFontOfSize:(CGFloat)fontSize {
  return [self fontWithName:@"Arial-BoldItalicMT" size:fontSize];
}

+ (UIFont *)customRoundedFontOfSize:(CGFloat)fontSize {
  return [self fontWithName:@"ArialRoundedMTBold" size:fontSize];
}

+ (UIFont *)customTitleFontOfSize:(CGFloat)fontSize {
  return [self customBoldFontOfSize:fontSize];
}

@end
