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
#import "TrainerCoreDataController.h"
#import "CenterMainButtonTouchDownCircleView.h"
#import "LoginTableViewController.h"
#import "CustomNavigationController.h"
#import "CenterMenuUtilityViewController.h"
#import "CenterMenuSixPokemonsViewController.h"
#import "MapViewController.h"
#import "GameMainViewController.h"

#ifdef DEBUG
#import "OriginalDataManager.h"
#endif


@interface MainViewController () {
 @private
  CustomNavigationController          * centerMenuUtilityNavigationController_;
  CenterMenuUtilityViewController     * centerMenuUtilityViewController_;
  CustomNavigationController          * centerMenuSixPokemonsNavigationController_;
  CenterMenuSixPokemonsViewController * centerMenuSixPokemonsViewController_;
  CenterMainButtonTouchDownCircleView * centerMainButtonTouchDownCircleView_;
  MapViewController                   * mapViewController_;
  CustomNavigationController          * loginNavigationController_;
  LoginTableViewController            * loginTableViewController_;
 
  UIButton             * currentKeyButton_;
  CenterMainButtonStatus centerMainButtonStatus_;
  CenterMainButtonMessageSignal centerMainButtonMessageSignal_;
  BOOL                   isCenterMenuOpening_;
  NSTimer              * centerMenuOpenStatusTimer_;
  BOOL                   isCenterMainButtonTouchDownCircleViewLoading_;
  BOOL                   isMapViewOpening_;
  BOOL                   isGameMainViewOpening_;
  NSTimer              * longTapTimer_;
  NSInteger              centerMenuOpenStatusTimeCounter_;
  NSInteger              timeCounter_;
}

@property (nonatomic, retain) CustomNavigationController          * centerMenuUtilityNavigationController;
@property (nonatomic, retain) CenterMenuUtilityViewController     * centerMenuUtilityViewController;
@property (nonatomic, retain) CustomNavigationController          * centerMenuSixPokemonsNavigationController;
@property (nonatomic, retain) CenterMenuSixPokemonsViewController * centerMenuSixPokemonsViewController;
@property (nonatomic, retain) CenterMainButtonTouchDownCircleView * centerMainButtonTouchDownCircleView;
@property (nonatomic, retain) MapViewController                   * mapViewController;
@property (nonatomic, retain) CustomNavigationController          * loginNavigationController;
@property (nonatomic, retain) LoginTableViewController            * loginTableViewController;

@property (nonatomic, retain) UIButton             * currentKeyButton;
@property (nonatomic, assign) CenterMainButtonStatus centerMainButtonStatus;
@property (nonatomic, assign) CenterMainButtonMessageSignal centerMainButtonMessageSignal;
@property (nonatomic, assign) BOOL                   isCenterMenuOpening;
@property (nonatomic, retain) NSTimer              * centerMenuOpenStatusTimer;
@property (nonatomic, assign) BOOL                   isCenterMainButtonTouchDownCircleViewLoading;
@property (nonatomic, assign) BOOL                   isMapViewOpening;
@property (nonatomic, assign) BOOL                   isGameMainViewOpening;
@property (nonatomic, retain) NSTimer              * longTapTimer;
@property (nonatomic, assign) NSInteger              centerMenuOpenStatusTimeCounter;
@property (nonatomic, assign) NSInteger              timeCounter;

- (void)showLoginTableView:(NSNotification *)notification;
- (void)changeCenterMainButtonStatus:(NSNotification *)notification;
- (void)runCenterMainButtonTouchUpInsideAction:(id)sender;
- (void)openCenterMenuView;
- (void)closeCenterMenuView;
- (void)activateCenterMenuOpenStatusTimer;
- (void)deactivateCenterMenuOpenStatusTimer;
- (void)closeCenterMenuWhenLongTimeNoOperation;
- (void)countLongTapTimeWithAction:(id)sender;
- (void)increaseTimeWithAction;
- (void)toggleMapView:(id)sender;
- (void)toggleLocationService;
- (void)setButtonLayoutTo:(MainViewButtonLayout)buttonLayouts withCompletionBlock:(void (^)(BOOL finished))completion;

@end


@implementation MainViewController

