//
//  MainViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MainViewController.h"

#import "TrainerController.h"
#import "CenterMainButtonTouchDownCircleView.h"
#import "FullScreenLoadingViewController.h"
#import "LoginTableViewController.h"
#import "NewbieGuideViewController.h"
#import "HelpViewController.h"
#import "CustomNavigationController.h"
#import "CenterMenuUtilityViewController.h"
#import "CenterMenuSixPokemonsViewController.h"
#import "MapViewController.h"
#import "GameMainViewController.h"

#ifdef DEBUG_PREINIT_POPULATE_DATA
#import "OriginalDataManager.h"
#endif


@interface MainViewController () {
 @private
  FullScreenLoadingViewController     * fullScreenLoadingViewController_;
  GameMainViewController              * gameMainViewController_;
  CustomNavigationController          * customNavigationController_;
  CenterMenuUtilityViewController     * centerMenuUtilityViewController_;
  CenterMenuSixPokemonsViewController * centerMenuSixPokemonsViewController_;
  MapViewController                   * mapViewController_;
  LoginTableViewController            * loginTableViewController_;
  NewbieGuideViewController           * newbieGuideViewController_;
  HelpViewController                  * helpViewController_;
 
  CenterMainButtonTouchDownCircleView * centerMainButtonTouchDownCircleView_;
  UIButton                      * centerMainButton_;
  UIButton                      * mapButton_;
  UIButton                      * currentKeyButton_;
  NSTimer                       * centerMenuOpenStatusTimer_;
  NSTimer                       * longTapTimer_;
  CenterMainButtonStatus          centerMainButtonStatus_;
  CenterMainButtonMessageSignal   centerMainButtonMessageSignal_;
  BOOL                            isCenterMenuOpening_;
  BOOL                            isCenterMainButtonTouchDownCircleViewLoading_;
  BOOL                            isMapViewOpening_;
  BOOL                            isGameMainViewOpening_;
  NSInteger                       centerMenuOpenStatusTimeCounter_;
  NSInteger                       timeCounter_;
}

@property (nonatomic, retain) FullScreenLoadingViewController     * fullScreenLoadingViewController;
@property (nonatomic, retain) GameMainViewController              * gameMainViewController;
@property (nonatomic, retain) CustomNavigationController          * customNavigationController;
@property (nonatomic, retain) CenterMenuUtilityViewController     * centerMenuUtilityViewController;
@property (nonatomic, retain) CenterMenuSixPokemonsViewController * centerMenuSixPokemonsViewController;
@property (nonatomic, retain) MapViewController                   * mapViewController;
@property (nonatomic, retain) LoginTableViewController            * loginTableViewController;
@property (nonatomic, retain) NewbieGuideViewController           * newbieGuideViewController;
@property (nonatomic, retain) HelpViewController                  * helpViewController;

@property (nonatomic, retain) CenterMainButtonTouchDownCircleView * centerMainButtonTouchDownCircleView;
@property (nonatomic, retain) UIButton             * centerMainButton;
@property (nonatomic, retain) UIButton             * mapButton;
@property (nonatomic, retain) UIButton             * currentKeyButton;
@property (nonatomic, retain) NSTimer              * centerMenuOpenStatusTimer;
@property (nonatomic, retain) NSTimer              * longTapTimer;

- (void)releaseSubviews;
- (void)_resetAll;
- (void)showFullScreenLoadingView:(NSNotification *)notification;
- (void)showLoginTableView:(NSNotification *)notification;
- (void)showNewbieGuideView:(NSNotification *)notification;
- (void)showHelpView:(id)sender;
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
- (void)unloadGameBattleScene:(NSNotification *)notification;
- (void)updateLocationService:(NSNotification *)notification;
- (void)toggleLocationService;
- (void)setButtonLayoutTo:(MainViewButtonLayout)buttonLayouts withCompletionBlock:(void (^)(BOOL finished))completion;

@end


@implementation MainViewController

@synthesize fullScreenLoadingViewController     = fullScreenLoadingViewController_;
@synthesize gameMainViewController              = gameMainViewController_;
@synthesize customNavigationController          = customNavigationController_;
@synthesize centerMenuUtilityViewController     = centerMenuUtilityViewController_;
@synthesize centerMenuSixPokemonsViewController = centerMenuSixPokemonsViewController_;
@synthesize mapViewController                   = mapViewController_;
@synthesize loginTableViewController            = loginTableViewController_;
@synthesize newbieGuideViewController           = newbieGuideViewController_;
@synthesize helpViewController                  = helpViewController_;

