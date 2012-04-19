//
//  BagTableViewCell.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingTableViewCellStyleTitle.h"

#import "GlobalRender.h"


@implementation SettingTableViewCellStyleTitle

- (void)dealloc {
  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Basic constants
    CGFloat const cellHeight = kCellHeightOfSettingTableView;
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
    
    // Custom subviews for cell
    [self normalize];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - Public Methods

// Configure cell
- (void)configureCellWithTitle:(NSString *)title
                         value:(NSString *)value
                 accessoryType:(UITableViewCellAccessoryType)accessoryType {
  [self.textLabel setText:title];
  [self.detailTextLabel setText:value];
  [self setAccessoryType:accessoryType];
}

// Normalize cell
- (void)normalize {
  [self.textLabel setBackgroundColor:[UIColor clearColor]];
  [self.textLabel setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [self.textLabel setTextColor:[GlobalRender textColorTitleWhite]];
  
  [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
  [self.detailTextLabel setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
  [self.detailTextLabel setTextColor:[GlobalRender textColorOrange]];
}

// Highlight cell
- (void)highlight {
  [self.textLabel setTextColor:[GlobalRender textColorOrange]];
}

@end
