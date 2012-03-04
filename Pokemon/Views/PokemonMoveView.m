//
//  PokemonMoveView.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonMoveView.h"

#import "GlobalRender.h"

@implementation PokemonMoveView

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
    CGFloat const typeWidth   = 64.0f;
    CGFloat const labelHeight = frame.size.height - 10.0f;
    
    CGRect  const type1Frame  = CGRectMake(10.0f, 0.0f, typeWidth, labelHeight);
    CGRect  const type2Frame  = CGRectMake(10.0f, labelHeight, typeWidth, labelHeight);
    CGRect  const nameFrame   = CGRectMake(10.0f + typeWidth, 5.0f, frame.size.width - typeWidth - 80.0f, labelHeight);
    CGRect  const ppFrame     = CGRectMake(nameFrame.origin.x + nameFrame.size.width, 5.0f, 60.0f, labelHeight);
    CGRect  const viewButtonFrame = CGRectMake(10.0f, 0.0f, frame.size.width, frame.size.height);
    
    type1_ = [[UILabel alloc] initWithFrame:type1Frame];
    [type1_ setBackgroundColor:[UIColor clearColor]];
    [type1_ setTextColor:[GlobalRender textColorNormal]];
    [type1_ setTextAlignment:UITextAlignmentCenter];
    [self addSubview:type1_];
    
    type2_ = [[UILabel alloc] initWithFrame:type2Frame];
    [type2_ setTextColor:[GlobalRender textColorNormal]];
    [type2_ setBackgroundColor:[UIColor clearColor]];
    [type2_ setTextAlignment:UITextAlignmentCenter];
    [self addSubview:type2_];
    
    name_ = [[UILabel alloc] initWithFrame:nameFrame];
    [name_ setBackgroundColor:[UIColor clearColor]];
    [name_ setTextColor:[GlobalRender textColorOrange]];
    [name_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
    [self addSubview:name_];
    
    pp_ = [[UILabel alloc] initWithFrame:ppFrame];
    [pp_ setBackgroundColor:[UIColor clearColor]];
    [pp_ setTextAlignment:UITextAlignmentRight];
    [pp_ setTextColor:[GlobalRender textColorTitleWhite]];
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