@synthesize centerMainButtonTouchDownCircleView = centerMainButtonTouchDownCircleView_;
@synthesize centerMainButton                = centerMainButton_;
@synthesize mapButton                       = mapButton_;
@synthesize currentKeyButton                = currentKeyButton_;
@synthesize centerMenuOpenStatusTimer       = centerMenuOpenStatusTimer_;
@synthesize longTapTimer                    = longTapTimer_;

- (void)dealloc {
  self.fullScreenLoadingViewController     = nil;
  self.gameMainViewController              = nil;
  self.customNavigationController          = nil;
  self.centerMenuUtilityViewController     = nil;
  self.centerMenuSixPokemonsViewController = nil;
  self.mapViewController                   = nil;
  self.loginTableViewController            = nil;
  self.newbieGuideViewController           = nil;
  self.helpViewController                  = nil;
  
  [self releaseSubviews];
  [self.longTapTimer invalidate];
  self.centerMenuOpenStatusTimer = nil;
  self.longTapTimer              = nil;
  
  // Remove notification observers
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNError object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNSessionIsInvalid object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNShowNewbieGuide object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNUDGeneralLocationServices object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNChangeCenterMainButtonStatus object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNPokemonAppeared object:nil]; // self.mapViewController
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNBattleEnd object:nil];
  [super dealloc];
}

// Release any retained subviews of the main view.
- (void)releaseSubviews {
  self.centerMainButtonTouchDownCircleView = nil;
  self.centerMainButton                    = nil;
  self.mapButton                           = nil;
  self.currentKeyButton                    = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
#ifdef DEBUG_PREINIT_POPULATE_DATA
    // Hard Initialize the Core Data
    [OriginalDataManager initData];
#endif
    // Base iVar Settings
    centerMainButtonStatus_        = kCenterMainButtonStatusNormal;
    centerMainButtonMessageSignal_ = kCenterMainButtonMessageSignalNone;
    isCenterMenuOpening_    = NO;
    isCenterMainButtonTouchDownCircleViewLoading_ = NO;
    isMapViewOpening_       = NO;
    isGameMainViewOpening_  = NO;
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINLaunchViewBackground]]];
  [view setOpaque:NO];
  self.view = view;
  [view release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  
  // Ball menu which locate at center
  UIButton * centerMainButton = [[UIButton alloc] initWithFrame:CGRectMake((kViewWidth - kCenterMainButtonSize) / 2,
                                                                           (kViewHeight - kCenterMainButtonSize) / 2,
                                                                           kCenterMainButtonSize,
                                                                           kCenterMainButtonSize)];
  
  self.centerMainButton = centerMainButton;
  [centerMainButton release];
  [self.centerMainButton setContentMode:UIViewContentModeScaleAspectFit];
  [self.centerMainButton setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                                   forState:UIControlStateNormal];
  [self.centerMainButton setImage:[UIImage imageNamed:kPMINMainButtonNormal] forState:UIControlStateNormal];
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
  [self.mapButton setBackgroundImage:[UIImage imageNamed:kPMINMapButtonBackgound]
                            forState:UIControlStateNormal];
  if ([userDefaults boolForKey:kUDKeyGeneralLocationServices])
    [self.mapButton setImage:[UIImage imageNamed:kPMINMapButtonNormal] forState:UIControlStateNormal];
  else [self.mapButton setImage:[UIImage imageNamed:kPMINMapButtonDisabled] forState:UIControlStateNormal];
  [self.mapButton setOpaque:NO];
  [self.mapButton setTag:kTagMainViewMapButton];
  [self.mapButton addTarget:self action:@selector(toggleMapView:) forControlEvents:UIControlEventTouchUpInside];
  [self.mapButton addTarget:self action:@selector(countLongTapTimeWithAction:) forControlEvents:UIControlEventTouchDown];
  [self.view addSubview:self.mapButton];
  
  // Init |mapViewController_| to run location tracking,
  //   if enable location tracking, it'll do tracking
  //   otherwise, just add observer for notification when enable trakcing
  mapViewController_ = [[MapViewController alloc] initWithLocationTracking];
  
  
  // Add self as Notification observer
  // Notification from |OAuthManager| when cannot connet to server
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(showFullScreenLoadingView:)
                                               name:kPMNError
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(showLoginTableView:)
                                               name:kPMNSessionIsInvalid
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(showNewbieGuideView:)
                                               name:kPMNShowNewbieGuide
                                             object:nil]; // From |TrainerController|
  // Notification from |SettingTableViewController|,
  //   when the value of Switch button for Location service changed
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateLocationService:)
                                               name:kPMNUDGeneralLocationServices
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(changeCenterMainButtonStatus:)
                                               name:kPMNChangeCenterMainButtonStatus
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(changeCenterMainButtonStatus:)
                                               name:kPMNPokemonAppeared
                                             object:nil]; // self.mapViewController
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(unloadGameBattleScene:)
                                               name:kPMNBattleEnd
                                             object:nil];
  
