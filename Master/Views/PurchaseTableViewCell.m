//
//  BagTableViewCell.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PurchaseTableViewCell.h"

#import "GlobalRender.h"

@implementation PurchaseTableViewCell

@synthesize exchangeButton = exchangeButton_;


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Basic constants
    CGFloat const cellHeight = kCellHeightOfCurrencyExchange;
    CGFloat const cellWidth  = kViewWidth;
    CGRect  const cellFrame  = CGRectMake(0.f, 0.f, cellWidth, cellHeight);
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:cellFrame];
    [backgroundView setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundView:backgroundView];
    
    // Set |selectedBackgroundView| for cell
//    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
//    [selectedBackgroundView setBackgroundColor:
//      [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTableViewCellBagSelected]]];
//    [selectedBackgroundView setOpaque:NO];
//    [self setSelectedBackgroundView:selectedBackgroundView];
//    [selectedBackgroundView release];
    
    // Button to exchange currency
    CGFloat buttonSize = 64.f;
    CGRect exchangeButtonFrame = CGRectMake(0.f, (kCellHeightOfCurrencyExchange - buttonSize) / 2.f, buttonSize, buttonSize);
    exchangeButton_ = [[UIButton alloc] initWithFrame:exchangeButtonFrame];
    [exchangeButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                               forState:UIControlStateNormal];
    [exchangeButton_ setImage:[UIImage imageNamed:kPMINMainButtonConfirmOpposite]
                     forState:UIControlStateNormal];
    [self setAccessoryType:UITableViewCellAccessoryNone];
    [self setAccessoryView:exchangeButton_];
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
  CGFloat imageSize  = 64.f;
  CGFloat marginLeft = 15.f;
  CGFloat marginTop  = self.accessoryView.frame.origin.y;
  CGRect imageViewFrame  = CGRectMake(marginLeft, (kCellHeightOfCurrencyExchange - imageSize) / 2, imageSize, imageSize);
  CGRect textLabelFrame  = CGRectMake(marginLeft + imageSize + 20.f, marginTop, 200.f, 32.f);
  CGRect priceLabelFrame = CGRectMake(textLabelFrame.origin.x, marginTop + textLabelFrame.size.height, 200.f, 32.f);
  
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

// Configure cell
- (void)configureCellWithTitle:(NSString *)title
                         price:(NSString *)price
                          icon:(UIImage *)icon
                           odd:(BOOL)odd {
  [self.textLabel setText:title];
  [self.detailTextLabel setText:price];
  [self.imageView setImage:icon];
  if (! odd) {
    [self.backgroundView setBackgroundColor:[UIColor blackColor]];
    [self.backgroundView setAlpha:.1f];
  }
}

@end
