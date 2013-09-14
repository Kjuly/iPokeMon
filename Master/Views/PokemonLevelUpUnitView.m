//
//  PokemonLevelUpUnitView.m
//  iPokeMon
//
//  Created by Kaijie Yu on 4/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonLevelUpUnitView.h"

#import "GlobalRender.h"

@implementation PokemonLevelUpUnitView

@synthesize name       = name_;
@synthesize value      = value_;
@synthesize deltaValue = deltaValue_;


- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    CGFloat const labelHeight     = frame.size.height;
    CGFloat const labelWidth      = 160.0f;
    CGFloat const valueHeight     = labelHeight;
    CGFloat const plusSymbolWidth = 30.f;
    CGFloat const deltaValueWidth = 60.f;
    CGFloat const valueWidth      = frame.size.width - labelWidth - deltaValueWidth - plusSymbolWidth;
    
    CGRect const nameFrame       = CGRectMake(0.f,                                       0.f, labelWidth, labelHeight);
    CGRect const valueFrame      = CGRectMake(labelWidth,                                0.f, valueWidth, valueHeight);
    CGRect const plusSymbolFrame = CGRectMake(labelWidth + valueWidth,                   0.f, plusSymbolWidth, valueHeight);
    CGRect const deltaValueFrame = CGRectMake(labelWidth + valueWidth + plusSymbolWidth, 0.f, deltaValueWidth, valueHeight);
    
    name_ = [[UILabel alloc] initWithFrame:nameFrame];
    [name_ setBackgroundColor:[UIColor clearColor]];
    [name_ setTextColor:[GlobalRender textColorTitleWhite]];
    [name_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
    [name_ setTextAlignment:NSTextAlignmentRight];
    [self addSubview:name_];
    
    value_ = [[UILabel alloc] initWithFrame:valueFrame];
    [value_ setBackgroundColor:[UIColor clearColor]];
    [value_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
    [value_ setTextColor:[GlobalRender textColorOrange]];
    [value_ setTextAlignment:NSTextAlignmentRight];
    [self addSubview:value_];
    
    UILabel * plusSymbol = [[UILabel alloc] initWithFrame:plusSymbolFrame];
    [plusSymbol setBackgroundColor:[UIColor clearColor]];
    [plusSymbol setTextColor:[GlobalRender textColorTitleWhite]];
    [plusSymbol setFont:[GlobalRender textFontNormalInSizeOf:16.f]];
    [plusSymbol setTextAlignment:NSTextAlignmentCenter];
    [plusSymbol setText:@"+"];
    [self addSubview:plusSymbol];
    
    deltaValue_ = [[UILabel alloc] initWithFrame:deltaValueFrame];
    [deltaValue_ setBackgroundColor:[UIColor clearColor]];
    [deltaValue_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
    [deltaValue_ setTextColor:[GlobalRender textColorTitleWhite]];
    [deltaValue_ setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:deltaValue_];
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

// |deltaWidth| > 0, increase |name| width, decrease |value| width;
//              < 0, decrease |name| width, increase |value| width;
- (void)adjustNameLabelWidthWith:(CGFloat)deltaWidth {
  CGRect nameFrame  = self.name.frame;
  CGRect valueFrame = self.value.frame;
  nameFrame.size.width  += deltaWidth;
  valueFrame.origin.x   += deltaWidth;
  valueFrame.size.width -= deltaWidth;
  [self.name  setFrame:nameFrame];
  [self.value setFrame:valueFrame];
}

@end
