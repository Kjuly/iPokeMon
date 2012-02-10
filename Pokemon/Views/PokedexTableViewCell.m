//
//  PokedexTableViewCell.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokedexTableViewCell.h"

@implementation PokedexTableViewCell

@synthesize imageView     = imageView_;
@synthesize labelTitle    = labelTitle_;
@synthesize labelSubtitle = labelSubtitle_;

- (void)dealloc
{
  [imageView_     release];
  [labelTitle_    release];
  [labelSubtitle_ release];
  
  self.imageView     = nil;
  self.labelTitle    = nil;
  self.labelSubtitle = nil;
  
  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight     = 70.0;
    CGFloat const cellWidth      = 320.0;
    CGFloat const imageWidth     = 70.0; 
    CGFloat const titleHeight    = 30.0;
    CGFloat const titleWidth     = cellWidth - imageWidth;
    CGFloat const subtitleHeight = 30.0f;
    CGFloat const subtitleWidth  = titleWidth;
    
    // Set Cell Frame
    [self setFrame:CGRectMake(0.0f, 0.0f, cellWidth, cellHeight)];
    
    // Set Image View
    imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageWidth, cellHeight)];
    [imageView_ setUserInteractionEnabled:YES];
    [self.contentView addSubview:imageView_];
    
    // Set Title Label
    labelTitle_ = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth + 5.0f, 0.0f, titleWidth, titleHeight)];
    [labelTitle_ setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:labelTitle_];
    
    // Set Subtitle Label
    labelSubtitle_ = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth + 5.0f, titleHeight, subtitleWidth, subtitleHeight)];
    [labelSubtitle_ setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:labelSubtitle_];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
