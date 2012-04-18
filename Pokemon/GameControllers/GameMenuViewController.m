//
//  GameMenuViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuViewController.h"

#import "GlobalConstants.h"
#import "GlobalRender.h"
#import "GlobalNotificationConstants.h"
#import "PMAudioPlayer.h"
#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "TrainerController.h"
//#import "GameTopViewController.h"
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
  UITextView  * messageView_;
  UIImageView * pokemonImageView_;
  UIImageView * pokeball_;
  
  PMAudioPlayer                         * audioPlayer_;
  TrainerController                     * trainer_;
  GameStatusMachine                     * gameStatusMachine_;
//  GameTopViewController                 * gameTopViewController_;
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
  UITapGestureRecognizer   * twoFingersOneTapGestureRecognizer_;  // Open Menu
  
  GameMenuKeyView gameMenuKeyView_;
  NSInteger       currPokemon_;
}

@property (nonatomic, retain) UIView      * menuArea;
@property (nonatomic, retain) UITextView  * messageView;
@property (nonatomic, retain) UIImageView * pokemonImageView;
@property (nonatomic, retain) UIImageView * pokeball;

@property (nonatomic, retain) PMAudioPlayer                         * audioPlayer;
@property (nonatomic, retain) TrainerController                     * trainer;
@property (nonatomic, retain) GameStatusMachine                     * gameStatusMachine;
//@property (nonatomic, retain) GameTopViewController                 * gameTopViewController;
@property (nonatomic, retain) GameEnemyPokemonStatusViewController  * enemyPokemonStatusViewController;
@property (nonatomic, retain) GamePlayerPokemonStatusViewController * playerPokemonStatusViewController;
@property (nonatomic, retain) GameMenuSixPokemonsViewController     * gameMenuSixPokemonsViewController;
@property (nonatomic, retain) GameMenuMoveViewController            * gameMenuMoveViewController;
@property (nonatomic, retain) GameMenuBagViewController             * gameMenuBagViewController;

@property (nonatomic, retain) UISwipeGestureRecognizer * swipeRightGestureRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer * swipeLeftGestureRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer * swipeUpGestureRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer * swipeDownGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer   * twoFingersTwoTapsGestureRecognizer;
@property (nonatomic, retain) UITapGestureRecognizer   * twoFingersOneTapGestureRecognizer;

- (void)releaseSubviews;
// Button Actions
- (void)updateGameMenuKeyView:(NSNotification *)notification;
- (void)toggleSixPokemonView;
- (void)replacePokemon:(NSNotification *)notification;
- (void)catchWildPokemon:(NSNotification *)notification;
- (void)throwPokeballToReplacePokemon;
- (void)throwPokeballToCatchPokemon;
- (void)checkPokeball:(NSNotification *)notification;
- (void)resetPokeball:(NSNotification *)notification;
- (void)getPokemonBack;
- (void)updateForNewPokemon;
- (void)openMoveView;
- (void)openBagView;
- (void)openRunConfirmView;
- (void)toggleSixPokemonsView:(NSNotification *)notification;
- (void)updateMessage:(NSNotification *)notification;
- (void)updatePokemonStatus:(NSNotification *)notification;

// Gesture Action
- (void)swipeView:(UISwipeGestureRecognizer *)recognizer;
- (void)tapViewAction:(UITapGestureRecognizer *)recognizer;
- (void)cancelKeyViewExcept:(GameMenuKeyView)targetView;

@end

@implementation GameMenuViewController

@synthesize delegate = delegate_;

@synthesize menuArea         = menuArea_;
@synthesize messageView      = messageView_;
@synthesize pokemonImageView = pokemonImageView_;
@synthesize pokeball         = pokeball_;

@synthesize audioPlayer                       = audioPlayer_;
@synthesize trainer                           = trainer_;
@synthesize gameStatusMachine                 = gameStatusMachine_;
//@synthesize gameTopViewController             = gameTopViewController_;
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
@synthesize twoFingersOneTapGestureRecognizer  = twoFingersOneTapGestureRecognizer_;

