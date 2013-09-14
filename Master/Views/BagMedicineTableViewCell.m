//
//  BagMedicineTableViewCell.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagMedicineTableViewCell.h"

#import "GlobalRender.h"

@implementation BagMedicineTableViewCell

@synthesize name = name_;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight     = kCellHeightOfBagTableView;
    CGFloat const cellWidth      = kViewWidth;
    CGFloat const titleHeight    = 30.f;
    CGFloat const titleWidth     = cellWidth;
    
    CGRect nameFrame = CGRectMake(0.f, 50.f, titleWidth, titleHeight);
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [backgroundView setBackgroundColor:[UIColor colorWithPatternImage:
                                        [UIImage imageNamed:kPMINTableViewCellBagMedicine]]];
    [backgroundView setOpaque:NO];
    [self setBackgroundView:backgroundView];
    
    // Set |selectedBackgroundView| for cell
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [selectedBackgroundView setBackgroundColor:[UIColor clearColor]];
    [selectedBackgroundView setOpaque:NO];
    [self setSelectedBackgroundView:selectedBackgroundView];
    
    // Set layouts for |contentView|(readonly)
    // Set name Label
    name_ = [[UILabel alloc] initWithFrame:nameFrame];
    [name_ setBackgroundColor:[UIColor clearColor]];
    [name_ setFont:[GlobalRender textFontBoldInSizeOf:22.0f]];
    [name_ setTextColor:[GlobalRender textColorTitleWhite]];
    [name_ setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:name_];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