@synthesize centerMainButton = centerMainButton_;
@synthesize mapButton        = mapButton_;
@synthesize gameMainViewController = gameMainViewController_;

@synthesize centerMenuUtilityNavigationController     = centerMenuUtilityNavigationController_;
@synthesize centerMenuUtilityViewController           = centerMenuUtilityViewController_;
@synthesize centerMenuSixPokemonsNavigationController = centerMenuSixPokemonsNavigationController_;
@synthesize centerMenuSixPokemonsViewController       = centerMenuSixPokemonsViewController_;
@synthesize centerMainButtonTouchDownCircleView       = centerMainButtonTouchDownCircleView_;
@synthesize mapViewController                         = mapViewController_;
@synthesize loginNavigationController                 = loginNavigationController_;
@synthesize loginTableViewController                  = loginTableViewController_;

@synthesize currentKeyButton                = currentKeyButton_;
@synthesize centerMainButtonStatus          = centerMainButtonStatus_;
@synthesize centerMainButtonMessageSignal   = centerMainButtonMessageSignal_;
@synthesize isCenterMenuOpening             = isCenterMenuOpening_;
@synthesize centerMenuOpenStatusTimer       = centerMenuOpenStatusTimer_;
@synthesize isCenterMainButtonTouchDownCircleViewLoading = isCenterMainButtonTouchDownCircleViewLoading_;
@synthesize isMapViewOpening                = isMapViewOpening_;
@synthesize isGameMainViewOpening           = isGameMainViewOpening_;
@synthesize longTapTimer                    = longTapTimer_;
@synthesize centerMenuOpenStatusTimeCounter = centerMenuOpenStatusTimeCounter_;
@synthesize timeCounter                     = timeCounter_;

- (void)dealloc
{
  [centerMainButton_ release];
  [mapButton_        release];
  [gameMainViewController_ release];
  
  self.centerMenuUtilityNavigationController     = nil;
  self.centerMenuUtilityViewController           = nil;
  self.centerMenuSixPokemonsNavigationController = nil;
  self.centerMenuSixPokemonsViewController       = nil;
  self.centerMainButtonTouchDownCircleView       = nil;
  self.mapViewController                         = nil;
  self.loginNavigationController                 = nil;
  self.loginTableViewController                  = nil;
  
  self.currentKeyButton = nil;
  
  // Remove notification observers
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kPMNSessionIsInvalid
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kPMNChangeCenterMainButtonStatus
                                                object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kPMNPokemonAppeared
                                                object:self.mapViewController];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kPMNBattleEnd
                                                object:self.gameMainViewController];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
#ifdef DEBUG_PREINIT_POPULATE_DATA
    // Hard Initialize the Core Data
    [OriginalDataManager initData];
