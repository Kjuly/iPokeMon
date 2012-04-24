//
//  GameMenuMoveUnitView.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuMoveUnitView.h"

#import "GlobalRender.h"

@implementation GameMenuMoveUnitView

@synthesize name  = name_;
@synthesize type1 = type1_;
@synthesize pp    = pp_;
@synthesize viewButton = viewButton_;

-(void)dealloc {
  self.name  = nil;
  self.type1 = nil;
  self.pp    = nil;
  self.viewButton = nil;
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    CGFloat const typeWidth     = 60.f;
    CGFloat const labelHeight   = 32.f;
    
    CGRect  const type1Frame  = CGRectMake(10.f, 20.f, typeWidth, labelHeight);
    CGRect  const nameFrame   = CGRectMake(20.f + typeWidth,   20.f, frame.size.width - typeWidth - 20.f, labelHeight);
    CGRect  const ppFrame     = CGRectMake(nameFrame.origin.x, 20.f + labelHeight, 60.f, labelHeight);
    CGRect  const viewButtonFrame = CGRectMake(10.f, 0.f, frame.size.width, frame.size.height);
    
    type1_ = [[UILabel alloc] initWithFrame:type1Frame];
    [type1_ setBackgroundColor:[UIColor clearColor]];
    [type1_ setTextAlignment:UITextAlignmentRight];
    [type1_ setTextColor:[GlobalRender textColorNormal]];
    [type1_ setFont:[GlobalRender textFontBoldInSizeOf:12.f]];
    [self addSubview:type1_];
    
    name_ = [[UILabel alloc] initWithFrame:nameFrame];
    [name_ setBackgroundColor:[UIColor clearColor]];
    [name_ setTextAlignment:UITextAlignmentLeft];
    [name_ setTextColor:[GlobalRender textColorOrange]];
    [name_ setFont:[GlobalRender textFontBoldInSizeOf:24.f]];
    [self addSubview:name_];
    
    pp_ = [[UILabel alloc] initWithFrame:ppFrame];
    [pp_ setBackgroundColor:[UIColor clearColor]];
    [pp_ setTextAlignment:UITextAlignmentLeft];
    [pp_ setTextColor:[GlobalRender textColorOrange]];
    [pp_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [self addSubview:pp_];
    
    viewButton_ = [[UIButton alloc] initWithFrame:viewButtonFrame];
    [viewButton_ setBackgroundColor:[UIColor clearColor]];
    [self addSubview:viewButton_];
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

@end
