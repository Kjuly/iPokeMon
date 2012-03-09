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
}

@property (nonatomic, retain) UIButton * mainButton;
@property (nonatomic, retain) UIButton * confirmButton;
@property (nonatomic, retain) UIButton * infoButton;
@property (nonatomic, retain) UIButton * cancelButton;

- (void)openUnit:(id)sender;

@end

@implementation GameMenuSixPokemonsUnitView

@synthesize delegate = delegate_;

@synthesize mainButton    = mainButton_;
@synthesize confirmButton = confirmButton_;
@synthesize infoButton    = infoButton_;
@synthesize cancelButton  = cancelButton_;

- (void)dealloc
{
  self.delegate = nil;
  
  self.mainButton    = nil;
  self.confirmButton = nil;
  self.infoButton    = nil;
  self.cancelButton  = nil;
  
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame tag:(NSInteger)tag
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
    [mainButton_ addTarget:self action:@selector(openUnit:) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:mainButton_];
    
    confirmButton_ = [[UIButton alloc] initWithFrame:confirmButtonFrame];
    [confirmButton_ setTag:tag];
    [confirmButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                              forState:UIControlStateNormal];
    [confirmButton_ setImage:[UIImage imageNamed:@"ButtonIconConfirm.png"] forState:UIControlStateNormal];
    [confirmButton_ addTarget:self.delegate action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [confirmButton_ setAlpha:0.f];
    [self addSubview:confirmButton_];
    
    infoButton_ = [[UIButton alloc] initWithFrame:infoButtonFrame];
    [infoButton_ setTag:tag];
    [infoButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                           forState:UIControlStateNormal];
    [infoButton_ setImage:[UIImage imageNamed:@"ButtonIconInfo.png"] forState:UIControlStateNormal];
    [infoButton_ addTarget:self.delegate action:@selector(openInfoView) forControlEvents:UIControlEventTouchUpInside];
    [infoButton_ setAlpha:0.f];
    [self addSubview:infoButton_];
    
    cancelButton_ = [[UIButton alloc] initWithFrame:cancelButtonFrame];
    [cancelButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                             forState:UIControlStateNormal];
    [cancelButton_ setImage:[UIImage imageNamed:@"ButtonIconCancel.png"] forState:UIControlStateNormal];
    [cancelButton_ addTarget:self action:@selector(cancelUnit) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setFrame:frame];
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
                                       [self.confirmButton setAlpha:1.f];
                                       [self.infoButton setAlpha:1.f];
                                       [self.confirmButton setFrame:confirmButtonFrame];
                                       [self.infoButton setFrame:infoButtonFrame];
                                     }
                                     completion:nil];
                  }];
}

- (void)cancelUnit {
  CGFloat buttonSize = 60.f;
  CGRect mainButtonFrame    = CGRectMake((self.frame.size.width - buttonSize) / 2, 0.f, buttonSize, buttonSize);
  CGRect confirmButtonFrame = mainButtonFrame;
  CGRect infoButtonFrame    = mainButtonFrame;
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     [self.confirmButton setFrame:confirmButtonFrame];
                     [self.infoButton setFrame:infoButtonFrame];
                     [self.confirmButton setAlpha:0.f];
                     [self.infoButton setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [UIView transitionFromView:self.cancelButton
                                         toView:self.mainButton
                                       duration:.3f
                                        options:UIViewAnimationOptionTransitionFlipFromLeft
                                     completion:nil];
                   }];
  [self.delegate resetUnit];
}

@end