#endif
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  self.view = view;
  [view release];
  
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:
                                 [UIImage imageNamed:@"MainViewBackgroundBlackWithFog.png"]]];
  [self.view setOpaque:NO];
  
  // Base iVar Settings
  centerMainButtonStatus_        = kCenterMainButtonStatusNormal;
  centerMainButtonMessageSignal_ = kCenterMainButtonMessageSignalNone;
  isCenterMenuOpening_    = NO;
  isCenterMainButtonTouchDownCircleViewLoading_ = NO;
  isMapViewOpening_       = NO;
  isGameMainViewOpening_  = NO;
  
  // Add self as Notification observer
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(showLoginTableView:)
                                               name:kPMNSessionIsInvalid
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(changeCenterMainButtonStatus:)
                                               name:kPMNChangeCenterMainButtonStatus
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(changeCenterMainButtonStatus:)
                                               name:kPMNPokemonAppeared
                                             object:self.mapViewController];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(changeCenterMainButtonStatus:)
                                               name:kPMNBattleEnd
                                             object:self.gameMainViewController];
  
  // Ball menu which locate at center
  UIButton * centerMainButton = [[UIButton alloc] initWithFrame:CGRectMake((kViewWidth - kCenterMainButtonSize) / 2,
                                                                           (kViewHeight - kCenterMainButtonSize) / 2,
                                                                           kCenterMainButtonSize,
                                                                           kCenterMainButtonSize)];
  
  self.centerMainButton = centerMainButton;
  [centerMainButton release];
  [self.centerMainButton setContentMode:UIViewContentModeScaleAspectFit];
  [self.centerMainButton setBackgroundImage:[UIImage imageNamed:@"MainViewCenterButtonBackground.png"]
                                   forState:UIControlStateNormal];
  [self.centerMainButton setImage:[UIImage imageNamed:@"MainViewCenterButtonImageNormal.png"] forState:UIControlStateNormal];
  [self.centerMainButton setOpaque:NO];
  [self.centerMainButton setTag:kTagMainViewCenterMainButton];
  [self.view addSubview:self.centerMainButton];
  
  // Register touch events for |centerMainButton_|
  [self.centerMainButton addTarget:self
                            action:@selector(runCenterMainButtonTouchUpInsideAction:)
                  forControlEvents:UIControlEventTouchUpInside];
  [self.centerMainButton addTarget:self
                            action:@selector(countLongTapTimeWithAction:)
                  forControlEvents:UIControlEventTouchDown];
  
  // Map Button
  UIButton * mapButton = [[UIButton alloc] initWithFrame:CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                                                    100.f,
                                                                    kMapButtonSize,
                                                                    kMapButtonSize)];
  self.mapButton = mapButton;
  [mapButton release];
  [self.mapButton setContentMode:UIViewContentModeScaleAspectFit];
  [self.mapButton setBackgroundImage:[UIImage imageNamed:@"MainViewMapButtonBackground.png"]
                            forState:UIControlStateNormal];
  [self.mapButton setImage:[UIImage imageNamed:@"MainViewMapButtonImageNormal.png"] forState:UIControlStateNormal];
  [self.mapButton setOpaque:NO];
  [self.mapButton setTag:kTagMainViewMapButton];
  [self.mapButton addTarget:self action:@selector(toggleMapView:) forControlEvents:UIControlEventTouchUpInside];
  [self.mapButton addTarget:self action:@selector(countLongTapTimeWithAction:) forControlEvents:UIControlEventTouchDown];
  [self.view addSubview:self.mapButton];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
#ifndef DEBUG_PREINIT_POPULATE_DATA
  // Game Main View
  gameMainViewController_ = [[GameMainViewController alloc] init];
  [self.view insertSubview:gameMainViewController_.view belowSubview:centerMainButton_];
#endif
#ifdef DEBUG_DEFAULT_VIEW_GAME_BATTLE
  //#if defined (DEBUG_DEFAULT_VIEW_GAME_BATTLE)
  self.centerMainButtonMessageSignal = kCenterMainButtonMessageSignalPokemonAppeared;
  [self.centerMainButton setImage:[UIImage imageNamed:@"MainViewMapButtonImageLBSDisabled.png"]
                         forState:UIControlStateNormal];
  [self runCenterMainButtonTouchUpInsideAction:nil];
#endif
  
  // If the user has logged in (Session is Invalid), sync data between Client & Server.
  //   Else, post notification to show login table view to choose OAuth Service Provider
  // Session is checked at |TrainerCoreDataController|'s class method:|sharedInstance|,
  //   and Notification is also sent at there.
  [[TrainerCoreDataController sharedInstance] sync];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.centerMainButton = nil;
  self.mapButton        = nil;
  self.gameMainViewController = nil;
  
  self.centerMenuUtilityNavigationController     = nil;
  self.centerMenuUtilityViewController           = nil;
  self.centerMenuSixPokemonsNavigationController = nil;
  self.centerMenuSixPokemonsViewController       = nil;
  self.centerMainButtonTouchDownCircleView       = nil;
  self.mapViewController                         = nil;
  self.loginNavigationController                 = nil;
  self.loginTableViewController                  = nil;
  
  [self.longTapTimer invalidate];
  self.longTapTimer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

