//
//  BagItemTableViewHiddenCell.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemTableViewHiddenCell.h"

@implementation BagItemTableViewHiddenCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight = kCellHeightOfBagItemTableView;
    CGFloat const cellWidth  = kViewWidth;
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundView:backgroundView];
    [backgroundView release];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