//#ifndef DEBUG_PREINIT_POPULATE_DATA
//  // Game Main View
//  gameMainViewController_ = [[GameMainViewController alloc] init];
//  [self.view insertSubview:gameMainViewController_.view belowSubview:centerMainButton_];
//#endif
#ifdef DEBUG_DEFAULT_VIEW_GAME_BATTLE
  //#if defined (DEBUG_DEFAULT_VIEW_GAME_BATTLE)
  centerMainButtonMessageSignal_ = kCenterMainButtonMessageSignalPokemonAppeared;
  [self.centerMainButton setImage:[UIImage imageNamed:kPMINMainButtonWarning]
                         forState:UIControlStateNormal];
  [self runCenterMainButtonTouchUpInsideAction:nil];
#endif
  
  // If the user has logged in (Session is Invalid), sync data between Client & Server.
  //   Else, post notification to show login table view to choose OAuth Service Provider
  // Session is checked at |TrainerCoreDataController|'s class method:|sharedInstance|,
  //   and Notification is also sent at there.
  [[TrainerController sharedInstance] sync];
//  [self showHelpView:nil];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self releaseSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

// Reset all to original
- (void)_resetAll {
  centerMainButtonStatus_        = kCenterMainButtonStatusNormal;
  centerMainButtonMessageSignal_ = kCenterMainButtonMessageSignalNone;
  isCenterMenuOpening_                          = NO;
  isCenterMainButtonTouchDownCircleViewLoading_ = NO;
  isMapViewOpening_                             = NO;
  isGameMainViewOpening_                        = NO;
  for (UIViewController * vc in [self.customNavigationController childViewControllers])
    [vc.view removeFromSuperview];
  self.fullScreenLoadingViewController     = nil;
  self.centerMenuUtilityViewController     = nil;
  self.centerMenuSixPokemonsViewController = nil;
  self.loginTableViewController            = nil;
  self.newbieGuideViewController           = nil;
  self.helpViewController                  = nil;
  self.customNavigationController          = nil;
  self.gameMainViewController              = nil;
  [self setButtonLayoutTo:kMainViewButtonLayoutNormal withCompletionBlock:nil];
}

// Show full screen loading view
- (void)showFullScreenLoadingView:(NSNotification *)notification {
  PMError error = [[notification.userInfo valueForKey:@"error"] intValue];
  if (! error)
    return;
  
  // Load view for different ERROR
  FullScreenLoadingViewController * fullScreenLoadingViewController;
  fullScreenLoadingViewController = [[FullScreenLoadingViewController alloc] init];
  self.fullScreenLoadingViewController = fullScreenLoadingViewController;
  [fullScreenLoadingViewController release];
  [self.view addSubview:self.fullScreenLoadingViewController.view];
  [self.fullScreenLoadingViewController loadViewForError:error animated:YES];
}

// Show login table view if user session is invalid
- (void)showLoginTableView:(NSNotification *)notification {
  [self _resetAll];
  
  // Login table view controller
  LoginTableViewController * loginTableViewController;
  loginTableViewController = [[LoginTableViewController alloc] initWithStyle:UITableViewStylePlain];
  self.loginTableViewController = loginTableViewController;
  [loginTableViewController release];
  
  // Create custom NVC
  CustomNavigationController * customNavigationController = [CustomNavigationController alloc];
  [customNavigationController initWithRootViewController:self.loginTableViewController];
  self.customNavigationController = customNavigationController;
  [customNavigationController release];
  [self.customNavigationController.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  [self.loginTableViewController.view setAlpha:0.f];
  // Insert |utilityNavigationController|'s view
  [self.view addSubview:self.customNavigationController.view];
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseOut
                   animations:^{
                     [self.loginTableViewController.view setAlpha:1.f];
                   }
                   completion:nil];
}

