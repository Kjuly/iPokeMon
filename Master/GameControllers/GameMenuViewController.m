//
//  GameMenuViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuViewController.h"

#import "GlobalRender.h"
#import "PMAudioPlayer.h"
#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "TrainerController.h"
#import "GameBattleLogTableViewController.h"
#import "GamePlayerPokemonStatusViewController.h"
#import "GameEnemyPokemonStatusViewController.h"
#import "GameMenuSixPokemonsViewController.h"
#import "GameMenuMoveViewController.h"
#import "GameMenuBagViewController.h"


typedef enum {
  kGameMenuKeyViewNone = 0,
  kGameMenuKeyViewSixPokemonsView,
  kGameMenuKeyViewMoveView,
  kGameMenuKeyViewBagView,
  kGameMenuKeyViewPlayerPokemonStatusView,
  kGameMenuKeyViewEnemyPokemonStatusView
}GameMenuKeyView;


@interface GameMenuViewController () {
 @private
  UIView      * menuArea_;
  UIImageView * pokemonImageView_;
  UIImageView * pokeball_;
  
  PMAudioPlayer                         * audioPlayer_;
  TrainerController                     * trainer_;
  GameStatusMachine                     * gameStatusMachine_;
  GameBattleLogTableViewController      * gameBattleLogTableViewController_;
  GameEnemyPokemonStatusViewController  * enemyPokemonStatusViewController_;
  GamePlayerPokemonStatusViewController * playerPokemonStatusViewController_;
  GameMenuSixPokemonsViewController     * gameMenuSixPokemonsViewController_;
  GameMenuMoveViewController            * gameMenuMoveViewController_;
  GameMenuBagViewController             * gameMenuBagViewController_;
  
  // Gestures
  UISwipeGestureRecognizer * swipeRightGestureRecognizer_;        // Open Move view for Fight
  UISwipeGestureRecognizer * swipeLeftGestureRecognizer_;         // Open Bag view
  UISwipeGestureRecognizer * swipeUpGestureRecognizer_;           // Open player pokemon status view
  UISwipeGestureRecognizer * swipeDownGestureRecognizer_;         // Open enemy pokemon status view
  UITapGestureRecognizer   * twoFingersTwoTapsGestureRecognizer_; // Open Run confirm view
//  UITapGestureRecognizer   * twoFingersOneTapGestureRecognizer_;  // Open Menu
  UITapGestureRecognizer   * gameBattleLogTableViewTapGestureRecognizer_;
  
  GameMenuKeyView gameMenuKeyView_;
  NSInteger       currPokemon_;
}

@property (nonatomic, strong) UIView      * menuArea;
@property (nonatomic, strong) UIImageView * pokemonImageView;
@property (nonatomic, strong) UIImageView * pokeball;

@property (nonatomic, strong) PMAudioPlayer                         * audioPlayer;
@property (nonatomic, strong) TrainerController                     * trainer;
@property (nonatomic, strong) GameStatusMachine                     * gameStatusMachine;
@property (nonatomic, strong) GameBattleLogTableViewController      * gameBattleLogTableViewController;
@property (nonatomic, strong) GameEnemyPokemonStatusViewController  * enemyPokemonStatusViewController;
@property (nonatomic, strong) GamePlayerPokemonStatusViewController * playerPokemonStatusViewController;
@property (nonatomic, strong) GameMenuSixPokemonsViewController     * gameMenuSixPokemonsViewController;
@property (nonatomic, strong) GameMenuMoveViewController            * gameMenuMoveViewController;
@property (nonatomic, strong) GameMenuBagViewController             * gameMenuBagViewController;

@property (nonatomic, strong) UISwipeGestureRecognizer * swipeRightGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeLeftGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeUpGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeDownGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer   * twoFingersTwoTapsGestureRecognizer;
//@property (nonatomic, retain) UITapGestureRecognizer   * twoFingersOneTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer   * gameBattleLogTableViewTapGestureRecognizer;

- (void)_initSubviews;
- (void)_initGestureRecognizers;
- (void)_setupNotificationObservers;
// Button Actions
- (void)_toggleGameBattleLogTableView;
- (void)_updateGameMenuKeyView:(NSNotification *)notification;
- (void)_toggleSixPokemonView;
- (void)_replacePokemon:(NSNotification *)notification;
- (void)_catchWildPokemon:(NSNotification *)notification;
- (void)_throwPokeballToReplacePokemon;
- (void)_throwPokeballToCatchPokemon;
- (void)_checkPokeball:(NSNotification *)notification;
- (void)_resetPokeball:(NSNotification *)notification;
- (void)_getPokemonBack;
- (void)_updateForNewPokemon;
- (void)_openMoveView;
- (void)_openBagView;
- (void)_openRunConfirmView;
- (void)_toggleSixPokemonsView:(NSNotification *)notification;
- (void)_updateMessage:(NSNotification *)notification;
- (void)_updatePokemonStatus:(NSNotification *)notification;

// Gesture Action
- (void)_swipeView:(UISwipeGestureRecognizer *)recognizer;
- (void)_tapViewAction:(UITapGestureRecognizer *)recognizer;
- (void)_cancelKeyViewExcept:(GameMenuKeyView)targetView;

@end


@implementation GameMenuViewController

@synthesize delegate = delegate_;

@synthesize menuArea         = menuArea_;
@synthesize pokemonImageView = pokemonImageView_;
@synthesize pokeball         = pokeball_;