- (void)dealloc {
  self.delegate = nil;
  [self releaseSubviews];
  
  self.audioPlayer                        = nil;
  self.trainer                            = nil;
  self.gameStatusMachine                  = nil;
//  self.gameTopViewController             = nil;
  self.enemyPokemonStatusViewController   = nil;
  self.playerPokemonStatusViewController  = nil;
  self.gameMenuSixPokemonsViewController  = nil;
  self.gameMenuMoveViewController         = nil;
  self.gameMenuBagViewController          = nil;
  
  self.swipeRightGestureRecognizer        = nil;
  self.swipeLeftGestureRecognizer         = nil;
  self.swipeUpGestureRecognizer           = nil;
  self.swipeDownGestureRecognizer         = nil;
  self.twoFingersTwoTapsGestureRecognizer = nil;
  self.twoFingersOneTapGestureRecognizer  = nil;
  
  // Rmove observer for notification
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNUpdateGameMenuKeyView object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNToggleSixPokemons object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNCatchWildPokemon object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNUpdateGameBattleMessage object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNUpdatePokemonStatus object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNReplacePokemon object:self.gameMenuSixPokemonsViewController];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNPokeballChecking object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNPokeballLossWildPokemon object:nil];
  [super dealloc];
}

- (void)releaseSubviews {
  self.menuArea         = nil;
  self.messageView      = nil;
  self.pokemonImageView = nil;
  self.pokeball         = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  self.view = view;
  [view release];
  
  // Constants
  CGRect messageViewFrame             = CGRectMake(0.f,
                                                   kViewHeight - kGameMenuMessageViewHeight,
                                                   kViewWidth,
                                                   kGameMenuMessageViewHeight);
  CGRect enemyPokemonStatusViewFrame  = CGRectMake(0.f,
                                                   kGameMenuPMStatusHPBarHeight - kGameMenuPMStatusViewHeight,
                                                   kViewWidth,
                                                   kGameMenuPMStatusViewHeight);
  CGRect playerPokemonStatusViewFrame = CGRectMake(0.f,
                                                   kViewHeight - kGameMenuMessageViewHeight - kGameMenuPMStatusHPBarHeight,
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
  
  //
  // Top Bar
  //
  //gameTopViewController_ = [[GameTopViewController alloc] init];
  //[self.view addSubview:gameTopViewController_.view];
  
  //
  // Message View
  //
  UITextView * messageView = [[UITextView alloc] initWithFrame:messageViewFrame];
  self.messageView = messageView;
  [messageView release];
  [self.messageView setBackgroundColor:
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"GameMessageViewBackground.png"]]];
  [self.messageView setFont:[GlobalRender textFontBoldInSizeOf:18.f]];
  [self.messageView setTextColor:[GlobalRender textColorNormal]];
  [self.messageView setEditable:NO];
  [self.view addSubview:self.messageView];
  
  // Pokemon Image View (for animation of getting back pokemon)
  UIImageView * pokemonImageView =
    [[UIImageView alloc] initWithFrame:CGRectMake(70.f, kViewHeight, kGameBattlePMSize, kGameBattlePMSize)];
  self.pokemonImageView = pokemonImageView;
  [pokemonImageView release];
  [self.view addSubview:self.pokemonImageView];
  
  // Pokeball
  UIImageView * pokeball =
    [[UIImageView alloc] initWithFrame:CGRectMake((kViewWidth - kCenterMainButtonSize) / 2,
                                                  kViewHeight,
                                                  kGameMenuPokeballSize,
                                                  kGameMenuPokeballSize)];
  self.pokeball = pokeball;
  [pokeball release];
  [self.pokeball setContentMode:UIViewContentModeScaleAspectFit];
  [self.pokeball setImage:[UIImage imageNamed:@"GamePokeball.png"]];
  [self.view addSubview:self.pokeball];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Base Settings
  self.audioPlayer       = [PMAudioPlayer     sharedInstance];
  self.gameStatusMachine = [GameStatusMachine sharedInstance];
  gameMenuKeyView_       = kGameMenuKeyViewNone;
  
  //
  // Getsture Recognizers
  //
  // Swipte to RIGHT, open move view or close bag view
  UISwipeGestureRecognizer * swipeRightGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
  self.swipeRightGestureRecognizer = swipeRightGestureRecognizer;
  [swipeRightGestureRecognizer release];
  [self.swipeRightGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
  [self.view addGestureRecognizer:self.swipeRightGestureRecognizer];
  
  // Swipte to LEFT, open bag view or close move view
  UISwipeGestureRecognizer * swipeLeftGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
  self.swipeLeftGestureRecognizer = swipeLeftGestureRecognizer;
  [swipeLeftGestureRecognizer release];
  [self.swipeLeftGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
  [self.view addGestureRecognizer:self.swipeLeftGestureRecognizer];
  
  // Swipte to UP, open player pokemon status view or close enemy pokemon status view
  UISwipeGestureRecognizer * swipeUpGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
  self.swipeUpGestureRecognizer = swipeUpGestureRecognizer;
  [swipeUpGestureRecognizer release];
  [self.swipeUpGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
  [self.view addGestureRecognizer:self.swipeUpGestureRecognizer];
  
  // Swipte to DOWN, open enemy pokemon status view or close player pokemon status view
  UISwipeGestureRecognizer * swipeDownGestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeView:)];
  self.swipeDownGestureRecognizer = swipeDownGestureRecognizer;
  [swipeDownGestureRecognizer release];
  [self.swipeDownGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
  [self.view addGestureRecognizer:self.swipeDownGestureRecognizer];
  
  // Two finger with two taps to open Run confirm view
  UITapGestureRecognizer * twoFingersTwoTapsGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
  self.twoFingersTwoTapsGestureRecognizer = twoFingersTwoTapsGestureRecognizer;
  [twoFingersTwoTapsGestureRecognizer release];
  [self.twoFingersTwoTapsGestureRecognizer setNumberOfTapsRequired:2];
  [self.twoFingersTwoTapsGestureRecognizer setNumberOfTouchesRequired:2];
  [self.view addGestureRecognizer:self.twoFingersTwoTapsGestureRecognizer];
  
  // Two finger with one tap to open Menu
  UITapGestureRecognizer * twoFingersOneTapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewAction:)];
  self.twoFingersOneTapGestureRecognizer = twoFingersOneTapGestureRecognizer;
  [twoFingersOneTapGestureRecognizer release];
  [self.twoFingersOneTapGestureRecognizer setNumberOfTapsRequired:1];
  [self.twoFingersOneTapGestureRecognizer setNumberOfTouchesRequired:2];
  [self.view addGestureRecognizer:self.twoFingersOneTapGestureRecognizer];
  
  //
  // Notification Observers
  //
  // Add observer for notfication from |GameMenuAbstractChildViewController|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateGameMenuKeyView:)
                                               name:kPMNUpdateGameMenuKeyView
                                             object:nil];
  // Add observer for notification from |centerMainButton_|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(toggleSixPokemonsView:)
                                               name:kPMNToggleSixPokemons
                                             object:nil];
  // Add observer for notification from |BagItemTableViewController|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(catchWildPokemon:)
                                               name:kPMNCatchWildPokemon
                                             object:nil];
  // Add observer for notification from |GameSystemProcess|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateMessage:)
                                               name:kPMNUpdateGameBattleMessage
                                             object:nil];
  // Add observer for notification from |GameMoveEffect|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updatePokemonStatus:)
                                               name:kPMNUpdatePokemonStatus
                                             object:nil];
  // Add observer for notification from |GameMenuSixPokemonsViewController|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(replacePokemon:)
                                               name:kPMNReplacePokemon
                                             object:self.gameMenuSixPokemonsViewController];
  // Noficication from |GameSystemProcess| - |catchingWildPokemon|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(checkPokeball:)
                                               name:kPMNPokeballChecking
                                             object:nil];
  // Notification from |GameSystemProcess| - |caughtWildPokemonSucceed:| if |succeed == NO|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(resetPokeball:)
                                               name:kPMNPokeballLossWildPokemon
                                             object:nil];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self releaseSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