// Show login table view if user session is invalid
- (void)showLoginTableView:(NSNotification *)notification {
  if (self.loginNavigationController == nil) {
    if (self.loginTableViewController == nil) {
      LoginTableViewController * loginTableViewController;
      loginTableViewController = [[LoginTableViewController alloc] initWithStyle:UITableViewStylePlain];
      self.loginTableViewController = loginTableViewController;
      [loginTableViewController release];
    }
    loginNavigationController_ =
      [CustomNavigationController initWithRootViewController:self.loginTableViewController
                                navigationBarBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground.png"]];
    [loginNavigationController_.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
    [loginNavigationController_ setNavigationBarHidden:NO];
  }
  [self.view addSubview:loginNavigationController_.view];
}

// Slide |centerMainButton_| to view bottom when button in center menu is clicked
- (void)changeCenterMainButtonStatus:(NSNotification *)notification
{
  switch ([[notification.userInfo objectForKey:@"centerMainButtonStatus"] intValue]) {
    case kCenterMainButtonStatusAtBottom:
      self.centerMainButtonStatus = kCenterMainButtonStatusAtBottom;
      [self setButtonLayoutTo:kMainViewButtonLayoutCenterMainButtonToBottom | kMainViewButtonLayoutMapButtonToOffcreen
          withCompletionBlock:nil];
      [self deactivateCenterMenuOpenStatusTimer];
      break;
      
    case kCenterMainButtonStatusPokemonAppeared:
      self.centerMainButtonMessageSignal = kCenterMainButtonMessageSignalPokemonAppeared;
      [self.centerMainButton setImage:[UIImage imageNamed:@"MainViewMapButtonImageLBSDisabled.png"]
                             forState:UIControlStateNormal];
      break;
      
    case kCenterMainButtonStatusNormal:
    default:
      if (self.isGameMainViewOpening) {
        self.centerMainButtonMessageSignal = kCenterMainButtonMessageSignalNone;
        CenterMainButtonStatus previousCenterMainButtonStatus = [[notification.userInfo objectForKey:@"previousCenterMainButtonStatus"] intValue];
        self.centerMainButtonStatus = previousCenterMainButtonStatus;
        
        if (previousCenterMainButtonStatus != kCenterMainButtonStatusAtBottom) {
          if (self.isCenterMenuOpening) {
            [self setButtonLayoutTo:kMainViewButtonLayoutMapButtonToTop withCompletionBlock:nil];
            [self activateCenterMenuOpenStatusTimer];
          }
          else [self setButtonLayoutTo:kMainViewButtonLayoutNormal withCompletionBlock:nil];
        }
        self.isGameMainViewOpening = NO;
      }
      else {
        self.centerMainButtonStatus = kCenterMainButtonStatusNormal;
        [self setButtonLayoutTo:kMainViewButtonLayoutMapButtonToTop withCompletionBlock:nil];
        // Is |centerMenu_| is opening, activate |centerMenuOpenStatusTimer_|
        if (self.isCenterMenuOpening) [self activateCenterMenuOpenStatusTimer];
      }
      break;
  }
}

// |centerMainButton_| touch up inside action
- (void)runCenterMainButtonTouchUpInsideAction:(id)sender
{
  // If Pokemon Appeared, and got a message, deal with it
  if (self.centerMainButtonMessageSignal == kCenterMainButtonMessageSignalPokemonAppeared
      && self.centerMainButtonStatus != kCenterMainButtonStatusPokemonAppeared) {
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
      NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSNumber numberWithInt:self.centerMainButtonStatus],
                                 @"previousCenterMainButtonStatus", nil];
      // The observer is |GameMainViewController|
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNBattleStart object:self userInfo:userInfo];
      [userInfo release];
      [self.centerMainButton setImage:[UIImage imageNamed:@"MainViewCenterButtonImageNormal.png"]
                             forState:UIControlStateNormal];
      self.isGameMainViewOpening  = YES;
      self.centerMainButtonStatus = kCenterMainButtonStatusPokemonAppeared;
      [self deactivateCenterMenuOpenStatusTimer];
    };
    // If |centerMainButton_| is not at view bottom, move it to bottom
    if (self.centerMainButtonStatus != kCenterMainButtonStatusAtBottom)
      [self setButtonLayoutTo:kMainViewButtonLayoutCenterMainButtonToBottom | kMainViewButtonLayoutMapButtonToOffcreen
          withCompletionBlock:completionBlock];
    else completionBlock(YES);
    return;
  }
  
  // Do basic actions for touch up inside button
  switch (self.centerMainButtonStatus) {
    case kCenterMainButtonStatusAtBottom:
      // The observer is |CustomTabViewController|
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNToggleTabBar object:self userInfo:nil];
      break;
      
    case kCenterMainButtonStatusPokemonAppeared:
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNToggleSixPokemons object:self userInfo:nil];
      break;
    
    case kCenterMainButtonStatusNormal:
    default:
      if (self.isCenterMenuOpening) [self closeCenterMenuView];
      else {
        [self openCenterMenuView];
        // Activate |centerMenuOpenStatusTimer_|
        [self activateCenterMenuOpenStatusTimer];
      }
      break;
  }
}

