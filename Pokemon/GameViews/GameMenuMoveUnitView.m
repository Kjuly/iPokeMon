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
@synthesize type2 = type2_;
@synthesize pp    = pp_;
@synthesize viewButton = viewButton_;

-(void)dealloc
{
//  [name_  release];
//  [type1_ release];
//  [type2_ release];
//  [pp_    release];
//  [viewButton_ release];
  
  self.name  = nil;
  self.type1 = nil;
  self.type2 = nil;
  self.pp    = nil;
  self.viewButton = nil;
  
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    CGFloat const typeWidth     = 40.0f;
    CGFloat const labelHeight   = frame.size.height / 2.0f;
    CGFloat const ppLabelWidth  = 30.0f;
    
    CGRect  const type1Frame   = CGRectMake(10.0f, 0.0f, typeWidth, labelHeight);
    CGRect  const type2Frame   = CGRectMake(10.0f, labelHeight, typeWidth, labelHeight);
    CGRect  const nameFrame    = CGRectMake(10.0f + typeWidth, 0.0f, self.frame.size.width - typeWidth - 20.0f, labelHeight);
    CGRect  const ppLabelFrame = CGRectMake(typeWidth, labelHeight, ppLabelWidth, labelHeight);
    CGRect  const ppFrame      = CGRectMake(typeWidth + ppLabelWidth, labelHeight, self.frame.size.width - typeWidth - ppLabelWidth - 10.0f, labelHeight);
    CGRect  const viewButtonFrame = CGRectMake(10.0f, 0.0f, frame.size.width, frame.size.height);
    
    type1_ = [[UILabel alloc] initWithFrame:type1Frame];
    [type1_ setBackgroundColor:[UIColor clearColor]];
    [self addSubview:type1_];
    
    type2_ = [[UILabel alloc] initWithFrame:type2Frame];
    [type2_ setBackgroundColor:[UIColor clearColor]];
    [self addSubview:type2_];
    
    name_ = [[UILabel alloc] initWithFrame:nameFrame];
    [name_ setBackgroundColor:[UIColor clearColor]];
    [name_ setTextColor:[GlobalRender textColorOrange]];
    [name_ setFont:[GlobalRender textFontBoldInSizeOf:14.0f]];
    [self addSubview:name_];
    
    UILabel * ppLabel = [[UILabel alloc] initWithFrame:ppLabelFrame];
    [ppLabel setBackgroundColor:[UIColor clearColor]];
    [ppLabel setTextAlignment:UITextAlignmentRight];
    [ppLabel setTextColor:[GlobalRender textColorBlue]];
    [ppLabel setFont:[GlobalRender textFontBoldInSizeOf:13.0f]];
    [ppLabel setText:NSLocalizedString(@"kLabelPP", nil)];
    [self addSubview:ppLabel];
    [ppLabel release];
    
    pp_ = [[UILabel alloc] initWithFrame:ppFrame];
    [pp_ setBackgroundColor:[UIColor clearColor]];
    [pp_ setTextAlignment:UITextAlignmentRight];
    [pp_ setTextColor:[GlobalRender textColorOrange]];
    [pp_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
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