// Update key view
- (void)updateGameMenuKeyView:(NSNotification *)notification {
  gameMenuKeyView_ = kGameMenuKeyViewNone;
}

// Button actions
// Toggle six pokemons' view
- (void)toggleSixPokemonView {
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
- (void)replacePokemon:(NSNotification *)notification {
  gameMenuKeyView_ = kGameMenuKeyViewNone;
  
  CGFloat baseDalay = 0.f;
  // If player's current battle Pokemon not fainted, get back it with animation first
  TrainerTamedPokemon * pokemon = [[self.trainer sixPokemons] objectAtIndex:currPokemon_];
  if ([pokemon.hp intValue] != 0) {
    // Get current battling pokemon back from scene animated
    baseDalay = 1.f;
    [self performSelector:@selector(getPokemonBack) withObject:nil afterDelay:baseDalay];
  }
  // Update for new Pokemon
  [self performSelector:@selector(updateForNewPokemon) withObject:nil afterDelay:baseDalay];
  // Send new pokemon to scene animated
  [self performSelector:@selector(throwPokeballToReplacePokemon) withObject:nil afterDelay:(baseDalay + .8f)];
}

// Try to catch Wild Pokemon
- (void)catchWildPokemon:(NSNotification *)notification {
  gameMenuKeyView_ = kGameMenuKeyViewNone;
  // Throw Pokeball to WildPokemon
  [self performSelector:@selector(throwPokeballToCatchPokemon) withObject:nil afterDelay:1.f];
}

// Get current battling pokemon back from scene
- (void)getPokemonBack {
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
  [animations release];
  
  TrainerTamedPokemon * pokemon = [[self.trainer sixPokemons] objectAtIndex:currPokemon_];
  [self.pokemonImageView setImage:pokemon.pokemon.imageBack];
  [self.pokemonImageView.layer addAnimation:getPokemonBackAnimation forKey:@"getPokemonBack"];
  pokemon = nil;
}

// Update data for new Pokemon (generally dispatched after method:|getPokemonBack|)
- (void)updateForNewPokemon {
  // Post notification to |GameBattleLayer| to replace pokemon sprite
  NSInteger newPokemonIndex = self.gameMenuSixPokemonsViewController.currBattlePokemon - 1;
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithInt:newPokemonIndex], @"newPokemon", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNReplacePlayerPokemon object:self userInfo:userInfo];
  [userInfo release];
  
  // Set Game System Process
  GameSystemProcess * gameSystemProcess = [GameSystemProcess sharedInstance];
  [gameSystemProcess setSystemProcessOfReplacePokemonWithUser:kGameSystemProcessUserPlayer
                                         selectedPokemonIndex:++newPokemonIndex];
  [[GameStatusMachine sharedInstance] endStatus:kGameStatusPlayerTurn];
}