// Method for opening center menu view when |isCenterMenuOpening_ == NO|
- (void)openCenterMenuView
{
  [self.longTapTimer invalidate];
  
  // Stop |centerMainButtonTouchDownCircleView_| loading
  [self.centerMainButtonTouchDownCircleView stopAnimation];
  self.isCenterMainButtonTouchDownCircleViewLoading = NO;
  
  // Declare a block for animation completion action
  void (^completionBlock)(BOOL);
  
  // Do action based on tap down keepped time
  // Utility Menu
  if (self.timeCounter < 3.f) {
    if (! self.centerMenuUtilityNavigationController) {
      NSLog(@"--- MainViewController openBallMenuView if(!): Create new CustomNavigationController ---");
      if (! self.centerMenuUtilityViewController) {
        CenterMenuUtilityViewController * centerMenuUtilityViewController = [[CenterMenuUtilityViewController alloc]
                                                                             initWithButtonCount:6];
        self.centerMenuUtilityViewController = centerMenuUtilityViewController;
        [centerMenuUtilityViewController release];
      }
      centerMenuUtilityNavigationController_ = [CustomNavigationController
                                      initWithRootViewController:self.centerMenuUtilityViewController
                                    navigationBarBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground.png"]];
      [centerMenuUtilityNavigationController_.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
    }
    
    // Insert |utilityNavigationController|'s view
    [self.view insertSubview:self.centerMenuUtilityNavigationController.view belowSubview:self.gameMainViewController.view];
    
    // Implement the completion block
    // iOS4 will not call |viewWillAppear:| when the VC is a child of another VC
    //    if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    //      [self.centerMenuUtilityViewController viewWillAppear:YES];
    completionBlock = ^(BOOL finished) {[self.centerMenuUtilityViewController openCenterMenuView];};
  }
  // Six Pokemons Menu
  else if (self.timeCounter <= 5) {
    if (! self.centerMenuSixPokemonsNavigationController) {
      if (! self.centerMenuSixPokemonsViewController) {
        CenterMenuSixPokemonsViewController * centerMenuSixPokemonsViewController = [[CenterMenuSixPokemonsViewController alloc] initWithButtonCount:3];
        self.centerMenuSixPokemonsViewController = centerMenuSixPokemonsViewController;
        [centerMenuSixPokemonsViewController release];
      }
      centerMenuSixPokemonsNavigationController_ = [CustomNavigationController
                                                    initWithRootViewController:self.centerMenuSixPokemonsViewController
                                                    navigationBarBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground.png"]];
      [centerMenuSixPokemonsNavigationController_.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
    }
    [self.view insertSubview:self.centerMenuSixPokemonsNavigationController.view belowSubview:self.gameMainViewController.view];
    
    // Implement the completion block
    completionBlock = ^(BOOL finished) {[self.centerMenuSixPokemonsViewController openCenterMenuView];};
  }
  else {
    self.isCenterMenuOpening = NO; // !!! Need to be remove
    return;
  }
  
  // Animation for |mapButton_|'s new Frame
  [self setButtonLayoutTo:kMainViewButtonLayoutMapButtonToTop withCompletionBlock:completionBlock];
  self.isCenterMenuOpening = YES;
}

// Method for close center menu view when |isCenterMenuOpening_ == YES|
- (void)closeCenterMenuView
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNCloseCenterMenu
                                                      object:self
                                                    userInfo:nil];
  [self setButtonLayoutTo:kMainViewButtonLayoutNormal withCompletionBlock:nil];
  [self deactivateCenterMenuOpenStatusTimer];
  self.isCenterMenuOpening = NO;
}

// Activate |centerMenuOpenStatusTimer_| to count how many time the |centerMenu_| is open without any operation,
// Close the |centerMenu_| when necessary
- (void)activateCenterMenuOpenStatusTimer
{
  self.centerMenuOpenStatusTimeCounter = 0;
  self.centerMenuOpenStatusTimer = [NSTimer scheduledTimerWithTimeInterval:5.f
                                                                    target:self
                                                                  selector:@selector(closeCenterMenuWhenLongTimeNoOperation)
                                                                  userInfo:nil
                                                                   repeats:YES];
}

// Stop |centerMenuOpenStatusTimer_| when button clicked
- (void)deactivateCenterMenuOpenStatusTimer {
  [self.centerMenuOpenStatusTimer invalidate];
}

// Close |centerMenu_| when long time no operation 
- (void)closeCenterMenuWhenLongTimeNoOperation
{
  self.centerMenuOpenStatusTimeCounter += 5;
  NSLog(@"%d", self.centerMenuOpenStatusTimeCounter);
  if (self.centerMenuOpenStatusTimeCounter == 10) {
    [self closeCenterMenuView];
    [self.centerMenuOpenStatusTimer invalidate];
  }
}

// |centerMainButton_| touch down action
- (void)countLongTapTimeWithAction:(id)sender
{
  if (! self.isCenterMenuOpening && self.centerMainButtonMessageSignal != kCenterMainButtonMessageSignalPokemonAppeared) {
    // Start time counting
    self.currentKeyButton = (UIButton *)sender;
    self.timeCounter  = 0;
    [self.longTapTimer invalidate];
    self.longTapTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                         target:self
                                                       selector:@selector(increaseTimeWithAction)
                                                       userInfo:nil
                                                        repeats:YES];
  }
}

// Method for counting Tap Down time
- (void)increaseTimeWithAction
{
  ++self.timeCounter;
  NSLog(@"Touch Keep Time: %d", self.timeCounter);
  
  NSInteger buttonTag = self.currentKeyButton.tag;
  
  // If the target is |centerMainButton_|, and |timeCounter_ >= 1.0|, loading it
  // Time: delay 1.0 second, then every 2.0 second got a new point
  if (! self.isCenterMainButtonTouchDownCircleViewLoading && buttonTag == kTagMainViewCenterMainButton
      && ! self.isCenterMenuOpening && self.timeCounter >= 1.f)
  {
    // Run this block after |mapButton_| moved to view top
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
      NSLog(@"increaseTimeWithAction - Start loading |centerMainButtonTouchDownCircleView|...");
      self.isCenterMainButtonTouchDownCircleViewLoading = YES;
      
      // Loading |centerMainButtonTouchDownCircleView_|
      if (! self.centerMainButtonTouchDownCircleView) {
        CenterMainButtonTouchDownCircleView * centerMainButtonTouchDownCircleView
        = [[CenterMainButtonTouchDownCircleView alloc]
           initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - kCenterMainButtonTouchDownCircleViewSize / 2,
                                    CGRectGetMidY(self.view.frame) - kCenterMainButtonTouchDownCircleViewSize / 2 - 20.f,
                                    kCenterMainButtonTouchDownCircleViewSize,
                                    kCenterMainButtonTouchDownCircleViewSize)];
        self.centerMainButtonTouchDownCircleView = centerMainButtonTouchDownCircleView;
        [centerMainButtonTouchDownCircleView release];
      }
      [self.view insertSubview:self.centerMainButtonTouchDownCircleView belowSubview:self.centerMainButton];
      [self.centerMainButtonTouchDownCircleView startAnimation];
    };
    
    // Move |mapButton_| to view top
    [self setButtonLayoutTo:kMainViewButtonLayoutMapButtonToTop withCompletionBlock:completionBlock];
  }
  
  // If keep tapping the |mapButton_| long time until... do |toggleLocationService|
  else if (buttonTag == kTagMainViewMapButton && self.timeCounter >= 3.f) {
    [self toggleLocationService];
    [self.longTapTimer invalidate];
  }
}

