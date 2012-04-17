//
//  BagTableViewCell.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingTableViewCellStyleTitle.h"

#import "GlobalRender.h"


@interface SettingTableViewCellStyleTitle () {
 @private
  UILabel * title_;
}

@property (nonatomic, retain) UILabel * title;

@end


@implementation SettingTableViewCellStyleTitle

@synthesize title = title_;

- (void)dealloc {
  self.title = nil;
  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Basic constants
    CGFloat const cellHeight = kCellHeightOfSettingTableView;
    CGFloat const cellWidth  = kViewWidth;
    CGRect  const cellFrame  = CGRectMake(0.f, 0.f, cellWidth, cellHeight);
    
    [self setFrame:cellFrame];
    [self.contentView setFrame:cellFrame];
//    [self.contentView setBackgroundColor:[UIColor blueColor]];
    
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
    
    
    // Subviews' related constants
//    CGFloat const margin      = 30.f;
//    CGFloat const labelHeight = 34.f;
//    CGFloat const titleWidth  = 150.f;
//    CGFloat const valueWidth  = cellWidth - margin * 2 - titleWidth;
//    CGRect titleFrame = CGRectMake(margin, 5.f, titleWidth, labelHeight);
    
    // Set layouts for |contentView|(readonly)
    // Set Title Label
//    title_ = [[UILabel alloc] initWithFrame:titleFrame];
//    [title_ setBackgroundColor:[UIColor clearColor]];
//    [title_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
//    [title_ setTextColor:[GlobalRender textColorTitleWhite]];
//    [self.contentView addSubview:title_];
    
    
    // Custom subviews for cell
    [self.textLabel setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [self.textLabel setTextColor:[GlobalRender textColorTitleWhite]];
    
    [self.detailTextLabel setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
    [self.detailTextLabel setTextColor:[GlobalRender textColorOrange]];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)configureCellWithTitle:(NSString *)title
                         value:(NSString *)value
                 accessoryType:(UITableViewCellAccessoryType)accessoryType {
  [self.textLabel setText:title];
  [self.detailTextLabel setText:value];
  [self setAccessoryType:accessoryType];
}

@end
