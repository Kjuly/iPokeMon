//
//  BagTableViewCell.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingTableViewCell.h"

#import "GlobalRender.h"


@implementation SettingTableViewCell

@synthesize labelTitle = labelTitle_;

- (void)dealloc {
  self.labelTitle = nil;
  
  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight  = kCellHeightOfSettingTableView;
    CGFloat const cellWidth   = kViewWidth; 
    CGFloat const titleHeight = 34.f;
    CGFloat const titleWidth  = 300.f;
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [backgroundView setBackgroundColor:
     [UIColor colorWithPatternImage:[UIImage imageNamed:@"SettingTableViewCellBackground.png"]]];
    [backgroundView setOpaque:NO];
    [self setBackgroundView:backgroundView];
    [backgroundView release];
    
    // Set |selectedBackgroundView| for cell
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [selectedBackgroundView setBackgroundColor:
     [UIColor colorWithPatternImage:[UIImage imageNamed:@"SettingTableViewCellBackground.png"]]];
    [selectedBackgroundView setOpaque:NO];
    [self setSelectedBackgroundView:selectedBackgroundView];
    [selectedBackgroundView release];
    
    // Set layouts for |contentView|(readonly)
    // Set Title Label
    labelTitle_ = [[UILabel alloc] initWithFrame:CGRectMake(30.f, 5.f, titleWidth, titleHeight)];
    [labelTitle_ setBackgroundColor:[UIColor clearColor]];
    [labelTitle_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [labelTitle_ setTextColor:[GlobalRender textColorOrange]];
    [self.contentView addSubview:labelTitle_];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
