//
//  GlobalColor.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalRender : NSObject

+ (UIColor *)backgroundColorMain;
+ (UIColor *)backgroundColorTransparentBlack;
+ (UIColor *)backgroundColorBar;

+ (UIColor *)textColorNormal;
+ (UIColor *)textColorOrange;
+ (UIColor *)textColorTitleWhite;

// Font Style
+ (UIFont *)textFontNormalInSizeOf:(CGFloat)fontSize;
+ (UIFont *)textFontBoldInSizeOf:(CGFloat)fontSize;
+ (UIFont *)textFontItalicInSizeOf:(CGFloat)fontSize;
+ (UIFont *)textFontBoldItalicInSizeOf:(CGFloat)fontSize;
+ (UIFont *)textFontRoundedInSizeOf:(CGFloat)fontSize;

@end;