// Show guide view for newbie (new trainer)
- (void)showNewbieGuideView:(NSNotification *)notification {
#ifdef DEBUG_TEST_FLIGHT
  [TestFlight passCheckpoint:@"CHECK_POINT: Open Newbie Guide View"];
#endif
  NewbieGuideViewController * newbieGuideViewController = [[NewbieGuideViewController alloc] init];
  self.newbieGuideViewController = newbieGuideViewController;
  [newbieGuideViewController release];
  [self.view addSubview:self.newbieGuideViewController.view];
  [self.newbieGuideViewController loadViewAnimated:YES];
}

// Show Help view
- (void)showHelpView:(id)sender {
  HelpViewController * helpViewController = [[HelpViewController alloc] init];
  self.helpViewController = helpViewController;
  [helpViewController release];
  [self.view addSubview:self.helpViewController.view];
  [self.helpViewController loadViewAnimated:YES];
}

// Slide |centerMainButton_| to view bottom when button in center menu is clicked
- (void)changeCenterMainButtonStatus:(NSNotification *)notification {
  switch ([[notification.userInfo objectForKey:@"centerMainButtonStatus"] intValue]) {
    case kCenterMainButtonStatusAtBottom:
      centerMainButtonStatus_ = kCenterMainButtonStatusAtBottom;
      [self setButtonLayoutTo:kMainViewButtonLayoutCenterMainButtonToBottom | kMainViewButtonLayoutMapButtonToOffcreen
          withCompletionBlock:nil];
      [self deactivateCenterMenuOpenStatusTimer];
      break;
      
    case kCenterMainButtonStatusPokemonAppeared:
      centerMainButtonMessageSignal_ = kCenterMainButtonMessageSignalPokemonAppeared;
      [self.centerMainButton setImage:[UIImage imageNamed:kPMINMainButtonWarning]
                             forState:UIControlStateNormal];
      break;
      
    case kCenterMainButtonStatusNormal:
    default:
      if (isGameMainViewOpening_) {
        centerMainButtonMessageSignal_ = kCenterMainButtonMessageSignalNone;
        CenterMainButtonStatus previousCenterMainButtonStatus = [[notification.userInfo objectForKey:@"previousCenterMainButtonStatus"] intValue];
        centerMainButtonStatus_ = previousCenterMainButtonStatus;
        
        if (previousCenterMainButtonStatus != kCenterMainButtonStatusAtBottom) {
          if (isCenterMenuOpening_) {
            [self setButtonLayoutTo:kMainViewButtonLayoutMapButtonToTop withCompletionBlock:nil];
            [self activateCenterMenuOpenStatusTimer];
          }
          else [self setButtonLayoutTo:kMainViewButtonLayoutNormal withCompletionBlock:nil];
        }
        isGameMainViewOpening_ = NO;
      }
      else {
        centerMainButtonStatus_ = kCenterMainButtonStatusNormal;
        [self setButtonLayoutTo:kMainViewButtonLayoutMapButtonToTop withCompletionBlock:nil];
        // Is |centerMenu_| is opening, activate |centerMenuOpenStatusTimer_|
        if (isCenterMenuOpening_) [self activateCenterMenuOpenStatusTimer];
      }
      break;
  }
}

