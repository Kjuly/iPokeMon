//
//  BagTableViewCell.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagTableViewCell.h"

@implementation BagTableViewCell

@synthesize imageView     = imageView_;
@synthesize labelTitle    = labelTitle_;

- (void)dealloc
{
  [imageView_     release];
  [labelTitle_    release];
  
  self.imageView     = nil;
  self.labelTitle    = nil;
  
  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight     = 52.5f;
    CGFloat const cellWidth      = 320.0;
    CGFloat const imageWidth     = 30.0; 
    CGFloat const titleHeight    = 30.0;
    CGFloat const titleWidth     = cellWidth - imageWidth;
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cellWidth, cellHeight)];
    [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BagTableViewCellBackground.png"]]];
    [self setBackgroundView:backgroundView];
    [backgroundView release];
    
    // Set layouts for |contentView|(readonly)
    // Set Image View
    imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(25.0f, 11.0f, imageWidth, imageWidth)];
    [imageView_ setUserInteractionEnabled:YES];
    [imageView_ setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:imageView_];
    
    // Set Title Label
    labelTitle_ = [[UILabel alloc] initWithFrame:CGRectMake(imageWidth + 50.0f, 11.0f, titleWidth, titleHeight)];
    [labelTitle_ setBackgroundColor:[UIColor clearColor]];
    [labelTitle_ setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.0f]];
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
