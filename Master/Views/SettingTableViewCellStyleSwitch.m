//
//  BagTableViewCell.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingTableViewCellStyleSwitch.h"

#import "GlobalRender.h"

@implementation SettingTableViewCellStyleSwitch

@synthesize switchButton = switchButton_;


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
      [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTableViewCellSetting]]];
    [backgroundView setOpaque:NO];
    [self setBackgroundView:backgroundView];
    
    // Set |selectedBackgroundView| for cell
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [selectedBackgroundView setBackgroundColor:
      [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTableViewCellSettingSelected]]];
    [selectedBackgroundView setOpaque:NO];
    [self setSelectedBackgroundView:selectedBackgroundView];
    
    // Custom subviews for cell
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.textLabel setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [self.textLabel setTextColor:[GlobalRender textColorTitleWhite]];
    
    // Switch Button
    switchButton_ = [[UISwitch alloc] init];
    CGRect switchButtonFrame = switchButton_.frame;
    switchButtonFrame.origin.x = cellWidth - switchButtonFrame.size.width - 10.f;
    switchButtonFrame.origin.y = 10.f;
    [switchButton_ setFrame:switchButtonFrame];
    [self addSubview:switchButton_];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)configureCellWithTitle:(NSString *)title
                      switchOn:(BOOL)switchOn {
  [self.textLabel setText:title];
  [self.switchButton setOn:switchOn];
}

@end
