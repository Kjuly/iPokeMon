//
//  GameMenuSixPokemonsUnitViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuSixPokemonsUnitViewController.h"

#import "GlobalConstants.h"


@interface GameMenuSixPokemonsUnitViewController () {
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

- (void)open;
- (void)cancel;

@end


@implementation GameMenuSixPokemonsUnitViewController

@synthesize mainButton     = mainButton_;
@synthesize confirmButton  = confirmButton_;
@synthesize infoButton     = infoButton_;
@synthesize cancelButton   = cancelButton_;

- (void)dealloc
{
  [mainButton_     release];
  [confirmButton_  release];
  [infoButton_     release];
  [cancelButton_   release];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 320.f, 60.f)];
  self.view = view;
  [view release];
  
  CGFloat buttonSize = 60.f;
  CGRect mainButtonFrame    = CGRectMake((kViewWidth - buttonSize) / 2, 0.f, buttonSize, buttonSize);
  CGRect confirmButtonFrame = mainButtonFrame;
  CGRect infoButtonFrame    = mainButtonFrame;
  CGRect cancelButtonFrame  = mainButtonFrame;
  
  mainButton_ = [[UIButton alloc] initWithFrame:mainButtonFrame];
  [mainButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                         forState:UIControlStateNormal];
  [mainButton_ addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
  [self.view  addSubview:mainButton_];
  
  confirmButton_ = [[UIButton alloc] initWithFrame:confirmButtonFrame];
  [confirmButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                            forState:UIControlStateNormal];
  [confirmButton_ setImage:[UIImage imageNamed:@"ButtonIconConfirm.png"] forState:UIControlStateNormal];
  [confirmButton_ setAlpha:0.f];
  [self.view addSubview:confirmButton_];
  
  infoButton_ = [[UIButton alloc] initWithFrame:infoButtonFrame];
  [infoButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                         forState:UIControlStateNormal];
  [infoButton_ setImage:[UIImage imageNamed:@"ButtonIconInfo.png"] forState:UIControlStateNormal];
  [infoButton_ setAlpha:0.f];
  [self.view addSubview:infoButton_];
  
  cancelButton_ = [[UIButton alloc] initWithFrame:cancelButtonFrame];
  [cancelButton_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                           forState:UIControlStateNormal];
  [cancelButton_ setImage:[UIImage imageNamed:@"ButtonIconCancel.png"] forState:UIControlStateNormal];
  [cancelButton_ addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.mainButton     = nil;
  self.confirmButton  = nil;
  self.infoButton     = nil;
  self.cancelButton   = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

- (void)open {
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

- (void)cancel {
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
                     [UIView transitionFromView:self.cancelButton
                                         toView:self.mainButton
                                       duration:.3f
                                        options:UIViewAnimationOptionTransitionFlipFromLeft
                                     completion:nil];
                   }];
}

@end
