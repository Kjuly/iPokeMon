//
//  TrainerBadgesTableViewCell.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerBadgesTableViewCell.h"

#import <QuartzCore/QuartzCore.h>


@implementation TrainerBadgesTableViewCell

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
    CGFloat const cellHeight     = kCellHeightOfTrainerBadgesTableView;
    CGFloat const cellWidth      = kViewWidth;
    CGFloat const imageWidth     = 60.0f; 
    CGFloat const titleHeight    = 30.0f;
    CGFloat const titleWidth     = cellWidth - imageWidth;
    CGFloat const subtitleHeight = 30.0f;
    CGFloat const subtitleWidth  = titleWidth;
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cellWidth, cellHeight)];
    [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BagTableViewCellBackground.png"]]];
    [backgroundView setOpaque:NO];
    [self setBackgroundView:backgroundView];
    [backgroundView release];
    
    // Set layouts for |contentView|(readonly)
    // Set Image View
    imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, imageWidth, imageWidth)];
    [imageView_ setUserInteractionEnabled:YES];
    [imageView_.layer setMasksToBounds:YES];
    [imageView_.layer setCornerRadius:5.0f];
    [self.contentView addSubview:imageView_];
    
    // Set Title Label
    labelTitle_ = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth + 20.0f, 5.0f, titleWidth, titleHeight)];
    [labelTitle_ setBackgroundColor:[UIColor clearColor]];
    [labelTitle_ setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.0f]];
    [self.contentView addSubview:labelTitle_];
    
    // Set Subtitle Label
    labelSubtitle_ = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth + 20.0f, titleHeight, subtitleWidth, subtitleHeight)];
    [labelSubtitle_ setBackgroundColor:[UIColor clearColor]];
    [labelSubtitle_ setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12.0f]];
    [labelSubtitle_ setTextColor:[UIColor grayColor]];
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