@synthesize audioPlayer                       = audioPlayer_;
@synthesize trainer                           = trainer_;
@synthesize gameStatusMachine                 = gameStatusMachine_;
@synthesize gameBattleLogTableViewController  = gameBattleLogTableViewController_;
@synthesize enemyPokemonStatusViewController  = enemyPokemonStatusViewController_;
@synthesize playerPokemonStatusViewController = playerPokemonStatusViewController_;
@synthesize gameMenuSixPokemonsViewController = gameMenuSixPokemonsViewController_;
@synthesize gameMenuMoveViewController        = gameMenuMoveViewController_;
@synthesize gameMenuBagViewController         = gameMenuBagViewController_;

@synthesize swipeRightGestureRecognizer        = swipeRightGestureRecognizer_;
@synthesize swipeLeftGestureRecognizer         = swipeLeftGestureRecognizer_;
@synthesize swipeUpGestureRecognizer           = swipeUpGestureRecognizer_;
@synthesize swipeDownGestureRecognizer         = swipeDownGestureRecognizer_;
@synthesize twoFingersTwoTapsGestureRecognizer = twoFingersTwoTapsGestureRecognizer_;
//@synthesize twoFingersOneTapGestureRecognizer  = twoFingersOneTapGestureRecognizer_;
@synthesize gameBattleLogTableViewTapGestureRecognizer = gameBattleLogTableViewTapGestureRecognizer_;

- (void)dealloc
{
  self.delegate = nil;
//  self.twoFingersOneTapGestureRecognizer  = nil;
  
  // Rmove observer for notification
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
  UIView * view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {kViewWidth, kViewHeight}}];
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Base Settings
  self.audioPlayer       = [PMAudioPlayer     sharedInstance];
  self.trainer           = [TrainerController sharedInstance];
  self.gameStatusMachine = [GameStatusMachine sharedInstance];
  gameMenuKeyView_       = kGameMenuKeyViewNone;
  
  [self _initSubviews];
  [self _initGestureRecognizers];
  [self _setupNotificationObservers];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.menuArea         = nil;
  self.pokemonImageView = nil;
  self.pokeball         = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

// init methods
- (void)_initSubviews
{
  // Constants
  CGRect gameBattleLogTableViewFrame  = CGRectMake(0.f,
                                                   kViewHeight - kGameMenuBattleLogViewHeight,
                                                   kViewWidth,
                                                   kGameMenuBattleLogViewHeight);
  CGRect enemyPokemonStatusViewFrame  = CGRectMake(0.f,
                                                   kGameMenuPMStatusHPBarHeight - kGameMenuPMStatusViewHeight,
                                                   kViewWidth,
                                                   kGameMenuPMStatusViewHeight);
  CGRect playerPokemonStatusViewFrame = CGRectMake(0.f,
                                                   kViewHeight - kGameMenuBattleLogViewHeight - kGameMenuPMStatusHPBarHeight,
                                                   kViewWidth,
                                                   kGameMenuPMStatusViewHeight);
  
  //
  // Pokemon Status
  //
  // Wild Pokemon Status View
  enemyPokemonStatusViewController_ = [[GameEnemyPokemonStatusViewController alloc] init];
  [enemyPokemonStatusViewController_.view setFrame:enemyPokemonStatusViewFrame];
  [self.view addSubview:enemyPokemonStatusViewController_.view];
  
  // My Pokemon Status View
  playerPokemonStatusViewController_ = [[GamePlayerPokemonStatusViewController alloc] init];
  [playerPokemonStatusViewController_.view setFrame:playerPokemonStatusViewFrame];
  [self.view addSubview:playerPokemonStatusViewController_.view];
  
  // battle logs tableview
  gameBattleLogTableViewController_ = [GameBattleLogTableViewController alloc];
  (void)[gameBattleLogTableViewController_ initWithStyle:UITableViewStylePlain];
  [gameBattleLogTableViewController_.view setFrame:gameBattleLogTableViewFrame];
  [self.view addSubview:gameBattleLogTableViewController_.view];
  
  // Pokemon Image View (for animation of getting back pokemon)
  UIImageView * pokemonImageView =
    [[UIImageView alloc] initWithFrame:
      CGRectMake(70.f, kViewHeight, kGameBattlePMSize, kGameBattlePMSize)];
  self.pokemonImageView = pokemonImageView;
  [self.view addSubview:self.pokemonImageView];
  
  // Pokeball
  UIImageView * pokeball =
    [[UIImageView alloc] initWithFrame:CGRectMake((kViewWidth - kCenterMainButtonSize) * .5f,
                                                  kViewHeight,
                                                  kGameMenuPokeballSize,
                                                  kGameMenuPokeballSize)];
  self.pokeball = pokeball;
  [self.pokeball setContentMode:UIViewContentModeScaleAspectFit];
  [self.pokeball setImage:[UIImage imageNamed:kPMINBattleElementPokeball]];
  [self.view addSubview:self.pokeball];
}

