//
//  GameTopViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameTopViewController.h"

#import "GlobalConstants.h"


@interface GameTopViewController () {
 @private
  UIView      * backgroundView_;
  UIButton    * avatarTopButton_;
  UIImageView * avatarBottomView_;
  BOOL          isTrainerViewOpening_;
}

@property (nonatomic, retain) UIView      * backgroundView;
@property (nonatomic, retain) UIButton    * avatarTopButton;
@property (nonatomic, retain) UIImageView * avatarBottomView;
@property (nonatomic, assign) BOOL          isTrainerViewOpening;

- (void)toggleTrainerView:(id)sender;

@end


@implementation GameTopViewController

@synthesize backgroundView       = backgroundView_;
@synthesize avatarTopButton      = avatarTopButton_;
@synthesize avatarBottomView     = avatarBottomView_;
@synthesize isTrainerViewOpening = isTrainerViewOpening_;

- (void)dealloc
{
  [backgroundView_   release];
  [avatarTopButton_  release];
  [avatarBottomView_ release];
  
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, 85.f)];
  self.view = view;
  [view release];
  
  backgroundView_ = [[UIView alloc] initWithFrame:CGRectMake(0.f, -55.f, kViewWidth, 115.f)];
  [backgroundView_ setBackgroundColor:
   [UIColor colorWithPatternImage:[UIImage imageNamed:@"GameBattleViewTopBarBackground.png"]]];
  [backgroundView_ setOpaque:NO];
  [self.view addSubview:backgroundView_];
  
  avatarBottomView_ = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, -10.f, 65.f, 90.f)];
  [avatarBottomView_ setImage:[UIImage imageNamed:@"GameBattleViewTopBarAvatarBottom.png"]];
  [avatarBottomView_ setAlpha:0.f];
  [self.view addSubview:avatarBottomView_];
  
  avatarTopButton_ = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 0.f, 65.f, 90.f)];
  [avatarTopButton_ setBackgroundColor:
   [UIColor colorWithPatternImage:[UIImage imageNamed:@"GameBattleViewTopBarAvatarTop.png"]]];
  [avatarTopButton_ setOpaque:NO];
  [avatarTopButton_ addTarget:self action:@selector(toggleTrainerView:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:avatarTopButton_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Basic Setting
  isTrainerViewOpening_ = NO;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.backgroundView   = nil;
  self.avatarTopButton    = nil;
  self.avatarBottomView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

- (void)toggleTrainerView:(id)sender
{
  CGRect avatarBottomViewFrame  = CGRectMake(10.f, 0.f, 65.f, 90.f);
  CGFloat avatarBottomViewAlpha = 1.f;
  CGRect backgroundViewFrame    = CGRectMake(0.f, 0.f, kViewWidth, 115.f);
  if (self.isTrainerViewOpening) {
    avatarBottomViewFrame.origin.y -= 10.f;
    avatarBottomViewAlpha = 0.f;
    backgroundViewFrame.origin.y -= 55.f;
  }
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     [self.avatarBottomView setAlpha:avatarBottomViewAlpha];
                     [self.avatarBottomView setFrame:avatarBottomViewFrame];
                     [self.backgroundView setFrame:backgroundViewFrame];
                   }
                   completion:nil];
  self.isTrainerViewOpening = ! self.isTrainerViewOpening;
}

@end
