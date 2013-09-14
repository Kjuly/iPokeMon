//
//  BagTableViewCell.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "StoreItemTableViewCell.h"

#import "GlobalRender.h"

@implementation StoreItemTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight = kCellHeightOfStoreItemTableView;
    CGFloat const cellWidth  = kViewWidth;
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [backgroundView setBackgroundColor:
      [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTableViewCellBagItem]]];
    [backgroundView setOpaque:NO];
    [self setBackgroundView:backgroundView];
    
    // Set |selectedBackgroundView| for cell
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [selectedBackgroundView setBackgroundColor:
      [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTableViewCellBagItemSelected]]];
    [selectedBackgroundView setOpaque:NO];
    [self setSelectedBackgroundView:selectedBackgroundView];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  // Custom subviews for cell
  CGFloat const imageWidth  = 30.f;
  CGFloat const titleHeight = 30.f;
  
  CGRect imageViewFrame  = CGRectMake(25.f, 17.f, imageWidth, imageWidth);
  CGRect textLabelFrame  = CGRectMake(imageWidth + 20.f, 17.f, 170.f, titleHeight);
  CGRect priceLabelFrame = CGRectMake(imageWidth + 205.f, 17.f, 60.f, titleHeight);
  
  // title
  [self.textLabel setFrame:textLabelFrame];
  [self.textLabel setBackgroundColor:[UIColor clearColor]];
  [self.textLabel setTextColor:[GlobalRender textColorTitleWhite]];
  [self.textLabel setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  
  // price
  [self.detailTextLabel setFrame:priceLabelFrame];
  [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
  [self.detailTextLabel setTextColor:[GlobalRender textColorBlue]];
  [self.detailTextLabel setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  
  // icon
  [self.imageView setFrame:imageViewFrame];
}

#pragma mark - Public Methods

- (void)configureCellWithTitle:(NSString *)title
                         price:(NSString *)price
                          icon:(UIImage *)icon {
  if (price == nil)
    return;
  if ([price isEqualToString:@"0"])
    price = @"- - -";
  [self.textLabel setText:title];
  [self.detailTextLabel setText:price];
  [self.imageView setImage:icon];
}

@end
