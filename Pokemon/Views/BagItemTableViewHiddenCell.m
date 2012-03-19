//
//  BagItemTableViewHiddenCell.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemTableViewHiddenCell.h"

@implementation BagItemTableViewHiddenCell

@synthesize delegate = delegate_;
@synthesize use      = use_;
@synthesize give     = give_;
@synthesize toss     = toss_;
@synthesize cancel   = cancel_;

- (void)dealloc
{
  self.delegate = nil;
  self.use      = nil;
  self.give     = nil;
  self.toss     = nil;
  self.cancel   = nil;
  
  [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight   = kCellHeightOfBagItemTableView;
    CGFloat const cellWidth    = kViewWidth;
    CGFloat const buttonHeight = cellHeight;
    CGFloat const buttonWidth  = cellWidth / 4.f;
    
    CGRect const useFrame    = CGRectMake(0.f,             0.f, buttonWidth, buttonHeight);
    CGRect const giveFrame   = CGRectMake(buttonWidth,     0.f, buttonWidth, buttonHeight);
    CGRect const tossFrame   = CGRectMake(buttonWidth * 2, 0.f, buttonWidth, buttonHeight);
    CGRect const cancelFrame = CGRectMake(buttonWidth * 3, 0.f, buttonWidth, buttonHeight);
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self setBackgroundView:backgroundView];
    [backgroundView release];
    
    // Buttons
    use_ = [[UIButton alloc] initWithFrame:useFrame];
    [use_ setImage:[UIImage imageNamed:@"BagItemTableViewHiddenCellButtonIconUse.png"] forState:UIControlStateNormal];
    [use_ addTarget:self.delegate action:@selector(useItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:use_];
    
    give_ = [[UIButton alloc] initWithFrame:giveFrame];
    [give_ setImage:[UIImage imageNamed:@"BagItemTableViewHiddenCellButtonIconGive.png"] forState:UIControlStateNormal];
    [give_ addTarget:self.delegate action:@selector(giveItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:give_];
    
    toss_ = [[UIButton alloc] initWithFrame:tossFrame];
    [toss_ setImage:[UIImage imageNamed:@"BagItemTableViewHiddenCellButtonIconToss.png"] forState:UIControlStateNormal];
    [toss_ addTarget:self.delegate action:@selector(tossItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:toss_];
    
    cancel_ = [[UIButton alloc] initWithFrame:cancelFrame];
    [cancel_ setImage:[UIImage imageNamed:@"BagItemTableViewHiddenCellButtonIconCancel.png"] forState:UIControlStateNormal];
    [cancel_ addTarget:self.delegate action:@selector(cancelHiddenCell:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancel_];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
