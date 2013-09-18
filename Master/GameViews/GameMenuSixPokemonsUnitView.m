//
//  GameMenuSixPokemonsUnitView.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuSixPokemonsUnitView.h"

#import "UIButton+Animation.h"

@interface GameMenuSixPokemonsUnitView () {
 @private
  UIImage  * spriteImage_;
  UIButton * mainButton_;
  UIButton * confirmButton_;
  UIButton * infoButton_;
  
  BOOL isCurrBattlePokemon_;   // mark it as the current battle PM
  BOOL isFainted_;             // mark it as a fainted PM
  BOOL isOpen_;                // mark that the button is open
  BOOL isAnimationProcessing_; // mark that the animation is processing
}

@property (nonatomic, strong) UIImage  * spriteImage;
@property (nonatomic, strong) UIButton * mainButton;
@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, strong) UIButton * infoButton;

- (void)_runButtonAction:(id)sender;
- (void)_openUnit:(id)sender;
- (void)_setBackgroundForButtonsWithImageName:(NSString *)imageName;

@end


@implementation GameMenuSixPokemonsUnitView

@synthesize delegate = delegate_;

@synthesize spriteImage   = spriteImage_;
@synthesize mainButton    = mainButton_;
@synthesize confirmButton = confirmButton_;
@synthesize infoButton    = infoButton_;

- (void)dealloc
{
  self.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
              image:(UIImage *)image
                tag:(NSInteger)tag
{
  if (self = [self initWithFrame:frame]) {
    self.spriteImage = image;
    
    CGFloat buttonSize = 60.f;
    CGRect mainButtonFrame    = CGRectMake((frame.size.width - buttonSize) / 2, 0.f, buttonSize, buttonSize);
    CGRect confirmButtonFrame = mainButtonFrame;
    CGRect infoButtonFrame    = mainButtonFrame;
    
    mainButton_ = [[UIButton alloc] initWithFrame:mainButtonFrame];
    [mainButton_ setTag:tag];
    [mainButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                           forState:UIControlStateNormal];
    [mainButton_ setImage:self.spriteImage forState:UIControlStateNormal];
    [mainButton_ addTarget:self
                    action:@selector(_runButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:mainButton_];
    
    confirmButton_ = [[UIButton alloc] initWithFrame:confirmButtonFrame];
    [confirmButton_ setTag:tag];
    [confirmButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                              forState:UIControlStateNormal];
    [confirmButton_ setImage:[UIImage imageNamed:kPMINMainButtonConfirm]
                    forState:UIControlStateNormal];
    [confirmButton_ addTarget:self.delegate
                       action:@selector(confirm:)
             forControlEvents:UIControlEventTouchUpInside];
    [confirmButton_ setAlpha:0.f];
    [self addSubview:confirmButton_];
    
    infoButton_ = [[UIButton alloc] initWithFrame:infoButtonFrame];
    [infoButton_ setTag:tag];
    [infoButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                           forState:UIControlStateNormal];
    [infoButton_ setImage:[UIImage imageNamed:kPMINMainButtonInfo]
                 forState:UIControlStateNormal];
    [infoButton_ addTarget:self.delegate
                    action:@selector(openInfoView:)
          forControlEvents:UIControlEventTouchUpInside];
    [infoButton_ setAlpha:0.f];
    [self addSubview:infoButton_];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self setFrame:frame];
    isCurrBattlePokemon_   = NO;
    isFainted_             = NO;
    isOpen_                = NO;
    isAnimationProcessing_ = NO;
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

// Cancel Unit
- (void)cancelUnitAnimated:(BOOL)animated
{
  isOpen_ = NO;
  
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
    [self.mainButton transitionTotalToImage:self.spriteImage
                                   forState:UIControlStateNormal
                                   duration:(animated ? .3f : 0.f)
                                    options:(animated ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionNone)
                                 completion:^(BOOL finished){ isAnimationProcessing_ = NO; }];
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
- (void)setAsNormal
{
  isCurrBattlePokemon_ = NO;
  isFainted_           = NO;
  [self _setBackgroundForButtonsWithImageName:kPMINMainButtonBackgoundNormal];
}

// Set the Pokemon as current battle one
- (void)setAsCurrentBattleOne:(BOOL)isCurrentBattleOne
{
  isCurrBattlePokemon_ = isCurrentBattleOne;
  NSString * buttonBackgroundImageName = kPMINMainButtonBackgoundNormal;
  if (isCurrentBattleOne)
    buttonBackgroundImageName = kPMINMainButtonBackgoundEnable;
  [self _setBackgroundForButtonsWithImageName:buttonBackgroundImageName];
}

// Set the Pokemon as Fainted
- (void)setAsFainted:(BOOL)isFainted
{
  isFainted_ = isFainted;
  NSString * buttonBackgroundImageName = kPMINMainButtonBackgoundNormal;
  if (isFainted)
    buttonBackgroundImageName = kPMINMainButtonBackgoundDisable;
  [self _setBackgroundForButtonsWithImageName:buttonBackgroundImageName];
}

#pragma mark - Private Methods

- (void)_runButtonAction:(id)sender
{
  if (isAnimationProcessing_)
    return;
  isAnimationProcessing_ = YES;
  if (isOpen_) [self cancelUnitAnimated:YES];
  else [self _openUnit:sender];
}

// Open Unit
- (void)_openUnit:(id)sender
{
  isOpen_ = YES;
  [self.delegate checkUnit:sender];
  
  CGFloat buttonSize = 60.f;
  CGRect mainButtonFrame    = CGRectMake((self.frame.size.width - buttonSize) / 2, 0.f, buttonSize, buttonSize);
  CGRect confirmButtonFrame = CGRectMake(mainButtonFrame.origin.x - 70.f, 0.f, buttonSize, buttonSize);
  CGRect infoButtonFrame    = CGRectMake(mainButtonFrame.origin.x + 70.f, 0.f, buttonSize, buttonSize);
  
  void(^completion)(BOOL) = ^(BOOL finished) {
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
                     completion:^(BOOL finished){ isAnimationProcessing_ = NO; }];
  };
  [self.mainButton transitionTotalToImage:[UIImage imageNamed:kPMINMainButtonCancelOpposite]
                                 forState:UIControlStateNormal
                                 duration:.3f
                                  options:UIViewAnimationOptionTransitionFlipFromRight
                               completion:completion];
}

// Set background image for buttons
- (void)_setBackgroundForButtonsWithImageName:(NSString *)imageName
{
  [self.mainButton setBackgroundImage:[UIImage imageNamed:imageName]
                             forState:UIControlStateNormal];
}

@end
