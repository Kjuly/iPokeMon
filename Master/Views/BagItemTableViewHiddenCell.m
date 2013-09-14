//
//  BagItemTableViewHiddenCell.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemTableViewHiddenCell.h"

#import "GlobalRender.h"

@interface BagItemTableViewHiddenCell () {
 @private
  UIButton * quantityButton_;
}

@property (nonatomic, strong) UIButton * quantityButton;

@end

@implementation BagItemTableViewHiddenCell

@synthesize delegate = delegate_;
@synthesize use      = use_;
@synthesize give     = give_;
@synthesize toss     = toss_;
@synthesize info     = info_;
@synthesize cancel   = cancel_;

@synthesize quantityButton = quantityButton_;

- (void)dealloc {
  self.delegate = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Constans
    CGFloat const cellHeight   = kCellHeightOfBagItemTableView;
    CGFloat const cellWidth    = kViewWidth;
    CGFloat const buttonHeight = cellHeight;
    CGFloat const buttonWidth  = cellWidth / 5.f;
    
    CGRect const useFrame    = CGRectMake(0.f,             0.f, buttonWidth, buttonHeight);
    CGRect const giveFrame   = CGRectMake(buttonWidth,     0.f, buttonWidth, buttonHeight);
    CGRect const tossFrame   = CGRectMake(buttonWidth * 2, 0.f, buttonWidth, buttonHeight);
    CGRect const infoFrame   = CGRectMake(buttonWidth * 3, 0.f, buttonWidth, buttonHeight);
    CGRect const cancelFrame = CGRectMake(buttonWidth * 4, 0.f, buttonWidth, buttonHeight);
    
    // Set |backgroundView| for Cell
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, cellWidth, cellHeight)];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    [backgroundView setAlpha:.95f];
    [self setBackgroundView:backgroundView];
    
    // Buttons
    use_ = [[UIButton alloc] initWithFrame:useFrame];
    [use_ setImage:[UIImage imageNamed:kPMINIconBagItemUse] forState:UIControlStateNormal];
    [use_ addTarget:self.delegate action:@selector(useItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:use_];
    
    give_ = [[UIButton alloc] initWithFrame:giveFrame];
    [give_ setImage:[UIImage imageNamed:kPMINIconBagItemGive] forState:UIControlStateNormal];
    [give_ addTarget:self.delegate action:@selector(giveItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:give_];
    
    toss_ = [[UIButton alloc] initWithFrame:tossFrame];
    [toss_ setImage:[UIImage imageNamed:kPMINIconBagItemToss] forState:UIControlStateNormal];
    [toss_ addTarget:self.delegate action:@selector(tossItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:toss_];
    
    info_ = [[UIButton alloc] initWithFrame:infoFrame];
    [info_ setImage:[UIImage imageNamed:kPMINIconBagItemInfo] forState:UIControlStateNormal];
    [info_ addTarget:self.delegate action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:info_];
    
    cancel_ = [[UIButton alloc] initWithFrame:cancelFrame];
    [cancel_ setImage:[UIImage imageNamed:kPMINIconBagItemCancel] forState:UIControlStateNormal];
    [cancel_ addTarget:self.delegate action:@selector(cancelHiddenCell:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancel_];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)addQuantity:(NSInteger)quantity
        withOffsetX:(CGFloat)offsetX {
  CGRect quantityFrame = CGRectMake(offsetX, 0.f, 98.f, kCellHeightOfBagItemTableView);
  UIButton * quantityButton = [[UIButton alloc] initWithFrame:quantityFrame];
  [quantityButton setBackgroundColor:
    [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINStoreItemQuantityButtonBackground]]];
  [quantityButton setOpaque:NO];
  [quantityButton setTitleColor:[GlobalRender textColorOrange] forState:UIControlStateNormal];
  [quantityButton.titleLabel setFont:[GlobalRender textFontBoldInSizeOf:24.f]];
  [quantityButton addTarget:self.delegate
                     action:@selector(changeItemQuantity:)
           forControlEvents:UIControlEventTouchUpInside];
  self.quantityButton = quantityButton;
  [self addSubview:self.quantityButton];
  
  [self updateQuantity:quantity];
}

- (void)updateQuantity:(NSInteger)quantity {
  [self.quantityButton setTitle:[NSString stringWithFormat:@"%d", quantity]
                       forState:UIControlStateNormal];
}

@end
