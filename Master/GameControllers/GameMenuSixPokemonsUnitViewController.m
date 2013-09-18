//
//  GameMenuSixPokemonsUnitViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuSixPokemonsUnitViewController.h"

@interface GameMenuSixPokemonsUnitViewController () {
 @private
  UIButton * mainButton_;
  UIButton * confirmButton_;
  UIButton * infoButton_;
  UIButton * cancelButton_;
}

@property (nonatomic, strong) UIButton * mainButton;
@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, strong) UIButton * infoButton;
@property (nonatomic, strong) UIButton * cancelButton;

- (void)_open;
- (void)_cancel;

@end


@implementation GameMenuSixPokemonsUnitViewController

@synthesize mainButton    = mainButton_;
@synthesize confirmButton = confirmButton_;
@synthesize infoButton    = infoButton_;
@synthesize cancelButton  = cancelButton_;

- (id)init
{
  return (self = [super init]);
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  UIView * view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {kViewWidth, 60.f}}];
  
  CGFloat buttonSize = 60.f;
  CGRect mainButtonFrame    = CGRectMake((kViewWidth - buttonSize) / 2, 0.f, buttonSize, buttonSize);
  CGRect confirmButtonFrame = mainButtonFrame;
  CGRect infoButtonFrame    = mainButtonFrame;
  CGRect cancelButtonFrame  = mainButtonFrame;
  
  mainButton_ = [[UIButton alloc] initWithFrame:mainButtonFrame];
  [mainButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                         forState:UIControlStateNormal];
  [mainButton_ addTarget:self action:@selector(_open) forControlEvents:UIControlEventTouchUpInside];
  [view  addSubview:mainButton_];
  
  confirmButton_ = [[UIButton alloc] initWithFrame:confirmButtonFrame];
  [confirmButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                            forState:UIControlStateNormal];
  [confirmButton_ setImage:[UIImage imageNamed:kPMINMainButtonConfirm] forState:UIControlStateNormal];
  [confirmButton_ setAlpha:0.f];
  [view addSubview:confirmButton_];
  
  infoButton_ = [[UIButton alloc] initWithFrame:infoButtonFrame];
  [infoButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                         forState:UIControlStateNormal];
  [infoButton_ setImage:[UIImage imageNamed:kPMINMainButtonInfo] forState:UIControlStateNormal];
  [infoButton_ setAlpha:0.f];
  [view addSubview:infoButton_];
  
  cancelButton_ = [[UIButton alloc] initWithFrame:cancelButtonFrame];
  [cancelButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                           forState:UIControlStateNormal];
  [cancelButton_ setImage:[UIImage imageNamed:kPMINMainButtonCancelOpposite] forState:UIControlStateNormal];
  [cancelButton_ addTarget:self action:@selector(_cancel) forControlEvents:UIControlEventTouchUpInside];
  
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.mainButton    = nil;
  self.confirmButton = nil;
  self.infoButton    = nil;
  self.cancelButton  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

- (void)_open
{
  CGFloat buttonSize = 60.f;
  CGRect mainButtonFrame    = CGRectMake((kViewWidth - buttonSize) / 2, 0.f, buttonSize, buttonSize);
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

- (void)_cancel
{
  CGFloat buttonSize = 60.f;
  CGRect mainButtonFrame    = CGRectMake((kViewWidth - buttonSize) / 2, 0.f, buttonSize, buttonSize);
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
                     if (finished)
                       [UIView transitionFromView:self.cancelButton
                                           toView:self.mainButton
                                         duration:.3f
                                          options:UIViewAnimationOptionTransitionFlipFromLeft
                                       completion:nil];
                   }];
}

@end