// |mapButton_| action
- (void)toggleMapView:(id)sender
{
  [self.longTapTimer invalidate];
  // If Location Service is not allowed, do nothing
  if (! [[NSUserDefaults standardUserDefaults] boolForKey:@"keyAppSettingsLocationServices"] || self.timeCounter >= 6.f)
    return;
  
  // Else, just normal button action
  CGRect mapViewFrame   = CGRectMake(0.f, 0.f, kViewWidth, kViewHeight);
  CGRect mapButtonFrame = CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                     100.f,
                                     kMapButtonSize,
                                     kMapButtonSize);
  
  if (self.isMapViewOpening) {
    mapViewFrame.origin.y   = kViewHeight;
    mapButtonFrame.origin.y = 100.f;
  }
  else {
    mapButtonFrame.origin.y = - kMapButtonSize / 2;
    
    if (! self.mapViewController) {
      NSLog(@"--- MainViewController openMapView if(!): Create |mapViewController_| ---");
      MapViewController * mapViewController = [[MapViewController alloc] init];
      self.mapViewController = mapViewController;
      [mapViewController release];
    }
    [self.view insertSubview:self.mapViewController.view belowSubview:self.mapButton];
    
    // Set Map View to Offscreen
    mapViewFrame.origin.y = kViewHeight;
    [self.mapViewController.view setFrame:mapViewFrame];
    mapViewFrame.origin.y = 0.f;
  }
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     // If |mapView| is not open while |centerMenu_| is open, just close |centerMenu_|
                     // Else, set |mapButton_| to view top
                     if (! self.isMapViewOpening && self.isCenterMenuOpening) {
                       [[NSNotificationCenter defaultCenter] postNotificationName:kPMNCloseCenterMenu
                                                                           object:self
                                                                         userInfo:nil];
                       self.isCenterMenuOpening = NO;
                       [self deactivateCenterMenuOpenStatusTimer];
                     }
                     else [self.mapButton setFrame:mapButtonFrame];
                       
                     // Set frame of the |mapViewController_|'s view to show it
                     [self.mapViewController.view setFrame:mapViewFrame];
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

