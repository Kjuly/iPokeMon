//
//  MainViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MainViewController.h"

#import "GlobalConstants.h"
#import "GlobalNotificationConstants.h"
#import "GlobalRender.h"
#import "Trainer+DataController.h"
#import "TrainerTamedPokemon+DataController.h"
#import "MapViewController.h"
#import "UtilityViewController.h"
#import "PoketchTabViewController.h"
#import "CustomNavigationController.h"
#import "UtilityBallMenuViewController.h"
#import "GameMainViewController.h"

#ifdef DEBUG
#import "Pokemon+DataController.h"
#import "Move+DataController.h"
#import "WildPokemon+DataController.h"
#endif


@interface MainViewController () {
 @private
  BOOL      isMapViewOpening_;
  NSTimer * longTapTimer_;
  NSInteger timeCounter_;
}

@property (nonatomic, assign) BOOL isMapViewOpening;
@property (nonatomic, retain) NSTimer * longTapTimer;
@property (nonatomic, assign) NSInteger timeCounter;

- (void)openBallMenuView:(id)sender;
- (void)countLongTapTimeWithAction:(id)sender;
- (void)increaseTimeWithAction;
- (void)toggleMapView:(id)sender;
- (void)resetMainView:(NSNotification *)notification;

@end


@implementation MainViewController

@synthesize centerMainButton = centerMainButton_;
@synthesize mapButton        = mapButton_;

@synthesize mapViewController     = mapViewController_;
@synthesize utilityViewController = utilityViewController_;
@synthesize poketchViewController = poketchViewController_;
@synthesize utilityNavigationController   = utilityNavigationController_;
@synthesize gameMainViewController = gameMainViewController_;

@synthesize isMapViewOpening = isMapViewOpening_;
@synthesize longTapTimer     = longTapTimer_;
@synthesize timeCounter      = timeCounter_;

- (void)dealloc
{
  [centerMainButton_ release];
  [mapButton_        release];
  
  [mapViewController_ release];
  [utilityViewController_ release];
  [poketchViewController_ release];
  [utilityNavigationController_ release];
  [gameMainViewController_ release];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
#if DEBUG
    if (kPupulateData) {
      // Hard Initialize the DB Data for |Pokemon|
      [Pokemon populateData];
      [Move populateData];
    }
#endif
    
    // Updata all data for current User with the trainer ID
    [Trainer updateDataForTrainer:1];
    [TrainerTamedPokemon updateDataForTrainer:1];
    [WildPokemon updateDataForCurrentRegion:1];
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
  [super loadView];
  
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  self.view = view;
  [view release];
  
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewBackgroundBlack.png"]]];
  [self.view setOpaque:NO];
  
  // Base iVar Settings
  isMapViewOpening_ = NO;
  
  // Ball menu which locate at center
  UIButton * centerMainButton = [[UIButton alloc] initWithFrame:CGRectMake((320.0f - kCenterMainButtonSize) / 2,
                                                                           (480.0f - kCenterMainButtonSize) / 2,
                                                                           kCenterMainButtonSize,
                                                                           kCenterMainButtonSize)];
  
  self.centerMainButton = centerMainButton;
  [centerMainButton release];
  [self.centerMainButton setContentMode:UIViewContentModeScaleAspectFit];
  [self.centerMainButton setBackgroundImage:[UIImage imageNamed:@"MainViewCenterButtonBackground.png"]
                                   forState:UIControlStateNormal];
  [self.centerMainButton setImage:[UIImage imageNamed:@"MainViewCenterButtonImageNormal.png"] forState:UIControlStateNormal];
  [self.centerMainButton setOpaque:NO];
  [self.view addSubview:self.centerMainButton];
  
  // Register touch events for |centerMainButton_|
  [self.centerMainButton addTarget:self action:@selector(openBallMenuView:) forControlEvents:UIControlEventTouchUpInside];
  [self.centerMainButton addTarget:self action:@selector(countLongTapTimeWithAction:)
                  forControlEvents:UIControlEventTouchDown];
//  [self.centerMainButton addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
  
  // Map Button
  UIButton * mapButton = [[UIButton alloc] initWithFrame:CGRectMake((320.0f - kMapButtonSize) / 2,
                                                                    100.0f,
                                                                    kMapButtonSize,
                                                                    kMapButtonSize)];
  self.mapButton = mapButton;
  [mapButton release];
  [self.mapButton setContentMode:UIViewContentModeScaleAspectFit];
  [self.mapButton setBackgroundImage:[UIImage imageNamed:@"MainViewMapButtonBackground.png"]
                            forState:UIControlStateNormal];
  [self.mapButton setImage:[UIImage imageNamed:@"MainViewMapButtonImageNormal.png"] forState:UIControlStateNormal];
  [self.mapButton setOpaque:NO];
  [self.mapButton addTarget:self action:@selector(toggleMapView:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.mapButton];

/*
  // Poketch( Short for Pocket Watch ) View Controller
  PoketchTabViewController * pocktchViewController = [[PoketchTabViewController alloc] init];
  self.poketchViewController = pocktchViewController;
  [pocktchViewController release];
  [self.view addSubview:self.poketchViewController.view];
  
  // Utility View Controller
  UtilityViewController * utilityViewController = [[UtilityViewController alloc] init];
  self.utilityViewController = utilityViewController;
  [utilityViewController release];
  // Set |mapViewController_| as |utilityViewController_|'s |delegate|,
  // for |buttonLocateMe| & |buttonShowWorld|
  self.utilityViewController.delegate = (id <UtilityViewControllerDelegate>)self.mapViewController;
  [self.view addSubview:self.utilityViewController.view];
  
  // Game Main View
//  gameMainViewController_ = [[GameMainViewController alloc] init];
//  [self.view addSubview:gameMainViewController_.view];
*/
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.centerMainButton = nil;
  self.mapButton        = nil;
  
  self.mapViewController = nil;
  self.utilityViewController = nil;
  self.poketchViewController = nil;
  self.utilityNavigationController = nil;
  self.gameMainViewController = nil;
  
  [self.longTapTimer invalidate];
  self.longTapTimer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

// |centerMainButton_| touch up inside action
- (void)openBallMenuView:(id)sender
{
  [self.longTapTimer invalidate];
  
  // Do action based on tap down keepped time
  if (self.timeCounter <= 1) {
    if (! self.utilityNavigationController) {
      NSLog(@"--- MainViewController openBallMenuView if(!): Create new CustomNavigationController ---");    
      UtilityBallMenuViewController * utilityBallMenuViewController = [[UtilityBallMenuViewController alloc] init];
      utilityNavigationController_ = [CustomNavigationController initWithRootViewController:utilityBallMenuViewController
                                                               navigationBarBackgroundImage:[UIImage imageNamed:@"NavigationBarBackgroundBlue.png"]];
      [utilityBallMenuViewController release];
    }
    
    // |mapButton_|'s new Frame
    CGRect mapButtonFrame = self.mapButton.frame;
    mapButtonFrame.origin.y = - kMapButtonSize / 2;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                       [self.mapButton setFrame:mapButtonFrame];
                     }
                     completion:^(BOOL finished) {
                       [self.view addSubview:self.utilityNavigationController.view];
                       [[NSNotificationCenter defaultCenter] addObserver:self
                                                                selector:@selector(resetMainView:)
                                                                    name:kPMNResetMainView
                                                                  object:self.utilityViewController];
                     }];
  }
  else if (self.timeCounter <= 2) {
    NSLog(@"1 < time <= 2");
  }
}

