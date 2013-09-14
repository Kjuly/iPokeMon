//
//  BagTableViewCell.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingTableViewCellStyleSlider.h"

#import "GlobalRender.h"

@implementation SettingTableViewCellStyleSlider

@synthesize slider = slider_;


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
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
    [self.textLabel setFrame:CGRectMake(10.f, 5.f, 80.f, 34.f)];
    [self.textLabel setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [self.textLabel setTextColor:[GlobalRender textColorTitleWhite]];
    
    // Switch Button
    slider_ = [[UISlider alloc] init];
    CGFloat sliderHeight = slider_.frame.size.height;
    [slider_ setFrame:CGRectMake(10.f, 10.f, cellWidth - 20.f, sliderHeight)];
    [self addSubview:slider_];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)configureCellWithTitle:(NSString *)title
                   sliderValue:(float)value {
  if (title != nil) {
    [self.textLabel setText:title];
    CGRect sliderFrame = self.slider.frame;
    CGFloat textLabelWidth = self.textLabel.frame.size.width;
    sliderFrame.origin.x += textLabelWidth;
    sliderFrame.size.width -= textLabelWidth;
    [self.slider setFrame:sliderFrame];
  }
  [self.slider setValue:value];
}

@end
