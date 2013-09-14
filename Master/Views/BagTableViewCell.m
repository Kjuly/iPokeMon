//
//  BagTableViewCell.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagTableViewCell.h"

#import "GlobalRender.h"

@implementation BagTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Basic constants
    CGFloat const cellHeight = kCellHeightOfBagTableView;
    CGFloat const cellWidth  = kViewWidth;
    CGRect  const cellFrame  = CGRectMake(0.f, 0.f, cellWidth, cellHeight);
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:cellFrame];
    [backgroundView setBackgroundColor:
      [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTableViewCellBag]]];
    [backgroundView setOpaque:NO];
    [self setBackgroundView:backgroundView];
    
    // Set |selectedBackgroundView| for cell
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [selectedBackgroundView setBackgroundColor:
      [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTableViewCellBagSelected]]];
    [selectedBackgroundView setOpaque:NO];
    [self setSelectedBackgroundView:selectedBackgroundView];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Custom subviews for cell
  CGFloat imageSize  = 32.f;
  CGFloat marginLeft = 35.f;
  CGRect imageViewFrame = CGRectMake(marginLeft, (kCellHeightOfBagTableView - imageSize) / 2, imageSize, imageSize);
  CGRect textLabelFrame = CGRectMake(marginLeft + imageSize + 20.f, 2.f, 200.f, kCellHeightOfBagTableView - 4.f);
  
  [self.textLabel setFrame:textLabelFrame];
  [self.textLabel setBackgroundColor:[UIColor clearColor]];
  [self.textLabel setTextColor:[UIColor whiteColor]];
  [self.textLabel setFont:[GlobalRender textFontBoldInSizeOf:18.f]];
  [self.imageView setFrame:imageViewFrame];
}

#pragma mark - Public Methods

// Configure cell
- (void)configureCellWithTitle:(NSString *)title
                          icon:(UIImage *)icon
                 accessoryType:(UITableViewCellAccessoryType)accessoryType {
  [self.textLabel setText:title];
  [self.imageView setImage:icon];
  [self setAccessoryType:accessoryType];
}

@end
