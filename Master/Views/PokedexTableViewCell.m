//
//  PokedexTableViewCell.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokedexTableViewCell.h"

#import "GlobalRender.h"

@implementation PokedexTableViewCell

@synthesize imageView     = imageView_;
@synthesize labelTitle    = labelTitle_;
@synthesize labelSubtitle = labelSubtitle_;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight     = kCellHeightOfPokedexTableView;
    CGFloat const cellWidth      = kViewWidth;
    CGFloat const imageWidth     = 60.f; 
    CGFloat const titleHeight    = 30.f;
    CGFloat const titleWidth     = cellWidth - imageWidth;
    CGFloat const subtitleHeight = 30.f;
    CGFloat const subtitleWidth  = titleWidth;
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [backgroundView setBackgroundColor:
      [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTableViewCellPokedex]]];
    [backgroundView setOpaque:NO];
    [self setBackgroundView:backgroundView];
    
    // Set |selectedBackgroundView| for cell
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [selectedBackgroundView setBackgroundColor:
      [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTableViewCellPokedexSelected]]];
    [selectedBackgroundView setOpaque:NO];
    [self setSelectedBackgroundView:selectedBackgroundView];
    
    // Set layouts for |contentView|(readonly)
    // Set Image View
    imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(5.f, 5.f, imageWidth, imageWidth)];
    [imageView_ setUserInteractionEnabled:YES];
    [self.contentView addSubview:imageView_];
    
    // Set Title Label
    labelTitle_ = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth + 20.f, 5.f, titleWidth, titleHeight)];
    [labelTitle_ setBackgroundColor:[UIColor clearColor]];
    [labelTitle_ setTextColor:[GlobalRender textColorOrange]];
    [labelTitle_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
    [self.contentView addSubview:labelTitle_];
    
    // Set Subtitle Label
    labelSubtitle_ = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth + 20.f, titleHeight, subtitleWidth, subtitleHeight)];
    [labelSubtitle_ setBackgroundColor:[UIColor clearColor]];
    [labelSubtitle_ setTextColor:[GlobalRender textColorTitleWhite]];
    [labelSubtitle_ setFont:[GlobalRender textFontBoldInSizeOf:12.f]];
    [labelSubtitle_ setTextColor:[UIColor grayColor]];
    [self.contentView addSubview:labelSubtitle_];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
