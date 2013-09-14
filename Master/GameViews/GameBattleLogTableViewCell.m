//
//  BagTableViewCell.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameBattleLogTableViewCell.h"

#import "GlobalRender.h"
#import "MEWRoundView.h"


@interface GameBattleLogTableViewCell () {
 @private
  BOOL logWordsMore_;
}

@end


@implementation GameBattleLogTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Basic constants
    CGFloat const cellHeight = kCellHeightOfGameBattleLogTableView;
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
//    CGFloat buttonSize = 64.f;
//    CGRect exchangeButtonFrame = CGRectMake(0.f, (kCellHeightOfCurrencyExchange - buttonSize) / 2.f, buttonSize, buttonSize);
//    exchangeButton_ = [[UIButton alloc] initWithFrame:exchangeButtonFrame];
//    [exchangeButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
//                               forState:UIControlStateNormal];
//    [exchangeButton_ setImage:[UIImage imageNamed:kPMINMainButtonConfirmOpposite]
//                     forState:UIControlStateNormal];
//    [self setAccessoryType:UITableViewCellAccessoryNone];
//    [self setAccessoryView:exchangeButton_];
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
  CGFloat marginLeft = 50.f;
  CGFloat marginTop  = (kCellHeightOfGameBattleLogTableView - 32.f) / 2.f;
  CGRect textLabelFrame  = CGRectMake(marginLeft, marginTop, kViewWidth - marginLeft, 32.f);
//  CGRect priceLabelFrame = CGRectMake(textLabelFrame.origin.x, marginTop + textLabelFrame.size.height, 200.f, 32.f);
  
  // log
  [self.textLabel setFrame:textLabelFrame];
  [self.textLabel setBackgroundColor:[UIColor clearColor]];
  [self.textLabel setTextColor:[GlobalRender textColorTitleWhite]];
  [self.textLabel setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  
  if (logWordsMore_) {
    [self.textLabel setNumberOfLines:0];
    [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.textLabel sizeToFit];
  }
  
  // description
//  [self.detailTextLabel setFrame:priceLabelFrame];
//  [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
//  [self.detailTextLabel setTextColor:[GlobalRender textColorBlue]];
//  [self.detailTextLabel setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  
  // icon
//  [self.imageView setFrame:imageViewFrame];
}

#pragma mark - Public Methods

// Configure cell
- (void)configureCellWithType:(MEWGameBattleLogType)type
                          log:(NSString *)log
                  description:(NSString *)description
                          odd:(BOOL)odd{
  logWordsMore_ = NO;
  [self.textLabel setText:log];
  if ([log length] > 30)
    logWordsMore_ = YES;
  [self.detailTextLabel setText:description];
  
  // log type marker
  CGFloat const typeMarkerSize = 16.f;
  CGFloat const margin = (kCellHeightOfGameBattleLogTableView - typeMarkerSize) / 2.f;
  CGRect const typeMarkerFrame = CGRectMake(margin, margin, typeMarkerSize, typeMarkerSize);
  MEWRoundView * typeMarker = [MEWRoundView alloc];
  switch (type) {
    case kMEWGameBattleLogTypePlayerPMAttack:
      (void)[typeMarker initWithFrame:typeMarkerFrame
                      foregroundColor:kColorTypeBlue
                      foregroundAlpha:1.f
                      backgroundColor:kColorTypeWhite
                      backgroundAlpha:.95f];
      break;
      
    case kMEWGameBattleLogTypeEnemyPMAttack:
      (void)[typeMarker initWithFrame:typeMarkerFrame
                      foregroundColor:kColorTypeRed
                      foregroundAlpha:1.f
                      backgroundColor:kColorTypeWhite
                      backgroundAlpha:.95f];
      break;
      
    case kMEWGameBattleLogTypeNormal:
    default:
      (void)[typeMarker initWithFrame:typeMarkerFrame
                      foregroundColor:kColorTypeGray
                      foregroundAlpha:1.f
                      backgroundColor:kColorTypeWhite
                      backgroundAlpha:.95f];
      break;
  }
  [self.contentView addSubview:typeMarker];
  
  if (odd) {
    [self.backgroundView setBackgroundColor:[UIColor clearColor]];
  }
  else {
    [self.backgroundView setBackgroundColor:[UIColor blackColor]];
    [self.backgroundView setAlpha:.1f];
  }
}

@end
