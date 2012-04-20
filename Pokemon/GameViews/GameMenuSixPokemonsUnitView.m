//
//  GameMenuSixPokemonsUnitView.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuSixPokemonsUnitView.h"

#import "GlobalConstants.h"


@interface GameMenuSixPokemonsUnitView () {
 @private
  UIButton * mainButton_;
  UIButton * confirmButton_;
  UIButton * infoButton_;
  UIButton * cancelButton_;
  
  BOOL       isCurrBattlePokemon_;
  BOOL       isFainted_;
}

@property (nonatomic, retain) UIButton * mainButton;
@property (nonatomic, retain) UIButton * confirmButton;
@property (nonatomic, retain) UIButton * infoButton;
@property (nonatomic, retain) UIButton * cancelButton;

- (void)openUnit:(id)sender;
- (void)setBackgroundForButtonsWithImageName:(NSString *)imageName;

@end

@implementation GameMenuSixPokemonsUnitView

@synthesize delegate = delegate_;

@synthesize mainButton    = mainButton_;
@synthesize confirmButton = confirmButton_;
@synthesize infoButton    = infoButton_;
@synthesize cancelButton  = cancelButton_;

- (void)dealloc {
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
    [mainButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                           forState:UIControlStateNormal];
    [mainButton_ setImage:image forState:UIControlStateNormal];
    [mainButton_ addTarget:self action:@selector(openUnit:) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:mainButton_];
    
    confirmButton_ = [[UIButton alloc] initWithFrame:confirmButtonFrame];
    [confirmButton_ setTag:tag];
    [confirmButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                              forState:UIControlStateNormal];
    [confirmButton_ setImage:[UIImage imageNamed:kPMINMainButtonConfirm] forState:UIControlStateNormal];
    [confirmButton_ addTarget:self.delegate action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton_ setAlpha:0.f];
    [self addSubview:confirmButton_];
    
    infoButton_ = [[UIButton alloc] initWithFrame:infoButtonFrame];
    [infoButton_ setTag:tag];
    [infoButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                           forState:UIControlStateNormal];
    [infoButton_ setImage:[UIImage imageNamed:kPMINMainButtonInfo] forState:UIControlStateNormal];
    [infoButton_ addTarget:self.delegate action:@selector(openInfoView:) forControlEvents:UIControlEventTouchUpInside];
    [infoButton_ setAlpha:0.f];
    [self addSubview:infoButton_];
    
    cancelButton_ = [[UIButton alloc] initWithFrame:cancelButtonFrame];
    [cancelButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                             forState:UIControlStateNormal];
    [cancelButton_ setImage:[UIImage imageNamed:kPMINMainButtonCancel] forState:UIControlStateNormal];
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
    isFainted_           = NO;
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

// Open Unit
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
                                       if (! isCurrBattlePokemon_ && ! isFainted_) {
                                         [self.confirmButton setAlpha:1.f];
                                         [self.confirmButton setFrame:confirmButtonFrame];
                                       }
                                       [self.infoButton setAlpha:1.f];
                                       [self.infoButton setFrame:infoButtonFrame];
                                     }
                                     completion:nil];
                  }];
}

// Cancel Unit
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

// Set the Pokemon as Normal
- (void)setAsNormal {
  isCurrBattlePokemon_ = NO;
  isFainted_           = NO;
  [self setBackgroundForButtonsWithImageName:kPMINMainButtonBackgoundNormal];
}

// Set the Pokemon as current battle one
- (void)setAsCurrentBattleOne:(BOOL)isCurrentBattleOne {
  isCurrBattlePokemon_ = isCurrentBattleOne;
  NSString * buttonBackgroundImageName = kPMINMainButtonBackgoundNormal;
  if (isCurrentBattleOne)
    buttonBackgroundImageName = kPMINMainButtonBackgoundEnable;
  [self setBackgroundForButtonsWithImageName:buttonBackgroundImageName];
}

// Set the Pokemon as Fainted
- (void)setAsFainted:(BOOL)isFainted {
  isFainted_ = isFainted;
  NSString * buttonBackgroundImageName = kPMINMainButtonBackgoundNormal;
  if (isFainted)
    buttonBackgroundImageName = kPMINMainButtonBackgoundDisable;
  [self setBackgroundForButtonsWithImageName:buttonBackgroundImageName];
}

#pragma mark - Private Methods

// Set background image for buttons
- (void)setBackgroundForButtonsWithImageName:(NSString *)imageName {
  [self.mainButton setBackgroundImage:[UIImage imageNamed:imageName]
                             forState:UIControlStateNormal];
  [self.cancelButton setBackgroundImage:[UIImage imageNamed:imageName]
                               forState:UIControlStateNormal];
}

@end