// |centerMainButton_| touch up inside action
- (void)runCenterMainButtonTouchUpInsideAction:(id)sender {
  // If Pokemon Appeared, and got a message, deal with it
  if (centerMainButtonMessageSignal_ == kCenterMainButtonMessageSignalPokemonAppeared &&
      centerMainButtonStatus_ != kCenterMainButtonStatusPokemonAppeared) {
    // Create |gameMainViewController_|
    GameMainViewController * gameMainViewController = [[GameMainViewController alloc] init];
    self.gameMainViewController = gameMainViewController;
    [gameMainViewController release];
    [self.view insertSubview:gameMainViewController_.view belowSubview:centerMainButton_];
    
    // completion block to be executed after buttons' animation done
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
      [self.gameMainViewController startBattleWithPreviousCenterMainButtonStatus:centerMainButtonStatus_];
      centerMainButtonStatus_ = kCenterMainButtonStatusPokemonAppeared;
      isGameMainViewOpening_  = YES;
      [self.centerMainButton setImage:[UIImage imageNamed:kPMINMainButtonNormal]
                             forState:UIControlStateNormal];
      [self deactivateCenterMenuOpenStatusTimer];
    };
    // If |centerMainButton_| is not at view bottom, move it to bottom
    if (centerMainButtonStatus_ != kCenterMainButtonStatusAtBottom)
      [self setButtonLayoutTo:kMainViewButtonLayoutCenterMainButtonToBottom | kMainViewButtonLayoutMapButtonToOffcreen
          withCompletionBlock:completionBlock];
    else completionBlock(YES);
    return;
  }
  
  // Do basic actions for touch up inside button
  switch (centerMainButtonStatus_) {
    case kCenterMainButtonStatusAtBottom:
      // The observer is |CustomTabViewController|
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNToggleTabBar object:self userInfo:nil];
      break;
      
    case kCenterMainButtonStatusPokemonAppeared:
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNToggleSixPokemons object:self userInfo:nil];
      break;
    
    case kCenterMainButtonStatusNormal:
    default:
      // If it is still in opening or closing process, do nothing until it done
      if (self.centerMenuUtilityViewController.isInProcessing)
        return;
      
      if (isCenterMenuOpening_) {
        if (self.centerMenuUtilityViewController.isOpening
            || self.centerMenuSixPokemonsViewController.isOpening)
          [self closeCenterMenuView];
      } else {
        [self openCenterMenuView];
        // Activate |centerMenuOpenStatusTimer_|
        [self activateCenterMenuOpenStatusTimer];
      }
      break;
  }
}