// initialize gesture recognizers
- (void)_initGestureRecognizers
{
  // Swipte to RIGHT, open move view or close bag view
  UISwipeGestureRecognizer * swipeRightGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeView:)];
  self.swipeRightGestureRecognizer = swipeRightGestureRecognizer;
  [self.swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
  [self.view addGestureRecognizer:self.swipeRightGestureRecognizer];
  
  // Swipte to LEFT, open bag view or close move view
  UISwipeGestureRecognizer * swipeLeftGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeView:)];
  self.swipeLeftGestureRecognizer = swipeLeftGestureRecognizer;
  [self.swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
  [self.view addGestureRecognizer:self.swipeLeftGestureRecognizer];
  
  // Swipte to UP, open player pokemon status view or close enemy pokemon status view
  UISwipeGestureRecognizer * swipeUpGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeView:)];
  self.swipeUpGestureRecognizer = swipeUpGestureRecognizer;
  [self.swipeUpGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
  [self.view addGestureRecognizer:self.swipeUpGestureRecognizer];
  
  // Swipte to DOWN, open enemy pokemon status view or close player pokemon status view
  UISwipeGestureRecognizer * swipeDownGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_swipeView:)];
  self.swipeDownGestureRecognizer = swipeDownGestureRecognizer;
  [self.swipeDownGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
  [self.view addGestureRecognizer:self.swipeDownGestureRecognizer];
  
  // Two finger with two taps to open Run confirm view
  UITapGestureRecognizer * twoFingersTwoTapsGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapViewAction:)];
  self.twoFingersTwoTapsGestureRecognizer = twoFingersTwoTapsGestureRecognizer;
  [self.twoFingersTwoTapsGestureRecognizer setNumberOfTapsRequired:2];
  [self.twoFingersTwoTapsGestureRecognizer setNumberOfTouchesRequired:2];
  [self.view addGestureRecognizer:self.twoFingersTwoTapsGestureRecognizer];
  
//  // Two finger with one tap to open Menu
//  UITapGestureRecognizer * twoFingersOneTapGestureRecognizer =
//    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapViewAction:)];
//  self.twoFingersOneTapGestureRecognizer = twoFingersOneTapGestureRecognizer;
//  [twoFingersOneTapGestureRecognizer release];
//  [self.twoFingersOneTapGestureRecognizer setNumberOfTapsRequired:1];
//  [self.twoFingersOneTapGestureRecognizer setNumberOfTouchesRequired:2];
//  [self.view addGestureRecognizer:self.twoFingersOneTapGestureRecognizer];
  
  // Two finger with one tap on game battle log table view
  gameBattleLogTableViewTapGestureRecognizer_ = [UITapGestureRecognizer alloc];
  (void)[gameBattleLogTableViewTapGestureRecognizer_ initWithTarget:self
                                                             action:@selector(_toggleGameBattleLogTableView)];
  [gameBattleLogTableViewTapGestureRecognizer_ setNumberOfTouchesRequired:1];
  [gameBattleLogTableViewTapGestureRecognizer_ setNumberOfTapsRequired:1];
  [self.gameBattleLogTableViewController.view addGestureRecognizer:gameBattleLogTableViewTapGestureRecognizer_];
}

// initialize notification observers
- (void)_setupNotificationObservers
{
  NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
  // Add observer for notfication from |GameMenuAbstractChildViewController|
  [notificationCenter addObserver:self
                         selector:@selector(_updateGameMenuKeyView:)
                             name:kPMNUpdateGameMenuKeyView
                           object:nil];
  // Add observer for notification from |centerMainButton_|
  [notificationCenter addObserver:self
                         selector:@selector(_toggleSixPokemonsView:)
                             name:kPMNToggleSixPokemons
                           object:nil];
  // Add observer for notification from |BagItemTableViewController|
  [notificationCenter addObserver:self
                         selector:@selector(_catchWildPokemon:)
                             name:kPMNCatchWildPokemon
                           object:nil];
  // Add observer for notification from |GameSystemProcess|
  [notificationCenter addObserver:self
                         selector:@selector(_updateMessage:)
                             name:kPMNUpdateGameBattleMessage
                           object:nil];
  // Add observer for notification from |GameMoveEffect|
  [notificationCenter addObserver:self
                         selector:@selector(_updatePokemonStatus:)
                             name:kPMNUpdatePokemonStatus
                           object:nil];
  // Add observer for notification from |GameMenuSixPokemonsViewController|
  [notificationCenter addObserver:self
                         selector:@selector(_replacePokemon:)
                             name:kPMNReplacePokemon
                           object:self.gameMenuSixPokemonsViewController];
  // Noficication from |GameSystemProcess| - |catchingWildPokemon|
  [notificationCenter addObserver:self
                         selector:@selector(_checkPokeball:)
                             name:kPMNPokeballChecking
                           object:nil];
  // Notification from |GameSystemProcess| - |caughtWildPokemonSucceed:| if |succeed == NO|
  [notificationCenter addObserver:self
                         selector:@selector(_resetPokeball:)
                             name:kPMNPokeballLossWildPokemon
                           object:nil];
}

// toggle game battle log table view
- (void)_toggleGameBattleLogTableView
{
  CGRect viewFrame = self.gameBattleLogTableViewController.view.frame;
  if (viewFrame.size.height == kGameMenuBattleLogViewHeight) {
    viewFrame.size.height = kViewHeight;
    viewFrame.origin.y = 0.f;
  }
  else {
    viewFrame.size.height = kGameMenuBattleLogViewHeight;
    viewFrame.origin.y = kViewHeight - kGameMenuBattleLogViewHeight;
  }
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.gameBattleLogTableViewController.view setFrame:viewFrame];
                   }
                   completion:nil];
}

