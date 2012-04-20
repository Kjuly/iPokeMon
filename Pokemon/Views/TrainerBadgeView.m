//
//  TrainerBadgeView.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerBadgeView.h"

#import "GlobalConstants.h"
#import "GlobalRender.h"


@interface TrainerBadgeView () {
 @private
  UILabel     * badgesLabel_;
  UIView      * badgesContainer_;
  UIImageView * badgeGoldIcon_;
  UIImageView * badgeSilverIcon_;
  UIImageView * badgeBronzeIcon_;
  UILabel     * badgeGoldCount_;
  UILabel     * badgeSilverCount_;
  UILabel     * badgeBronzeCount_;
}

@property (nonatomic, retain) UILabel     * badgesLabel;
@property (nonatomic, retain) UIView      * badgesContainer;
@property (nonatomic, retain) UIImageView * badgeGoldIcon;
@property (nonatomic, retain) UIImageView * badgeSilverIcon;
@property (nonatomic, retain) UIImageView * badgeBronzeIcon;
@property (nonatomic, retain) UILabel     * badgeGoldCount;
@property (nonatomic, retain) UILabel     * badgeSilverCount;
@property (nonatomic, retain) UILabel     * badgeBronzeCount;

@end

@implementation TrainerBadgeView

@synthesize badgesLabel      = badgesLabel_;
@synthesize badgesContainer  = badgesContainer_;
@synthesize badgeGoldIcon    = badgeGoldIcon_;
@synthesize badgeSilverIcon  = badgeSilverIcon_;
@synthesize badgeBronzeIcon  = badgeBronzeIcon_;
@synthesize badgeGoldCount   = badgeGoldCount_;
@synthesize badgeSilverCount = badgeSilverCount_;
@synthesize badgeBronzeCount = badgeBronzeCount_;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    CGFloat const labelHeight     = 30.f;
    CGFloat const labelWidth      = 105.f;
    CGFloat const valueHeight     = 30.f;
    CGFloat const iconSize        = 16.f;
    CGFloat const iconMarginTop   = (labelHeight - iconSize) / 2;
    CGFloat const badgeCountWidth = 32.f;
    
    CGRect badgesLabelFrame      = CGRectMake(0.f,  0.f, labelWidth, labelHeight);
    CGRect badgesContainerFrame  = CGRectMake(labelWidth, 0.f, frame.size.width, valueHeight);
    CGRect badgeGoldIconFrame    = CGRectMake(0.f, iconMarginTop, iconSize, iconSize);
    CGRect badgeGoldCountFrame   = CGRectMake(iconSize + 3.f, 0.f, labelHeight, badgeCountWidth);
    CGRect badgeSilverIconFrame  = CGRectMake(iconSize + 3.f + badgeCountWidth, iconMarginTop, iconSize, iconSize);
    CGRect badgeSilverCountFrame = CGRectMake(2 * (iconSize + 3.f) + badgeCountWidth, 0.f, labelHeight, badgeCountWidth);
    CGRect badgeBronzeIconFrame  = CGRectMake(2 * (iconSize + 3.f + badgeCountWidth), iconMarginTop, iconSize, iconSize);
    CGRect badgeBronzeCountFrame = CGRectMake(2 * (iconSize + 3.f + badgeCountWidth) + iconSize + 3.f,0.f, labelHeight, badgeCountWidth);
    
    badgesLabel_ = [[UILabel alloc] initWithFrame:badgesLabelFrame];
    [badgesLabel_ setBackgroundColor:[UIColor clearColor]];
    [badgesLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
    [badgesLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [badgesLabel_ setTextAlignment:UITextAlignmentRight];
    [self addSubview:badgesLabel_];
    
    // Badge Container
    badgesContainer_ = [[UILabel alloc] initWithFrame:badgesContainerFrame];
    [badgesContainer_ setBackgroundColor:[UIColor clearColor]];
    [self addSubview:badgesContainer_];
    
    // Badges Icon
    badgeGoldIcon_ = [[UIImageView alloc] initWithFrame:badgeGoldIconFrame];
    [badgeGoldIcon_ setImage:[UIImage imageNamed:kPMINIconBadgeGold]];
    [self.badgesContainer addSubview:badgeGoldIcon_];
    
    badgeSilverIcon_ = [[UIImageView alloc] initWithFrame:badgeSilverIconFrame];
    [badgeSilverIcon_ setImage:[UIImage imageNamed:kPMINIconBadgeSilver]];
    [self.badgesContainer addSubview:badgeSilverIcon_];
    
    badgeBronzeIcon_ = [[UIImageView alloc] initWithFrame:badgeBronzeIconFrame];
    [badgeBronzeIcon_ setImage:[UIImage imageNamed:kPMINIconBadgeBronze]];
    [self.badgesContainer addSubview:badgeBronzeIcon_];
    
    // Badges Count label
    badgeGoldCount_ = [[UILabel alloc] initWithFrame:badgeGoldCountFrame];
    [badgeGoldCount_ setBackgroundColor:[UIColor clearColor]];
    [badgeGoldCount_ setTextColor:[GlobalRender textColorTitleWhite]];
    [badgeGoldCount_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
    [badgeGoldCount_ setTextAlignment:UITextAlignmentLeft];
    [self.badgesContainer addSubview:badgeGoldCount_];
    
    badgeSilverCount_ = [[UILabel alloc] initWithFrame:badgeSilverCountFrame];
    [badgeSilverCount_ setBackgroundColor:[UIColor clearColor]];
    [badgeSilverCount_ setTextColor:[GlobalRender textColorTitleWhite]];
    [badgeSilverCount_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
    [badgeSilverCount_ setTextAlignment:UITextAlignmentLeft];
    [self.badgesContainer addSubview:badgeSilverCount_];
    
    badgeBronzeCount_ = [[UILabel alloc] initWithFrame:badgeBronzeCountFrame];
    [badgeBronzeCount_ setBackgroundColor:[UIColor clearColor]];
    [badgeBronzeCount_ setTextColor:[GlobalRender textColorTitleWhite]];
    [badgeBronzeCount_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
    [badgeBronzeCount_ setTextAlignment:UITextAlignmentLeft];
    [self.badgesContainer addSubview:badgeBronzeCount_];
    
    [self.badgesLabel  setText:NSLocalizedString(@"PMSLabelBadges", nil)];
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Public Methods

- (void)updateBadges:(NSArray *)badges {
  NSLog(@"--- TrainerBadgeView - |updateBadges:| update badges...");
  [self.badgeGoldCount   setText:[badges objectAtIndex:0]];
  [self.badgeSilverCount setText:[badges objectAtIndex:1]];
  [self.badgeBronzeCount setText:[badges objectAtIndex:2]];
}

@end