// |centerMainButton_| touch down action
- (void)countLongTapTimeWithAction:(id)sender
{
  self.timeCounter = 0;
  self.longTapTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                       target:self
                                                     selector:@selector(increaseTimeWithAction)
                                                     userInfo:nil
                                                      repeats:YES];
}

// Method for counting Tap Down time
- (void)increaseTimeWithAction
{
  ++self.timeCounter;
}

// |mapButton_| action
- (void)toggleMapView:(id)sender
{
  CGRect mapViewFrame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
  CGRect mapButtonFrame = self.mapButton.frame;
  
  if (self.isMapViewOpening) {
    mapViewFrame.origin.y   = 480.0f;
    mapButtonFrame.origin.y = 100.0f;
  }
  else {
    mapButtonFrame.origin.y = - kMapButtonSize / 2;
    
    if (! self.mapViewController) {
      NSLog(@"--- MainViewController openMapView if(!): Create |mapViewController_| ---");
      MapViewController * mapViewController = [[MapViewController alloc] init];
      self.mapViewController = mapViewController;
      [mapViewController release];
    }
    [self.view insertSubview:self.mapViewController.view atIndex:1];
    
    // Set Map View to Offscreen
    mapViewFrame.origin.y = 480.0f;
    [self.mapViewController.view setFrame:mapViewFrame];
    mapViewFrame.origin.y = 0.0f;
  }
  
  [UIView animateWithDuration:0.3f
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     [self.mapViewController.view setFrame:mapViewFrame];
                     [self.mapButton setFrame:mapButtonFrame];
                   }
                   completion:^(BOOL finished) {
                     
                     self.isMapViewOpening = ! self.isMapViewOpening;
                     
                     if (self.isMapViewOpening)
                       [self.mapButton setImage:[UIImage imageNamed:@"MainViewMapButtonImageHalfCancel.png"]
                                       forState:UIControlStateNormal];
                     else {
                       [self.mapButton setImage:[UIImage imageNamed:@"MainViewMapButtonImageNormal.png"]
                                       forState:UIControlStateNormal];
                       [self.mapViewController.view removeFromSuperview];
                     }
                   }];
}

// Notification action methods
- (void)resetMainView:(NSNotification *)notification
{
  // |mapButton_|'s original Frame
  CGRect mapButtonFrame = self.mapButton.frame;
  mapButtonFrame.origin.y = 100.0f;
  
  [UIView animateWithDuration:0.3f
                        delay:0.0f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.mapButton setFrame:mapButtonFrame];
                   }
                   completion:nil];
  
  // Remove Notification
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNResetMainView object:self.utilityViewController];
}

@end
