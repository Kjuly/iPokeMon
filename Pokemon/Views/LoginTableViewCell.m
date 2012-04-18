//
//  BagTableViewCell.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "LoginTableViewCell.h"

@implementation LoginTableViewCell

- (void)dealloc {
  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Basic constants
    CGFloat const cellHeight = kCellHeightOfLoginTableView;
    CGFloat const cellWidth  = kViewWidth;
    CGRect  const cellFrame  = CGRectMake(0.f, 0.f, cellWidth, cellHeight);
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:cellFrame];
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
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Custom subviews for cell
  CGFloat imageSize  = 32.f;
  CGFloat marginLeft = 35.f;
  CGRect imageViewFrame = CGRectMake(marginLeft, (kCellHeightOfLoginTableView - imageSize) / 2, imageSize, imageSize);
  CGRect textLabelFrame = CGRectMake(marginLeft + imageSize + 20.f, 0.f, 200.f, kCellHeightOfLoginTableView);
  
  [self.textLabel setFrame:textLabelFrame];
  [self.textLabel setTextColor:[UIColor whiteColor]];
  [self.imageView setFrame:imageViewFrame];
}

// Configure cell
- (void)configureCellWithTitle:(NSString *)title
                          icon:(UIImage *)icon
                 accessoryType:(UITableViewCellAccessoryType)accessoryType {
  [self.textLabel setText:title];
  [self.imageView setImage:icon];
  [self setAccessoryType:accessoryType];
}

@end
