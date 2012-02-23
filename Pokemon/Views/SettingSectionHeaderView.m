//
//  SettingSectionHeaderView.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/23/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingSectionHeaderView.h"

#import "GlobalRender.h"

@implementation SettingSectionHeaderView

@synthesize title = title_;

- (void)dealloc
{
  self.title = nil;
  
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setBackgroundColor:[GlobalRender backgroundColorMain]];
    
    title_ = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 300.0f, 25.0f)];
    [title_ setBackgroundColor:[UIColor clearColor]];
    [title_ setTextColor:[UIColor whiteColor]];
    [title_ setFont:[GlobalRender textFontBoldItalicInSizeOf:13.0f]];
    
    [self addSubview:title_];
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