// Toggle Location Service after long press on |mapButton_|
- (void)toggleLocationService
{
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  if ([userDefaults boolForKey:@"keyAppSettingsLocationServices"]) {
    NSLog(@"Service is on, turn off");
    [userDefaults setBool:NO forKey:@"keyAppSettingsLocationServices"];
    [self.mapButton setImage:[UIImage imageNamed:@"MainViewMapButtonImageLBSDisabled.png"] forState:UIControlStateNormal];
  }
  else {
    NSLog(@"Service is off, turn on");
    [userDefaults setBool:YES forKey:@"keyAppSettingsLocationServices"];
    [self.mapButton setImage:[UIImage imageNamed:@"MainViewMapButtonImageNormal.png"] forState:UIControlStateNormal];
  }
  NSLog(@"%d", [[userDefaults objectForKey:@"keyAppSettingsLocationServices"] intValue]);
}

// Set layouts for buttons
- (void)setButtonLayoutTo:(MainViewButtonLayout)buttonLayouts withCompletionBlock:(void (^)(BOOL))completion
{
  void (^animationBlock)() = ^(){
    CGRect centerMainButtonFrame = CGRectMake((kViewWidth - kCenterMainButtonSize) / 2,
                                              (kViewHeight - kCenterMainButtonSize) / 2,
                                              kCenterMainButtonSize,
                                              kCenterMainButtonSize);
    CGRect mapButtonFrame        = CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                              100.f,
                                              kMapButtonSize,
                                              kMapButtonSize);
    
    if (buttonLayouts & kMainViewButtonLayoutCenterMainButtonToBottom)
        centerMainButtonFrame.origin.y = kViewHeight - kCenterMainButtonSize / 2;
    if (buttonLayouts & kMainViewButtonLayoutCenterMainButtonToOffcreen)
        centerMainButtonFrame.origin.y = kViewHeight;
    if (buttonLayouts & kMainViewButtonLayoutMapButtonToTop)
        mapButtonFrame.origin.y = - kMapButtonSize / 2;
    if (buttonLayouts & kMainViewButtonLayoutMapButtonToOffcreen)
        mapButtonFrame.origin.y = - kMapButtonSize;
        
    [self.centerMainButton setFrame:centerMainButtonFrame];
    [self.mapButton        setFrame:mapButtonFrame];
  };
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:animationBlock
                   completion:completion];
}

@end