// Update key view
- (void)_updateGameMenuKeyView:(NSNotification *)notification
{
  gameMenuKeyView_ = kGameMenuKeyViewNone;
}

// Button actions
// Toggle six pokemons' view
- (void)_toggleSixPokemonView
{
  if (self.gameStatusMachine.status == kGameStatusPlayerTurn) {
    if (gameMenuKeyView_ == kGameMenuKeyViewNone) {
      [self.view addSubview:self.gameMenuSixPokemonsViewController.view];
      [self.gameMenuSixPokemonsViewController initWithSixPokemonsForReplacing:YES];
      [self.gameMenuSixPokemonsViewController loadSixPokemonsAnimated:YES];
      gameMenuKeyView_ = kGameMenuKeyViewSixPokemonsView;
    }
    else {
      if (self.gameMenuSixPokemonsViewController.isSelectedPokemonInfoViewOpening)
        [self.gameMenuSixPokemonsViewController unloadSelcetedPokemonInfoView];
      [self.gameMenuSixPokemonsViewController unloadSixPokemonsAnimated:YES];
      
      gameMenuKeyView_ = kGameMenuKeyViewNone;
    }
  }
}

// Replace the battle pokemon
- (void)_replacePokemon:(NSNotification *)notification
{
  gameMenuKeyView_ = kGameMenuKeyViewNone;
  
  CGFloat baseDalay = 0.f;
  // If player's current battle Pokemon not fainted, get back it with animation first
  TrainerTamedPokemon * pokemon = [[self.trainer sixPokemons] objectAtIndex:currPokemon_];
  if ([pokemon.hp intValue] != 0) {
    // Get current battling pokemon back from scene animated
    baseDalay = .3f;
    [self performSelector:@selector(_getPokemonBack) withObject:nil afterDelay:baseDalay];
  }
  // Update for new Pokemon
  [self performSelector:@selector(_updateForNewPokemon) withObject:nil afterDelay:baseDalay];
  // Send new pokemon to scene animated
  [self performSelector:@selector(_throwPokeballToReplacePokemon) withObject:nil afterDelay:(baseDalay + .8f)];
}

// Try to catch Wild Pokemon
- (void)_catchWildPokemon:(NSNotification *)notification
{
  gameMenuKeyView_ = kGameMenuKeyViewNone;
  // Throw Pokeball to WildPokemon
  [self performSelector:@selector(_throwPokeballToCatchPokemon) withObject:nil afterDelay:1.f];
}

// Get current battling pokemon back from scene
- (void)_getPokemonBack
{
  UIBezierPath * path = [UIBezierPath bezierPath];
  [path moveToPoint:CGPointMake(70.f, 230.f)];
  [path addCurveToPoint:CGPointMake(100.f, 250.f)
          controlPoint1:CGPointMake(80.f, 230.f)
          controlPoint2:CGPointMake(90.f, 245.f)];
  [path addCurveToPoint:CGPointMake(kViewWidth / 2, kViewHeight)
          controlPoint1:CGPointMake(130.f, 270.f)
          controlPoint2:CGPointMake(160.f, 330.f)];
  
//#ifdef DEBUG
//  CAShapeLayer * pathTrack = [CAShapeLayer layer];
//	pathTrack.path = path.CGPath;
//	pathTrack.strokeColor = [UIColor blackColor].CGColor;
//	pathTrack.fillColor = [UIColor clearColor].CGColor;
//	pathTrack.lineWidth = 10.0;
//	[self.view.layer addSublayer:pathTrack];
//#endif

  // Basic Settings
  CGFloat duration = .7f;
  NSArray * keyTimes = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:.0f],
                        [NSNumber numberWithFloat:.4f],
                        [NSNumber numberWithFloat:duration], nil];
  NSArray * timingFunctions = [NSArray arrayWithObjects:
                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], nil];
  
  // Move animation
  CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  moveAnimation.path = path.CGPath;
  moveAnimation.keyTimes = keyTimes;
  moveAnimation.duration = duration;
  moveAnimation.timingFunctions = timingFunctions;
  
  // Scale animation
  CAKeyframeAnimation * scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
  scaleAnimation.values = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:.6],
                           [NSNumber numberWithFloat:1.6f],
                           [NSNumber numberWithFloat:1.f], nil];
  scaleAnimation.keyTimes = keyTimes;
  scaleAnimation.duration = duration;
  scaleAnimation.timingFunctions = timingFunctions;
  
  // Fade animation
  CAKeyframeAnimation * fadeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
  fadeAnimation.values = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:.3f],
                          [NSNumber numberWithFloat:1.f],
                          [NSNumber numberWithFloat:0.f], nil];
  fadeAnimation.keyTimes = keyTimes;
  fadeAnimation.duration = duration;
  fadeAnimation.timingFunctions = timingFunctions;
  
  // Throw pokeball group animation
  CAAnimationGroup * getPokemonBackAnimation = [CAAnimationGroup animation];
  getPokemonBackAnimation.delegate = self;
  getPokemonBackAnimation.duration = duration;
  NSArray * animations = [[NSArray alloc] initWithObjects:moveAnimation, scaleAnimation, fadeAnimation, nil];
  getPokemonBackAnimation.animations = animations;
  
  TrainerTamedPokemon * pokemon = [[self.trainer sixPokemons] objectAtIndex:currPokemon_];
  [self.pokemonImageView setImage:pokemon.pokemon.imageBack];
  [self.pokemonImageView.layer addAnimation:getPokemonBackAnimation forKey:@"getPokemonBack"];
  pokemon = nil;
}

