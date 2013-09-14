//
//  BagTableViewCell.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemTableViewCell.h"

#import "GlobalRender.h"

@implementation BagItemTableViewCell

@synthesize imageView = imageView_;
@synthesize name      = name_;
@synthesize quantity  = quantity_;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight     = kCellHeightOfBagItemTableView;
    CGFloat const cellWidth      = kViewWidth;
    CGFloat const imageWidth     = 30.f; 
    CGFloat const titleHeight    = 30.f;
    
    CGRect imageViewFrame = CGRectMake(25.f, 17.f, imageWidth, imageWidth);
    CGRect nameFrame      = CGRectMake(imageWidth + 20.f, 17.f, 170.f, titleHeight);
    CGRect symbalFrame    = CGRectMake(imageWidth + 190.f, 17.f, 15.f, titleHeight);
    CGRect quantityFrame  = CGRectMake(imageWidth + 205.f, 17.f, 60.f, titleHeight);
    
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
    
    // Set layouts for |contentView|(readonly)
    // Set Image View
    imageView_ = [[UIImageView alloc] initWithFrame:imageViewFrame];
    [imageView_ setUserInteractionEnabled:YES];
    [imageView_ setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:imageView_];
    
    // Name
    name_ = [[UILabel alloc] initWithFrame:nameFrame];
    [name_ setBackgroundColor:[UIColor clearColor]];
    [name_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [name_ setTextColor:[GlobalRender textColorTitleWhite]];
    [self.contentView addSubview:name_];
    
    // Symbal
    UILabel * symbal = [[UILabel alloc] initWithFrame:symbalFrame];
    [symbal setBackgroundColor:[UIColor clearColor]];
    [symbal setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [symbal setTextColor:[UIColor whiteColor]];
    [symbal setText:@"X"];
    [self.contentView addSubview:symbal];
    
    // Quantity
    quantity_ = [[UILabel alloc] initWithFrame:quantityFrame];
    [quantity_ setBackgroundColor:[UIColor clearColor]];
    [quantity_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [quantity_ setTextColor:[GlobalRender textColorOrange]];
    [quantity_ setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:quantity_];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
