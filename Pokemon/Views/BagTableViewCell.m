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
    // Initialization code
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