// Update data for new Pokemon (generally dispatched after method:|_getPokemonBack|)
- (void)_updateForNewPokemon
{
  // Post notification to |GameBattleLayer| to replace pokemon sprite
  NSInteger newPokemonIndex = self.gameMenuSixPokemonsViewController.currBattlePokemon - 1;
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithInt:newPokemonIndex], @"newPokemon", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNReplacePlayerPokemon object:self userInfo:userInfo];
  
  // Set Game System Process
  GameSystemProcess * gameSystemProcess = [GameSystemProcess sharedInstance];
  [gameSystemProcess setSystemProcessOfReplacePokemonWithUser:kGameSystemProcessUserPlayer
                                         selectedPokemonIndex:++newPokemonIndex];
  [[GameStatusMachine sharedInstance] endStatus:kGameStatusPlayerTurn];
}

// Throw Pokeball to send new pokemon to scene, replace the old one
- (void)_throwPokeballToReplacePokemon
{
  UIBezierPath * path = [UIBezierPath bezierPath];
  [path moveToPoint:CGPointMake(kViewWidth / 2, kViewHeight)];
  [path addCurveToPoint:CGPointMake(100.f, 250.f)
          controlPoint1:CGPointMake(160.f, 330.f)
          controlPoint2:CGPointMake(130.f, 270.f)];
  [path addCurveToPoint:CGPointMake(70.f, 230.f)
          controlPoint1:CGPointMake(90.f, 245.f)
          controlPoint2:CGPointMake(80.f, 230.f)];
  
//#ifdef DEBUG
//  CAShapeLayer * pathTrack = [CAShapeLayer layer];
//	pathTrack.path = path.CGPath;
//	pathTrack.strokeColor = [UIColor blackColor].CGColor;
//	pathTrack.fillColor = [UIColor clearColor].CGColor;
//	pathTrack.lineWidth = 10.0;
//	[self.view.layer addSublayer:pathTrack];
//#endif
  
  // Basic Settings
  CGFloat duration = .65f;
  NSArray * keyTimes = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.f],
                        [NSNumber numberWithFloat:.3f],
                        [NSNumber numberWithFloat:duration], nil];
  NSArray * timingFunctions = [NSArray arrayWithObjects:
                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], nil];
  
  // Move animation
  CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  moveAnimation.path = path.CGPath;
  moveAnimation.keyTimes = keyTimes;
  moveAnimation.duration = duration;
  moveAnimation.timingFunctions = timingFunctions;
  
  // Scale animation
  CAKeyframeAnimation * scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
  scaleAnimation.values = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:1.f],
                           [NSNumber numberWithFloat:1.6f],
                           [NSNumber numberWithFloat:.6f], nil];
  scaleAnimation.keyTimes = keyTimes;
  scaleAnimation.duration = duration;
  scaleAnimation.timingFunctions = timingFunctions;
  
  // Fade animation
  CAKeyframeAnimation * fadeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
  fadeAnimation.values = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:.3f],
                          [NSNumber numberWithFloat:1.f],
                          [NSNumber numberWithFloat:0.f], nil];
  fadeAnimation.keyTimes = keyTimes;
  fadeAnimation.duration = duration;
  fadeAnimation.timingFunctions = timingFunctions;
  
  // Throw pokeball group animation
  CAAnimationGroup * throwPokeballAnimation = [CAAnimationGroup animation];
  [throwPokeballAnimation setValue:@"throwPokeballToReplacePokemon" forKey:@"animationType"];
  throwPokeballAnimation.delegate = self;
  throwPokeballAnimation.duration = duration;
  NSArray * animations = [[NSArray alloc] initWithObjects:moveAnimation, scaleAnimation, fadeAnimation, nil];
  throwPokeballAnimation.animations = animations;
  [self.pokeball.layer addAnimation:throwPokeballAnimation forKey:@"throwPokeball"];
  
  // Play audio for throwing Pokeball
  [self.audioPlayer playForAudioType:kAudioBattleThrowPokeball afterDelay:0];
  
  // Set current battle pokemon ID
  currPokemon_ = self.gameMenuSixPokemonsViewController.currBattlePokemon - 1;
  
  // Update Pokmeon's Move
  [self.gameMenuMoveViewController updateFourMoves];
  
  // Update player's pokemon status
  [self.playerPokemonStatusViewController prepareForNewScene];
}

