//
//  GameMenuMoveUnitView.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuMoveUnitView.h"

#import "UIButton+Animation.h"
#import "GlobalRender.h"


@interface GameMenuMoveUnitView () {
@private
  id <GameMenuMoveUnitViewDelegate> __weak delegate_;
  UIButton * moveButton_;
  UILabel  * pp_;
  
  NSInteger moveSID_;
}

@property (nonatomic, weak) id <GameMenuMoveUnitViewDelegate> delegate;
@property (nonatomic, strong) UIButton * moveButton;
@property (nonatomic, strong) UILabel  * pp;

@end


@implementation GameMenuMoveUnitView

@synthesize delegate = delegate_;
@synthesize moveButton = moveButton_;
@synthesize pp         = pp_;

-(void)dealloc
{
  self.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    CGFloat const frameHeight = frame.size.height;
    CGFloat const frameWidth  = frame.size.width;
//    CGFloat const labelHeight = 32.f;
    CGFloat const buttonSize  = 64.f;
    
//    CGRect  const ppFrame     = CGRectMake(nameFrame.origin.x, 20.f + labelHeight, 60.f, labelHeight);
    CGRect  const viewButtonFrame = CGRectMake((frameWidth - buttonSize) / 2.f, (frameHeight - buttonSize) / 2.f, buttonSize, buttonSize);
    
    moveButton_ = [[UIButton alloc] initWithFrame:viewButtonFrame];
    [moveButton_ setBackgroundColor:[UIColor clearColor]];
    [moveButton_.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [moveButton_ setBackgroundImage:[UIImage imageNamed:kPMINIconMoveBackground]
                           forState:UIControlStateNormal];
    [moveButton_ setImage:nil forState:UIControlStateNormal];
    [moveButton_ addTarget:self.delegate
                    action:@selector(showDetail:)
          forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:moveButton_];
    
//    pp_ = [[UILabel alloc] initWithFrame:ppFrame];
//    [pp_ setBackgroundColor:[UIColor clearColor]];
//    [pp_ setTextAlignment:UITextAlignmentLeft];
//    [pp_ setTextColor:[GlobalRender textColorOrange]];
//    [pp_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
//    [self addSubview:pp_];
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

- (void)configureMoveUnitWithSID:(NSInteger)SID
                              pp:(NSString *)pp
                        delegate:(id<GameMenuMoveUnitViewDelegate>)delegate
                             tag:(NSInteger)tag
{
  moveSID_ = SID;
  NSString * localizedName =
    SID ? KYResourceLocalizedString(([NSString stringWithFormat:@"PMSMove%.3d", SID]), nil) : @"- - -";
  if (! [self.moveButton.titleLabel.text isEqualToString:localizedName]) {
    CGFloat fontSize;
    if (localizedName.length <= 7)       fontSize = 12.f;
    else if (localizedName.length <= 12) fontSize = 8.f;
    else                                 fontSize = 6.f;
    [self.moveButton.titleLabel setFont:[GlobalRender textFontBoldItalicInSizeOf:fontSize]];
    [self.moveButton setTitle:localizedName forState:UIControlStateNormal];
  }
  
//  [self.pp setText:pp];
  
  self.delegate = delegate;
  [self.moveButton setTag:tag];
  [self.moveButton setEnabled:YES];
}

// toggle |moveButton_|
- (void)setButtonEnabled:(BOOL)enabled
{
  // Change Text color if needed
  if (enabled) {
    [self.moveButton setEnabled:YES];
    [self.moveButton.titleLabel setTextColor:[GlobalRender textColorTitleWhite]];
//    [self.pp setTextColor:[GlobalRender textColorOrange]];
  } else {
    [self.moveButton setEnabled:NO];
    [self.moveButton.titleLabel setTextColor:[GlobalRender textColorDisabled]];
//    [self.pp setTextColor:[GlobalRender textColorDisabled]];
  }
}

// set |moveButton_| as selected
- (void)setButtonSelected:(BOOL)selected
{
  if (selected) {
    [self.moveButton transitionToImage:[UIImage imageNamed:kPMINMainButtonConfirm]
                               options:UIViewAnimationOptionTransitionCrossDissolve];
    [self.moveButton setTitle:nil forState:UIControlStateNormal];
  }
  else {
    [self.moveButton transitionToImage:nil
                               options:UIViewAnimationOptionTransitionCrossDissolve];
    [self.moveButton setTitle:KYResourceLocalizedString(([NSString stringWithFormat:@"PMSMove%.3d", moveSID_]), nil)
                     forState:UIControlStateNormal];
  }
}

@end
