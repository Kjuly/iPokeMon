//
//  MEWRoundView.m
//  iPokeMon
//
//  Created by Kaijie Yu on 5/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MEWRoundView.h"

#import "GlobalRender.h"

@interface MEWRoundView () {
 @private
  ColorType foregroundColor_;
  CGFloat   foregroundAlpha_;
  ColorType backgroundColor_;
  CGFloat   backgroundAlpha_;
}

@end

@implementation MEWRoundView

- (id)initWithFrame:(CGRect)frame
    foregroundColor:(ColorType)foregroundColor
    foregroundAlpha:(CGFloat)foregroundAlpha
    backgroundColor:(ColorType)backgroundColor
    backgroundAlpha:(CGFloat)backgroundAlpha
{
  foregroundColor_ = foregroundColor;
  foregroundAlpha_ = foregroundAlpha;
  backgroundColor_ = backgroundColor;
  backgroundAlpha_ = backgroundAlpha;
  return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  // background
  [[GlobalRender colorWithColorType:backgroundColor_
                              alpha:backgroundAlpha_] setFill];
  [[UIBezierPath bezierPathWithOvalInRect:rect] fill];
  
  // foreground
  [[GlobalRender colorWithColorType:foregroundColor_
                              alpha:foregroundAlpha_] setFill];
  CGFloat margin = rect.size.width * .1f;
  CGRect foregroundRect = rect;
  foregroundRect.origin.x    += margin;
  foregroundRect.origin.y    += margin;
  foregroundRect.size.width  -= margin * 2;
  foregroundRect.size.height -= margin * 2;
  [[UIBezierPath bezierPathWithOvalInRect:foregroundRect] fill];
}

@end