// Try to throw a Pokeball to cathch WildPokemon
- (void)_throwPokeballToCatchPokemon
{
  UIBezierPath * path = [UIBezierPath bezierPath];
  [path moveToPoint:CGPointMake(kViewWidth / 2, kViewHeight)];
  [path addCurveToPoint:CGPointMake(220.f, 140.f)
          controlPoint1:CGPointMake(160.f, 290.f)
          controlPoint2:CGPointMake(160.f, 240.f)];
  [path addCurveToPoint:CGPointMake(kGameBattleEnemyPokemonPosX, kViewHeight - kGameBattleEnemyPokemonPosY)
          controlPoint1:CGPointMake(240.f, 110.f)
          controlPoint2:CGPointMake(245.f, 110.f)];
  
//  #ifdef DEBUG
//    CAShapeLayer * pathTrack = [CAShapeLayer layer];
//  	pathTrack.path = path.CGPath;
//  	pathTrack.strokeColor = [UIColor whiteColor].CGColor;
//  	pathTrack.fillColor = [UIColor clearColor].CGColor;
//  	pathTrack.lineWidth = 10.0;
//  	[self.view.layer addSublayer:pathTrack];
//  #endif
  
  // Basic Settings
  CGFloat duration = .75f;
  NSArray * keyTimes = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.f],
                        [NSNumber numberWithFloat:.35f],
                        [NSNumber numberWithFloat:duration], nil];
  NSArray * timingFunctions = [NSArray arrayWithObjects:
                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], nil];
  
  // Move animation
  CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  moveAnimation.path = path.CGPath;
  moveAnimation.keyTimes = keyTimes;
  moveAnimation.duration = duration;
  moveAnimation.timingFunctions = timingFunctions;
  
  // Scale animation
  CAKeyframeAnimation * scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
  scaleAnimation.values = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:1.f],
                           [NSNumber numberWithFloat:1.6f],
                           [NSNumber numberWithFloat:.5f], nil];
  scaleAnimation.keyTimes = keyTimes;
  scaleAnimation.duration = duration;
  scaleAnimation.timingFunctions = timingFunctions;
  
  // Fade animation
  CAKeyframeAnimation * fadeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
  fadeAnimation.values = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:.3f],
                          [NSNumber numberWithFloat:1.f],
                          [NSNumber numberWithFloat:1.f], nil];
  fadeAnimation.keyTimes = keyTimes;
  fadeAnimation.duration = duration;
  fadeAnimation.timingFunctions = timingFunctions;
  
  // Throw pokeball group animation
  CAAnimationGroup * throwPokeballAnimation = [CAAnimationGroup animation];
  [throwPokeballAnimation setValue:@"throwPokeballToCatchWildPokemon" forKey:@"animationType"];
  throwPokeballAnimation.delegate = self;
  throwPokeballAnimation.duration = duration;
  NSArray * animations = [[NSArray alloc] initWithObjects:moveAnimation, scaleAnimation, fadeAnimation, nil];
  throwPokeballAnimation.animations = animations;
  throwPokeballAnimation.removedOnCompletion = NO;
  [self.pokeball.layer addAnimation:throwPokeballAnimation forKey:@"throwPokeballToCatchWildPokemon"];
  
  // Play audio for throwing Pokeball
  [self.audioPlayer playForAudioType:kAudioBattleThrowPokeball afterDelay:0];
}

// Check Pokeball whether the Wild Pokemon caught with animations
- (void)_checkPokeball:(NSNotification *)notification
{
  // Basic Settings
  CGFloat duration = .3f;
  NSArray * keyTimes = [NSArray arrayWithObjects:
                        [NSNumber numberWithFloat:0.f],
                        [NSNumber numberWithFloat:.1f],
                        [NSNumber numberWithFloat:.25f],
                        [NSNumber numberWithFloat:duration], nil];
  NSArray * timingFunctions = [NSArray arrayWithObjects:
                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                               [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], nil];
  
  // Move animation
  CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
  CGFloat originalPositionX = kGameBattleEnemyPokemonPosX;
  moveAnimation.values   = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:originalPositionX],
                            [NSNumber numberWithFloat:(originalPositionX - 5.f)],
                            [NSNumber numberWithFloat:(originalPositionX + 5.f)],
                            [NSNumber numberWithFloat:originalPositionX], nil];
  moveAnimation.keyTimes = keyTimes;
  moveAnimation.duration = duration;
  moveAnimation.timingFunctions = timingFunctions;
  
  // Rotate animation
  CAKeyframeAnimation * scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
  CATransform3D tTrans  = CATransform3DIdentity;
  tTrans.m34            = -1.f / 900.f;
  scaleAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,0,0,0,1)],
                           [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,-30 * M_PI / 180.f,0,0,1)],
                           [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,30 * M_PI / 180.f,0,0,1)],
                           [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,0,0,0,1)], nil];
  
  scaleAnimation.keyTimes = keyTimes;
  scaleAnimation.duration = duration;
  scaleAnimation.timingFunctions = timingFunctions;
  
  // Checking Pokeball animation
  CAAnimationGroup * checkPokeballAnimation = [CAAnimationGroup animation];
  [checkPokeballAnimation setValue:@"checkPokeball" forKey:@"animationType"];
  checkPokeballAnimation.delegate = self;
  checkPokeballAnimation.duration = duration;
  NSArray * animations = [[NSArray alloc] initWithObjects:moveAnimation, scaleAnimation, nil];
  checkPokeballAnimation.animations = animations;
  checkPokeballAnimation.removedOnCompletion = NO;
  
  [self.pokeball.layer addAnimation:checkPokeballAnimation forKey:@"checkPokeball"];
  
  // Play audio for checking Pokeball
  [self.audioPlayer playForAudioType:kAudioBattlePMCaughtChecking afterDelay:0];
}

// Reset Pokeball
- (void)_resetPokeball:(NSNotification *)notification
{
  [self.pokeball setFrame:CGRectMake((kViewWidth - kCenterMainButtonSize) / 2,
                                     kViewHeight,
                                     kGameMenuPokeballSize,
                                     kGameMenuPokeballSize)];
}