// Method for opening center menu view when |isCenterMenuOpening_ == NO|
- (void)openCenterMenuView {
  [self.longTapTimer invalidate];
  
  // Stop |centerMainButtonTouchDownCircleView_| loading
  [self.centerMainButtonTouchDownCircleView stopAnimation];
  isCenterMainButtonTouchDownCircleViewLoading_ = NO;
  
  // Declare a block for animation completion action
  void (^completionBlock)(BOOL);
  
  // Do action based on tap down keepped time
  // Utility Menu
  if (timeCounter_ < 3.f) {
    // Reset |centerMenuSixPokemonsViewController_|
    if (self.centerMenuSixPokemonsViewController != nil)
      self.centerMenuSixPokemonsViewController = nil;
    
    // Create |centerMenuUtilityViewController_|
    if (self.centerMenuUtilityViewController == nil) {
      // Center menu utility view controller
      CenterMenuUtilityViewController * centerMenuUtilityViewController;
      centerMenuUtilityViewController = [[CenterMenuUtilityViewController alloc] initWithButtonCount:6];
      self.centerMenuUtilityViewController = centerMenuUtilityViewController;
      [centerMenuUtilityViewController release];
      
      if (self.customNavigationController != nil)
        [self.customNavigationController.view removeFromSuperview];
      
      // Create custom NVC
      CustomNavigationController * customNavigationController = [CustomNavigationController alloc];
      [customNavigationController initWithRootViewController:self.centerMenuUtilityViewController];
      self.customNavigationController = customNavigationController;
      [customNavigationController release];
      [self.customNavigationController.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
    }
    
    // Insert |utilityNavigationController|'s view
//    [self.view insertSubview:self.customNavigationController.view belowSubview:self.gameMainViewController.view];
    [self.view insertSubview:self.customNavigationController.view belowSubview:self.centerMainButton];
    
    // Implement the completion block
    completionBlock = ^(BOOL finished) {
      [self.centerMenuUtilityViewController openCenterMenuView];
      isCenterMenuOpening_ = YES;
    };
  }
  // Six Pokemons Menu
  else if (timeCounter_ <= 5) {
#ifdef DEBUG_TEST_FLIGHT
    [TestFlight passCheckpoint:@"CHECK_POINT: Open Center Six PMs Menu (long press)"];
#endif
    // Reset |centerMenuUtilityViewController_|
    if (self.centerMenuUtilityViewController != nil)
      self.centerMenuUtilityViewController = nil;
    
    // Create VC for Six Pokemons
    NSInteger numberOfSixPokemons = [[TrainerController sharedInstance] numberOfSixPokemons];
    CenterMenuSixPokemonsViewController * centerMenuSixPokemonsViewController;
    centerMenuSixPokemonsViewController = [CenterMenuSixPokemonsViewController alloc];
    [centerMenuSixPokemonsViewController initWithButtonCount:numberOfSixPokemons];
    self.centerMenuSixPokemonsViewController = centerMenuSixPokemonsViewController;
    [centerMenuSixPokemonsViewController release];
    
    // Create custom NVC
    CustomNavigationController * customNavigationController = [CustomNavigationController alloc];
    [customNavigationController initWithRootViewController:self.centerMenuSixPokemonsViewController];
    self.customNavigationController = customNavigationController;
    [customNavigationController release];
    [self.customNavigationController.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
    // Insert |utilityNavigationController|'s view
//    [self.view insertSubview:self.customNavigationController.view belowSubview:self.gameMainViewController.view];
    [self.view insertSubview:self.customNavigationController.view belowSubview:self.centerMainButton];
    
    // Implement the completion block
    completionBlock = ^(BOOL finished) {
      [self.centerMenuSixPokemonsViewController openCenterMenuView];
    };
  }
  else {
    [self closeCenterMenuView];
    return;
  }
  
  // Animation for |mapButton_|'s new Frame
  [self setButtonLayoutTo:kMainViewButtonLayoutMapButtonToTop withCompletionBlock:completionBlock];
  isCenterMenuOpening_ = YES;
}

// Method for close center menu view when |isCenterMenuOpening_ == YES|
- (void)closeCenterMenuView {
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNCloseCenterMenu
                                                      object:self
                                                    userInfo:nil];
  [self setButtonLayoutTo:kMainViewButtonLayoutNormal withCompletionBlock:nil];
  [self deactivateCenterMenuOpenStatusTimer];
  isCenterMenuOpening_ = NO;
}

// Activate |centerMenuOpenStatusTimer_| to count how many time the |centerMenu_| is open without any operation,
// Close the |centerMenu_| when necessary
- (void)activateCenterMenuOpenStatusTimer {
  if (! isCenterMenuOpening_)
    return;
  centerMenuOpenStatusTimeCounter_ = 0;
  self.centerMenuOpenStatusTimer = [NSTimer scheduledTimerWithTimeInterval:5.f
                                                                    target:self
                                                                  selector:@selector(closeCenterMenuWhenLongTimeNoOperation)
                                                                  userInfo:nil
                                                                   repeats:YES];
}

// Stop |centerMenuOpenStatusTimer_| when button clicked
- (void)deactivateCenterMenuOpenStatusTimer {
  [self.centerMenuOpenStatusTimer invalidate];
  self.centerMenuOpenStatusTimer = nil;
}

// Close |centerMenu_| when long time no operation 
- (void)closeCenterMenuWhenLongTimeNoOperation {
  centerMenuOpenStatusTimeCounter_ += 5;
  NSLog(@"%d", centerMenuOpenStatusTimeCounter_);
  if (centerMenuOpenStatusTimeCounter_ == 10) {
    [self closeCenterMenuView];
    [self.centerMenuOpenStatusTimer invalidate];
  }
}

// |centerMainButton_| touch down action
- (void)countLongTapTimeWithAction:(id)sender {
  if (! isCenterMenuOpening_ && centerMainButtonMessageSignal_ != kCenterMainButtonMessageSignalPokemonAppeared) {
    // Start time counting
    self.currentKeyButton = (UIButton *)sender;
    timeCounter_  = 0;
    [self.longTapTimer invalidate];
    self.longTapTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                         target:self
                                                       selector:@selector(increaseTimeWithAction)
                                                       userInfo:nil
                                                        repeats:YES];
  }
}

