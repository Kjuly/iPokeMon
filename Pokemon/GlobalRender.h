//
//  GlobalColor.h
//  iPokeMon
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
+ (UIColor *)textColorBlue;
+ (UIColor *)textColorOrange;
+ (UIColor *)textColorGolden;
+ (UIColor *)textColorRed;
+ (UIColor *)textColorTitleWhite;

+ (UIColor *)textColorDisabled;

+ (UIColor *)colorOrange;
+ (UIColor *)colorOrangeWithAlpha:(CGFloat)alpha;
+ (UIColor *)colorGolden;
+ (UIColor *)colorGoldenWithAlpha:(CGFloat)alpha;
+ (UIColor *)colorBlue;
+ (UIColor *)colorBlueWithAlpha:(CGFloat)alpha;
+ (UIColor *)colorRed;
+ (UIColor *)colorRedWithAlpha:(CGFloat)alpha;
+ (UIColor *)colorGreen;
+ (UIColor *)colorGreenWithAlpha:(CGFloat)alpha;
+ (UIColor *)colorGray;
+ (UIColor *)colorGrayWithAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithColorType:(ColorType)colorType;
+ (UIColor *)colorWithColorType:(ColorType)colorType
                          alpha:(CGFloat)alpha;

// Font Style
+ (UIFont *)textFontNormalInSizeOf:(CGFloat)fontSize;
+ (UIFont *)textFontBoldInSizeOf:(CGFloat)fontSize;
+ (UIFont *)textFontItalicInSizeOf:(CGFloat)fontSize;
+ (UIFont *)textFontBoldItalicInSizeOf:(CGFloat)fontSize;
+ (UIFont *)textFontRoundedInSizeOf:(CGFloat)fontSize;

@end;
