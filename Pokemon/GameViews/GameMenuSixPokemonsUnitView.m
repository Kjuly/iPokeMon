//
//  GameMenuSixPokemonsUnitView.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuSixPokemonsUnitView.h"

@interface GameMenuSixPokemonsUnitView () {
 @private
  UIButton * mainButton_;
  UIButton * confirmButton_;
  UIButton * infoButton_;
  UIButton * cancelButton_;
  BOOL       isCurrBattlePokemon_;
}

@property (nonatomic, retain) UIButton * mainButton;
@property (nonatomic, retain) UIButton * confirmButton;
@property (nonatomic, retain) UIButton * infoButton;
@property (nonatomic, retain) UIButton * cancelButton;
@property (nonatomic, assign) BOOL       isCurrBattlePokemon;

- (void)openUnit:(id)sender;

@end

@implementation GameMenuSixPokemonsUnitView

@synthesize delegate = delegate_;

@synthesize mainButton    = mainButton_;
@synthesize confirmButton = confirmButton_;
@synthesize infoButton    = infoButton_;
@synthesize cancelButton  = cancelButton_;
@synthesize isCurrBattlePokemon = isCurrBattlePokemon_;

- (void)dealloc
{
  self.delegate = nil;
  
  self.mainButton    = nil;
  self.confirmButton = nil;
  self.infoButton    = nil;
  self.cancelButton  = nil;
  
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image tag:(NSInteger)tag
{
  if (self = [self initWithFrame:frame]) {
    CGFloat buttonSize = 60.f;
    CGRect mainButtonFrame    = CGRectMake((frame.size.width - buttonSize) / 2, 0.f, buttonSize, buttonSize);
    CGRect confirmButtonFrame = mainButtonFrame;
    CGRect infoButtonFrame    = mainButtonFrame;
    CGRect cancelButtonFrame  = mainButtonFrame;
    
    mainButton_ = [[UIButton alloc] initWithFrame:mainButtonFrame];
    [mainButton_ setTag:tag];
    [mainButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                           forState:UIControlStateNormal];
    [mainButton_ setImage:image forState:UIControlStateNormal];
    [mainButton_ addTarget:self action:@selector(openUnit:) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:mainButton_];
    
    confirmButton_ = [[UIButton alloc] initWithFrame:confirmButtonFrame];
    [confirmButton_ setTag:tag];
    [confirmButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                              forState:UIControlStateNormal];
    [confirmButton_ setImage:[UIImage imageNamed:@"ButtonIconConfirm.png"] forState:UIControlStateNormal];
    [confirmButton_ addTarget:self.delegate action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton_ setAlpha:0.f];
    [self addSubview:confirmButton_];
    
    infoButton_ = [[UIButton alloc] initWithFrame:infoButtonFrame];
    [infoButton_ setTag:tag];
    [infoButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                           forState:UIControlStateNormal];
    [infoButton_ setImage:[UIImage imageNamed:@"ButtonIconInfo.png"] forState:UIControlStateNormal];
    [infoButton_ addTarget:self.delegate action:@selector(openInfoView:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton_ setAlpha:0.f];
    [self addSubview:infoButton_];
    
    cancelButton_ = [[UIButton alloc] initWithFrame:cancelButtonFrame];
    [cancelButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                             forState:UIControlStateNormal];
    [cancelButton_ setImage:[UIImage imageNamed:@"ButtonIconCancel.png"] forState:UIControlStateNormal];
    [cancelButton_ addTarget:self action:@selector(cancelUnitAnimated:) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setFrame:frame];
    isCurrBattlePokemon_ = NO;
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

- (void)openUnit:(id)sender {
  [self.delegate checkUnit:sender];
  
  CGFloat buttonSize = 60.f;
  CGRect mainButtonFrame    = CGRectMake((self.frame.size.width - buttonSize) / 2, 0.f, buttonSize, buttonSize);
  CGRect confirmButtonFrame = CGRectMake(mainButtonFrame.origin.x - 70.f, 0.f, buttonSize, buttonSize);
  CGRect infoButtonFrame    = CGRectMake(mainButtonFrame.origin.x + 70.f, 0.f, buttonSize, buttonSize);
  [UIView transitionFromView:self.mainButton
                      toView:self.cancelButton
                    duration:.3f
                     options:UIViewAnimationOptionTransitionFlipFromRight
                  completion:^(BOOL finished) {
                    [UIView animateWithDuration:.3f
                                          delay:.1f
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                       // If it's the current battle pokemon, do not show confirm button
                                       if (! self.isCurrBattlePokemon) {
                                         [self.confirmButton setAlpha:1.f];
                                         [self.confirmButton setFrame:confirmButtonFrame];
                                       }
                                       [self.infoButton setAlpha:1.f];
                                       [self.infoButton setFrame:infoButtonFrame];
                                     }
                                     completion:nil];
                  }];
}

- (void)cancelUnitAnimated:(BOOL)animated {
  void (^animation)() = ^(){
    CGFloat buttonSize = 60.f;
    CGRect mainButtonFrame    = CGRectMake((self.frame.size.width - buttonSize) / 2, 0.f, buttonSize, buttonSize);
    CGRect confirmButtonFrame = mainButtonFrame;
    CGRect infoButtonFrame    = mainButtonFrame;
    
    [self.confirmButton setFrame:confirmButtonFrame];
    [self.infoButton setFrame:infoButtonFrame];
    [self.confirmButton setAlpha:0.f];
    [self.infoButton setAlpha:0.f];
  };
  void (^completion)(BOOL finished) = ^(BOOL finished) {
    [UIView transitionFromView:self.cancelButton
                        toView:self.mainButton
                      duration:(animated ? .3f : 0.f)
                       options:(animated ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionNone)
                    completion:nil];
  };
  
  if (! animated) { animation(); completion(YES); }
  else [UIView animateWithDuration:.3f
                             delay:0.f
                           options:UIViewAnimationOptionCurveEaseInOut
                        animations:animation
                        completion:completion];
  [self.delegate resetUnit];
}

- (void)setAsCurrentBattleOne:(BOOL)isCurrentBattleOne
{
  self.isCurrBattlePokemon = isCurrentBattleOne;
  NSString * buttonBackgroundImageName = @"MainViewCenterMenuButtonBackground.png";
  if (isCurrentBattleOne)
    buttonBackgroundImageName = @"GameMenuSixPokemonsUnitViewCurrPokemonButtonBackground.png";
  [self.mainButton setBackgroundImage:[UIImage imageNamed:buttonBackgroundImageName]
                             forState:UIControlStateNormal];
  [self.cancelButton setBackgroundImage:[UIImage imageNamed:buttonBackgroundImageName]
                               forState:UIControlStateNormal];
  
}

@end