// Throw Pokeball to send new pokemon to scene, replace the old one
- (void)throwPokeballToReplacePokemon {
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
  [animations release];
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
- (void)throwPokeballToCatchPokemon {
  NSLog(@"|%@| - |throwPokeballToCatchPokemon|", [self class]);
  
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
  [animations release];
  [self.pokeball.layer addAnimation:throwPokeballAnimation forKey:@"throwPokeballToCatchWildPokemon"];
  
  // Play audio for throwing Pokeball
  [self.audioPlayer playForAudioType:kAudioBattleThrowPokeball afterDelay:0];
}

// Check Pokeball whether the Wild Pokemon caught with animations
- (void)checkPokeball:(NSNotification *)notification {
  NSLog(@"|%@| - |checkPokeball|......", [self class]);
  
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
                            [NSNumber numberWithFloat:originalPositionX - 5],
                            [NSNumber numberWithFloat:originalPositionX + 5],
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
  [animations release];
  
  [self.pokeball.layer addAnimation:checkPokeballAnimation forKey:@"checkPokeball"];
  
  // Play audio for checking Pokeball
  [self.audioPlayer playForAudioType:kAudioBattlePMCaughtChecking afterDelay:0];
}

// Reset Pokeball
- (void)resetPokeball:(NSNotification *)notification {
  [self.pokeball setFrame:CGRectMake((kViewWidth - kCenterMainButtonSize) / 2,
                                     kViewHeight,
                                     kGameMenuPokeballSize,
                                     kGameMenuPokeballSize)];
}

// Action for |buttonFight_|
- (void)openMoveView {
  if (self.gameStatusMachine.status == kGameStatusPlayerTurn) {
    if (self.gameMenuMoveViewController == nil) {
      GameMenuMoveViewController * gameMenuMoveViewController = [[GameMenuMoveViewController alloc] init];
      self.gameMenuMoveViewController = gameMenuMoveViewController;
      [gameMenuMoveViewController release];
    }
    [self.view addSubview:self.gameMenuMoveViewController.view];
    // Update Moves' data & load view with animations
    [self.gameMenuMoveViewController updateFourMoves];
    [self.gameMenuMoveViewController loadViewWithAnimationFromLeft:YES animated:YES];
    gameMenuKeyView_ = kGameMenuKeyViewMoveView;
  }
}

// Action for |buttonBag_|
- (void)openBagView {
  if (self.gameStatusMachine.status == kGameStatusPlayerTurn) {
    if (self.gameMenuBagViewController == nil) {
      GameMenuBagViewController * gameMenuBagViewController = [[GameMenuBagViewController alloc] init];
      self.gameMenuBagViewController = gameMenuBagViewController;
      [gameMenuBagViewController release];
    }
    [self.view addSubview:self.gameMenuBagViewController.view];
    [self.gameMenuBagViewController loadViewWithAnimationFromLeft:NO animated:YES];
    gameMenuKeyView_ = kGameMenuKeyViewBagView;
  }
}

// Action for |buttonRun_|
- (void)openRunConfirmView {
  if (self.gameStatusMachine.status == kGameStatusPlayerTurn) {
    UIAlertView * runConfirmView = [[UIAlertView alloc] initWithTitle:nil
                                                              message:NSLocalizedString(@"PMSRunConfirmViewText", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"PMSRunConfirmViewYes", nil)
                                                    otherButtonTitles:NSLocalizedString(@"PMSRunConfirmViewNo", nil), nil];
    [runConfirmView show];
    [runConfirmView release];
  }
}

// Notification for |centerMainButton_| at view bottom
- (void)toggleSixPokemonsView:(NSNotification *)notification {
  // Toggle SixPokemons'view only when 
  //   the key view is None or |kGameMenuKeyViewSixPokemonsView|
  if (gameMenuKeyView_ == kGameMenuKeyViewNone ||
      gameMenuKeyView_ == kGameMenuKeyViewSixPokemonsView)
    [self toggleSixPokemonView];
  // Otherwise, cancel other key views first
  else [self cancelKeyViewExcept:kGameMenuKeyViewSixPokemonsView];
}

// Update message for game battle
- (void)updateMessage:(NSNotification *)notification {
  NSDictionary * userInfo = notification.userInfo;
  
  // Different colors for different type of message owner (action user)
  id user = [userInfo objectForKey:@"user"];
  if (user != nil) {
    switch ([user intValue]) {
      case kGameSystemProcessUserPlayer:
        [self.messageView setTextColor:[GlobalRender textColorBlue]];
        break;
        
      case kGameSystemProcessUserEnemy:
        [self.messageView setTextColor:[GlobalRender textColorRed]];
        break;
        
      case -1: // What will XXX do?
        [self.messageView setTextColor:[GlobalRender textColorOrange]];
        break;
        
      default:
        [self.messageView setTextColor:[GlobalRender textColorNormal]];
        break;
    }
  }
  else [self.messageView setTextColor:[GlobalRender textColorNormal]];
  
  // Update message
  [self.messageView setText:[userInfo objectForKey:@"message"]];
}

// Update Pokemon's Status
- (void)updatePokemonStatus:(NSNotification *)notification {
  NSInteger target = [[notification.userInfo objectForKey:@"target"] intValue];
  if (target & kMoveRealTargetPlayer)
    [self.playerPokemonStatusViewController updatePokemonStatus:notification.userInfo];
  if (target & kMoveRealTargetEnemy)
    [self.enemyPokemonStatusViewController updatePokemonStatus:notification.userInfo];
}

#pragma mark - Gestures ()

// Action for swipe gesture recognizer
- (void)swipeView:(UISwipeGestureRecognizer *)recognizer {
  void (^animations)();
  
  switch (recognizer.direction) {
    case UISwipeGestureRecognizerDirectionRight: {
      NSLog(@"Swipe to Right");
      if (gameMenuKeyView_ == kGameMenuKeyViewNone) [self openMoveView];
      else [self cancelKeyViewExcept:kGameMenuKeyViewMoveView];
      return;
      break;
    }
      
    case UISwipeGestureRecognizerDirectionLeft: {
      NSLog(@"Swipe to Left");
      if (gameMenuKeyView_ == kGameMenuKeyViewNone) [self openBagView];
      else [self cancelKeyViewExcept:kGameMenuKeyViewBagView];
      return;
      break;
    }
      
    case UISwipeGestureRecognizerDirectionUp: {
      NSLog(@"Swipe to Up");
      if (gameMenuKeyView_ == kGameMenuKeyViewNone) {
        CGRect playerPokemonStatusViewFrame = self.playerPokemonStatusViewController.view.frame;
        playerPokemonStatusViewFrame.origin.y = kViewHeight - kGameMenuMessageViewHeight - kGameMenuPMStatusViewHeight;
        animations = ^(){
          [self.playerPokemonStatusViewController.view setFrame:playerPokemonStatusViewFrame];
        };
        gameMenuKeyView_ = kGameMenuKeyViewPlayerPokemonStatusView;
      }
      else {
        [self cancelKeyViewExcept:kGameMenuKeyViewPlayerPokemonStatusView];
        return;
      }
      break;
    }
      
    case UISwipeGestureRecognizerDirectionDown: {
      NSLog(@"Swipe to Down");
      if (gameMenuKeyView_ == kGameMenuKeyViewNone) {
        CGRect enemyPokemonStatusViewFrame = self.enemyPokemonStatusViewController.view.frame;
        enemyPokemonStatusViewFrame.origin.y = 0.f;
        animations = ^(){ [self.enemyPokemonStatusViewController.view setFrame:enemyPokemonStatusViewFrame]; };
        gameMenuKeyView_ = kGameMenuKeyViewEnemyPokemonStatusView;
      }
      else {
        [self cancelKeyViewExcept:kGameMenuKeyViewEnemyPokemonStatusView];
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
- (void)tapViewAction:(UITapGestureRecognizer *)recognizer {
  if (recognizer.numberOfTouchesRequired == 2 && recognizer.numberOfTapsRequired == 2)
    [self openRunConfirmView];
}

// Cancel key view except |targetView|
- (void)cancelKeyViewExcept:(GameMenuKeyView)targetView {
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
        playerPokemonStatusViewFrame.origin.y = kViewHeight - kGameMenuMessageViewHeight - kGameMenuPMStatusHPBarHeight;
        [self.playerPokemonStatusViewController.view setFrame:playerPokemonStatusViewFrame];
      };
      break;
    }
      
    case kGameMenuKeyViewEnemyPokemonStatusView: {
      CGRect enemyPokemonStatusViewFrame = self.enemyPokemonStatusViewController.view.frame;
      enemyPokemonStatusViewFrame.origin.y = - (kGameMenuPMStatusViewHeight - kGameMenuPMStatusHPBarHeight);
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

- (void)prepareForNewScene {
  if (self.gameMenuSixPokemonsViewController == nil) {
    GameMenuSixPokemonsViewController * gameMenuSixPokemonViewController =
      [[GameMenuSixPokemonsViewController alloc] init];
    self.gameMenuSixPokemonsViewController = gameMenuSixPokemonViewController;
    [gameMenuSixPokemonViewController release];
  }
  
  [self.playerPokemonStatusViewController prepareForNewScene];
  [self.enemyPokemonStatusViewController  prepareForNewScene];
  [self.gameMenuSixPokemonsViewController prepareForNewScene];
  if (self.gameMenuMoveViewController != nil)
    [self.gameMenuMoveViewController updateFourMoves];         // Update data in Move View
  currPokemon_ = 0;                                            // Set current Battle Pokemon
                                                               //   !!!TODO, if first one is not available!
}

- (void)reset {
  [self.playerPokemonStatusViewController reset];
  [self.enemyPokemonStatusViewController  reset];
  [self resetPokeball:nil];
  [self.messageView setText:@""];
}

#pragma mark - Animation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [[GameSystemProcess sharedInstance] endBattleWithEventType:kGameBattleEndEventTypeRun];
  }
}

@end