// Action for |buttonFight_|
- (void)_openMoveView
{
  if (self.gameStatusMachine.status == kGameStatusPlayerTurn) {
    if (self.gameMenuMoveViewController == nil) {
      GameMenuMoveViewController * gameMenuMoveViewController = [[GameMenuMoveViewController alloc] init];
      self.gameMenuMoveViewController = gameMenuMoveViewController;
    }
    [self.view addSubview:self.gameMenuMoveViewController.view];
    // update Moves' data
    [self.gameMenuMoveViewController updateFourMoves];
    // load view with animations
    [self.gameMenuMoveViewController loadViewWithAnimationFromLeft:YES animated:YES];
    gameMenuKeyView_ = kGameMenuKeyViewMoveView;
  }
}

// Action for |buttonBag_|
- (void)_openBagView
{
  if (self.gameStatusMachine.status == kGameStatusPlayerTurn) {
    if (self.gameMenuBagViewController == nil) {
      GameMenuBagViewController * gameMenuBagViewController = [[GameMenuBagViewController alloc] init];
      self.gameMenuBagViewController = gameMenuBagViewController;
    }
    [self.view addSubview:self.gameMenuBagViewController.view];
    [self.gameMenuBagViewController loadViewWithAnimationFromLeft:NO animated:YES];
    gameMenuKeyView_ = kGameMenuKeyViewBagView;
  }
}

// Action for |buttonRun_|
- (void)_openRunConfirmView
{
  if (self.gameStatusMachine.status == kGameStatusPlayerTurn) {
    UIAlertView * runConfirmView = [UIAlertView alloc];
    (void)[runConfirmView initWithTitle:nil
                                message:NSLocalizedString(@"PMSRunConfirmViewText", nil)
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"PMSYes", nil)
                      otherButtonTitles:NSLocalizedString(@"PMSNo", nil), nil];
    [runConfirmView show];
  }
}

// Notification for |centerMainButton_| at view bottom
- (void)_toggleSixPokemonsView:(NSNotification *)notification
{
  // Toggle SixPokemons'view only when 
  //   the key view is None or |kGameMenuKeyViewSixPokemonsView|
  if (gameMenuKeyView_ == kGameMenuKeyViewNone ||
      gameMenuKeyView_ == kGameMenuKeyViewSixPokemonsView)
    [self _toggleSixPokemonView];
  // Otherwise, cancel other key views first
  else [self _cancelKeyViewExcept:kGameMenuKeyViewSixPokemonsView];
}

// Update message for game battle
- (void)_updateMessage:(NSNotification *)notification
{
  NSDictionary * userInfo = notification.userInfo;
  
  // Different colors for different type of message owner (action user)
  id user = [userInfo objectForKey:@"user"];
  MEWGameBattleLogType gameBattleLogType = kMEWGameBattleLogTypeNormal;
  if (user != nil) {
    switch ([user intValue]) {
      case kGameSystemProcessUserPlayer:
        gameBattleLogType = kMEWGameBattleLogTypePlayerPMAttack;
        break;
        
      case kGameSystemProcessUserEnemy:
        gameBattleLogType = kMEWGameBattleLogTypeEnemyPMAttack;
        break;
        
      case -1: // What will XXX do?
        gameBattleLogType = kMEWGameBattleLogTypeAskingForUserAction;
        break;
        
      default:
        gameBattleLogType = kMEWGameBattleLogTypeNormal;
        break;
    }
  }
//  else [self.messageView setTextColor:[GlobalRender textColorNormal]];
  
  // Update message
//  [self.messageView setText:[userInfo objectForKey:@"message"]];
  
  //////
  [self.gameBattleLogTableViewController pushLog:[userInfo objectForKey:@"message"]
                                     description:@""
                                         forType:gameBattleLogType];
}

// Update Pokemon's Status
- (void)_updatePokemonStatus:(NSNotification *)notification
{
  NSInteger target = [[notification.userInfo objectForKey:@"target"] intValue];
  if (target & kMoveRealTargetPlayer)
    [self.playerPokemonStatusViewController updatePokemonStatus:notification.userInfo];
  if (target & kMoveRealTargetEnemy)
    [self.enemyPokemonStatusViewController updatePokemonStatus:notification.userInfo];
}

#pragma mark - Gestures ()

// Action for swipe gesture recognizer
- (void)_swipeView:(UISwipeGestureRecognizer *)recognizer
{
  void (^animations)();
  
  switch (recognizer.direction) {
    case UISwipeGestureRecognizerDirectionRight: {
      if (gameMenuKeyView_ == kGameMenuKeyViewNone) [self _openMoveView];
      else [self _cancelKeyViewExcept:kGameMenuKeyViewMoveView];
      return;
      break;
    }
      
    case UISwipeGestureRecognizerDirectionLeft: {
      if (gameMenuKeyView_ == kGameMenuKeyViewNone) [self _openBagView];
      else [self _cancelKeyViewExcept:kGameMenuKeyViewBagView];
      return;
      break;
    }
      
    case UISwipeGestureRecognizerDirectionUp: {
      if (gameMenuKeyView_ == kGameMenuKeyViewNone) {
        CGRect playerPokemonStatusViewFrame = self.playerPokemonStatusViewController.view.frame;
        playerPokemonStatusViewFrame.origin.y =
          kViewHeight - kGameMenuBattleLogViewHeight - kGameMenuPMStatusViewHeight;
        animations = ^(){
          [self.playerPokemonStatusViewController.view setFrame:playerPokemonStatusViewFrame];
        };
        gameMenuKeyView_ = kGameMenuKeyViewPlayerPokemonStatusView;
      }
      else {
        [self _cancelKeyViewExcept:kGameMenuKeyViewPlayerPokemonStatusView];
        return;
      }
      break;
    }
      
    case UISwipeGestureRecognizerDirectionDown: {
      if (gameMenuKeyView_ == kGameMenuKeyViewNone) {
        CGRect enemyPokemonStatusViewFrame = self.enemyPokemonStatusViewController.view.frame;
        enemyPokemonStatusViewFrame.origin.y = 0.f;
        animations = ^(){ [self.enemyPokemonStatusViewController.view setFrame:enemyPokemonStatusViewFrame]; };
        gameMenuKeyView_ = kGameMenuKeyViewEnemyPokemonStatusView;
      }
      else {
        [self _cancelKeyViewExcept:kGameMenuKeyViewEnemyPokemonStatusView];
        return;
      }
      break;
    }
      
    default:
      return;
      break;
  }
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:animations
                   completion:nil];
}