// Method for counting Tap Down time
- (void)increaseTimeWithAction {
  ++timeCounter_;
  NSLog(@"Touch Keep Time: %d", timeCounter_);
  
  NSInteger buttonTag = self.currentKeyButton.tag;
  ///TARGET:|centerMainButton_|
  // If the target is |centerMainButton_|, and |timeCounter_ >= 1.0|, loading it
  // Time: delay 1.0 second, then every 2.0 second got a new point
  if (! isCenterMainButtonTouchDownCircleViewLoading_ && buttonTag == kTagMainViewCenterMainButton
      && ! isCenterMenuOpening_ && timeCounter_ >= 1.f) {
#ifdef DEBUG_TEST_FLIGHT
    [TestFlight passCheckpoint:@"CHECK_POINT: Long Time Press on Center Main Button"];
#endif
    // Run this block after |mapButton_| moved to view top
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
      NSLog(@"increaseTimeWithAction - Start loading |centerMainButtonTouchDownCircleView|...");
      isCenterMainButtonTouchDownCircleViewLoading_ = YES;
      
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
  
  ///TARGET:|mapButton_|
  // If keep tapping the |mapButton_| long time until... do |toggleLocationService|
  else if (buttonTag == kTagMainViewMapButton && timeCounter_ > 2.f) {
#ifdef DEBUG_TEST_FLIGHT
    [TestFlight passCheckpoint:@"CHECK_POINT: Long Time Press on Map Button"];
#endif
    [self toggleLocationService];
    [self.longTapTimer invalidate];
  }
}

// |mapButton_| action
- (void)toggleMapView:(id)sender {
  [self.longTapTimer invalidate];
  // If Location Service is not allowed, do nothing
  if (! [[NSUserDefaults standardUserDefaults] boolForKey:kUDKeyGeneralLocationServices] || timeCounter_ >= 6.f)
    return;
  
  // Else, just normal button action
  __block CGRect mapViewFrame   = CGRectMake(0.f, 0.f, kViewWidth, kViewHeight);
  __block CGRect mapButtonFrame = CGRectMake((kViewWidth - kMapButtonSize) / 2,
                                             100.f,
                                             kMapButtonSize,
                                             kMapButtonSize);
  
  if (isMapViewOpening_) {
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
                     if (! isMapViewOpening_ && isCenterMenuOpening_) {
                       [[NSNotificationCenter defaultCenter] postNotificationName:kPMNCloseCenterMenu
                                                                           object:self
                                                                         userInfo:nil];
                       isCenterMenuOpening_ = NO;
                       [self deactivateCenterMenuOpenStatusTimer];
                     }
                     else [self.mapButton setFrame:mapButtonFrame];
                       
                     // Set frame of the |mapViewController_|'s view to show it
                     [self.mapViewController.view setFrame:mapViewFrame];
                   }
                   completion:^(BOOL finished) {                     
                     isMapViewOpening_ = ! isMapViewOpening_;
                     
                     if (isMapViewOpening_)
                       [self.mapButton setImage:[UIImage imageNamed:kPMINMapButtonHalfCancel]
                                       forState:UIControlStateNormal];
                     else {
                       [self.mapButton setImage:[UIImage imageNamed:kPMINMapButtonNormal]
                                       forState:UIControlStateNormal];
                       [self.mapViewController.view removeFromSuperview];
                     }
                   }];
}

// Unload game battle scene
- (void)unloadGameBattleScene:(NSNotification *)notification {
  [self changeCenterMainButtonStatus:notification];
  if (self.gameMainViewController == nil)
    return;
//  [gameMainViewController_ release];
  self.gameMainViewController = nil;
}

// Toggle tracking
- (void)updateLocationService:(NSNotification *)notification {
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  if ([userDefaults boolForKey:kUDKeyGeneralLocationServices]) {
    [self.mapButton setImage:[UIImage imageNamed:kPMINMapButtonNormal] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNEnableTracking object:self userInfo:nil];
  }
  else {
    [self.mapButton setImage:[UIImage imageNamed:kPMINMapButtonDisabled] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNDisableTracking object:self userInfo:nil];
  }
}

// Toggle Location Service after long press on |mapButton_|
- (void)toggleLocationService {
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  if ([userDefaults boolForKey:kUDKeyGeneralLocationServices]) {
    NSLog(@"Service is on, turn off");
    [userDefaults setBool:NO forKey:kUDKeyGeneralLocationServices];
    [self.mapButton setImage:[UIImage imageNamed:kPMINMapButtonDisabled] forState:UIControlStateNormal];
    // Post notification to |MapViewController| to stop location tracking
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNDisableTracking object:self userInfo:nil];
  } else {
    NSLog(@"Service is off, turn on");
    [userDefaults setBool:YES forKey:kUDKeyGeneralLocationServices];
    [self.mapButton setImage:[UIImage imageNamed:kPMINMapButtonNormal] forState:UIControlStateNormal];
    // Post notification to |MapViewController| to start location tracking
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNEnableTracking object:self userInfo:nil];
  }
}

// Set layouts for buttons
- (void)setButtonLayoutTo:(MainViewButtonLayout)buttonLayouts
      withCompletionBlock:(void (^)(BOOL))completion {
  void (^animations)() = ^{
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
                   animations:animations
                   completion:completion];
}

@end
