//
//  UIFont+Custom.h
//  iPokeMon
//
//  Created by Kaijie Yu on 6/25/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Custom)

+ (UIFont *)customNormalFontOfSize:(CGFloat)fontSize;
+ (UIFont *)customBoldFontOfSize:(CGFloat)fontSize;
+ (UIFont *)customItalicFontOfSize:(CGFloat)fontSize;
+ (UIFont *)customBoldItalicFontOfSize:(CGFloat)fontSize;
+ (UIFont *)customRoundedFontOfSize:(CGFloat)fontSize;
+ (UIFont *)customTitleFontOfSize:(CGFloat)fontSize;

@end
