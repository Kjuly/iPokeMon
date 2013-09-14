//
//  SettingSectionHeaderView.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/23/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingSectionHeaderView.h"

#import "GlobalRender.h"

@implementation SettingSectionHeaderView

@synthesize title = title_;


- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setBackgroundColor:
     [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTableViewHeaderSetting]]];
    [self setOpaque:NO];
    title_ = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 5.f, 300.f, 22.f)];
    [title_ setBackgroundColor:[UIColor clearColor]];
    [title_ setTextColor:[UIColor blackColor]];
    [title_ setFont:[GlobalRender textFontBoldItalicInSizeOf:14.f]];
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
