//
//  PokemonMoveDetailView.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonMoveDetailView.h"

#import "GlobalRender.h"
#import "PokemonMoveView.h"
#import "PokemonInfoLabelView.h"


@implementation PokemonMoveDetailView

@synthesize moveBaseView      = moveBaseView_;
@synthesize backButton        = backButton_;
@synthesize categoryLabelView = categoryLabelView_;
@synthesize powerLabelView    = powerLabelView_;
@synthesize accuracyLabelView = accuracyLabelView_;
@synthesize infoTextView      = infoTextView_;


- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    CGFloat const labelHeight        = 30.0f;
    CGFloat const offset = 15.f;
    CGFloat const moveBaseViewHeight = (frame.size.height - 80.0f) / 4.0f - offset;
    
    CGRect const moveBaseViewFrame      = CGRectMake(0.0f, 10.0f + offset / 2.f, kViewWidth, moveBaseViewHeight);
    CGRect const backButtonFrame        = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    CGRect const categoryLabelViewFrame = CGRectMake(10.0f, 10.0f + moveBaseViewHeight + offset, 300.0f, labelHeight);
    CGRect const powerLabelViewFrame    = CGRectMake(10.0f, 10.0f + moveBaseViewHeight + offset + labelHeight, 140.0f, labelHeight);
    CGRect const accuracyLabelViewFrame = CGRectMake(140.0f, powerLabelViewFrame.origin.y, 160.0f, labelHeight);
    CGRect const infoTextViewFrame      = CGRectMake(10.0f,
                                                     powerLabelViewFrame.origin.y + labelHeight,
                                                     300.0f,
                                                     3 * labelHeight);
    
    moveBaseView_ = [[PokemonMoveView alloc] initWithFrame:moveBaseViewFrame];
    [self addSubview:moveBaseView_];
    
    categoryLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:categoryLabelViewFrame hasValueLabel:YES];
    [categoryLabelView_ setBackgroundColor:[UIColor clearColor]];
    [categoryLabelView_.name setText:NSLocalizedString(@"PMSLabelCategory", nil)];
    [self addSubview:categoryLabelView_];
    
    powerLabelView_    = [[PokemonInfoLabelView alloc] initWithFrame:powerLabelViewFrame hasValueLabel:YES];
    [powerLabelView_.name setText:NSLocalizedString(@"PMSLabelPower", nil)];
    [self addSubview:powerLabelView_];
    
    accuracyLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:accuracyLabelViewFrame hasValueLabel:YES];
    [accuracyLabelView_ adjustNameLabelWidthWith:20.0f];
    [accuracyLabelView_.name setText:NSLocalizedString(@"PMSLabelAccuracy", nil)];
    [self addSubview:accuracyLabelView_];
    
    // Move Infomation View
    infoTextView_ = [[UITextView alloc] initWithFrame:infoTextViewFrame];
    [infoTextView_ setBackgroundColor:[UIColor colorWithPatternImage:
                                       [UIImage imageNamed:kPMINPMDetailDescriptionBackground]]];
    [infoTextView_ setOpaque:NO];
    [infoTextView_ setEditable:NO];
    [infoTextView_ setFont:[GlobalRender textFontNormalInSizeOf:14.0f]];
    [infoTextView_ setTextColor:[GlobalRender textColorNormal]];
    [self addSubview:infoTextView_];
    
    backButton_ = [[UIButton alloc] initWithFrame:backButtonFrame];
    [backButton_ setBackgroundColor:[UIColor clearColor]];
    [self addSubview:backButton_];
    
    [self setNeedsDisplay];
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

@end