// Action for tap gesture recognizer
- (void)_tapViewAction:(UITapGestureRecognizer *)recognizer
{
  if (recognizer.numberOfTouchesRequired == 2 && recognizer.numberOfTapsRequired == 2)
    [self _openRunConfirmView];
}

// Cancel key view except |targetView|
- (void)_cancelKeyViewExcept:(GameMenuKeyView)targetView
{
  if (gameMenuKeyView_ == targetView)
    return;
  
  void (^animations)();
  
  // Cancel current opening view
  switch (gameMenuKeyView_) {
    case kGameMenuKeyViewSixPokemonsView:
      return;
      break;
      
    case kGameMenuKeyViewMoveView:
      [self.gameMenuMoveViewController unloadViewWithAnimationToLeft:YES animated:YES];
      return;
      break;
      
    case kGameMenuKeyViewBagView:
      if (self.gameMenuBagViewController.isSelectedItemViewOpening)
        [self.gameMenuBagViewController unloadSelcetedItemTalbeView:nil];
      [self.gameMenuBagViewController unloadViewWithAnimationToLeft:NO animated:YES];
      return;
      break;
      
    case kGameMenuKeyViewPlayerPokemonStatusView: {
      animations = ^{
        CGRect playerPokemonStatusViewFrame = self.playerPokemonStatusViewController.view.frame;
        playerPokemonStatusViewFrame.origin.y =
          kViewHeight - kGameMenuBattleLogViewHeight - kGameMenuPMStatusHPBarHeight;
        [self.playerPokemonStatusViewController.view setFrame:playerPokemonStatusViewFrame];
      };
      break;
    }
      
    case kGameMenuKeyViewEnemyPokemonStatusView: {
      CGRect enemyPokemonStatusViewFrame = self.enemyPokemonStatusViewController.view.frame;
      enemyPokemonStatusViewFrame.origin.y =
        - (kGameMenuPMStatusViewHeight - kGameMenuPMStatusHPBarHeight);
      animations = ^{
        [self.enemyPokemonStatusViewController.view setFrame:enemyPokemonStatusViewFrame];
      };
      break;
    }
      
    default:
      animations = nil;
      break;
  }
  gameMenuKeyView_ = kGameMenuKeyViewNone;
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveLinear
                   animations:animations
                   completion:nil];
}

#pragma mark - Public Methods

- (void)prepareForNewScene
{
  if (self.gameMenuSixPokemonsViewController == nil) {
    GameMenuSixPokemonsViewController * gameMenuSixPokemonViewController =
      [[GameMenuSixPokemonsViewController alloc] init];
    self.gameMenuSixPokemonsViewController = gameMenuSixPokemonViewController;
  }
  
  [self.playerPokemonStatusViewController prepareForNewScene];
  [self.enemyPokemonStatusViewController  prepareForNewScene];
  [self.gameMenuSixPokemonsViewController prepareForNewScene];
  if (self.gameMenuMoveViewController != nil)
    [self.gameMenuMoveViewController updateFourMoves];         // Update data in Move View
  currPokemon_ = 0;                                            // Set current Battle Pokemon
                                                               //   !!!TODO, if first one is not available!
}

- (void)reset
{
  [self.playerPokemonStatusViewController reset];
  [self.enemyPokemonStatusViewController  reset];
  [self _resetPokeball:nil];
}

#pragma mark - Animation delegate

- (void)animationDidStop:(CAAnimation *)anim
                finished:(BOOL)flag
{
  if ([[anim valueForKey:@"animationType"] isEqualToString:@"throwPokeballToCatchWildPokemon"]) {
    CGFloat scale = .5f;
    [self.pokeball setFrame:CGRectMake(kGameBattleEnemyPokemonPosX - kGameMenuPokeballSize / 2 * scale,
                                       kViewHeight - kGameBattleEnemyPokemonPosY - kGameMenuPokeballSize / 2 * scale,
                                       kGameMenuPokeballSize * scale,
                                       kGameMenuPokeballSize * scale)];
    // Post notification to |GameBattleLayer| to get WildPokemon into Pokeball
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNPokeballGetWildPokemon object:self userInfo:nil];
  }
}

#pragma mark - UIAlertView Delegate

// Sent to the delegate when the user clicks a button on an alert view.
- (void)   alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0)
    [[GameSystemProcess sharedInstance]
      endBattleWithEventType:kGameBattleEndEventTypeRun];
}

@end
