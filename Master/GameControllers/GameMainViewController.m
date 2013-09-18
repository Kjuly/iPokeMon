//
//  GameMainViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMainViewController.h"

#import "PMAudioPlayer.h"
#import "TrainerController.h"
#import "GameBattleLayer.h"
#import "GameStatusMachine.h"
#import "GameSystemProcess.h"


@interface GameMainViewController () {
 @private
  PMAudioPlayer                 * audioPlayer_;
  GameBattleEventViewController * gameBattleEventViewController_;
  GameBattleEndViewController   * gameBattleEndViewController_;
  
  CenterMainButtonStatus previousCenterMainButtonStatus_;
  BOOL                   isLoadingResourceForBattle_;
}

@property (nonatomic, strong) PMAudioPlayer                 * audioPlayer;
@property (nonatomic, strong) GameBattleEventViewController * gameBattleEventViewController;
@property (nonatomic, strong) GameBattleEndViewController   * gameBattleEndViewController;

- (void)_setupNotificationObservers;
- (void)_loadBattleScene:(NSNotification *)notification;
- (void)_loadViewForEvent:(NSNotification *)notification;
- (void)_endGameBattleWithEvent:(NSNotification *)notification;

@end


@implementation GameMainViewController

@synthesize gameMenuViewController        = gameMenuViewController_;

@synthesize audioPlayer                   = audioPlayer_;
@synthesize gameBattleEventViewController = gameBattleEventViewController_;
@synthesize gameBattleEndViewController   = gameBattleEndViewController_;

- (void)dealloc
{
  // Remove notification observer
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
  return (self = [super init]);
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(kViewWidth, 0.f, kViewWidth, kViewHeight)];
  [view setAlpha:0.f];
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Basic settings
  isLoadingResourceForBattle_ = NO;
  // Audio Player
  self.audioPlayer = [PMAudioPlayer sharedInstance];
  
  // Setup notification observer
  [self _setupNotificationObservers];
  
  // Cocos2D Part
  EAGLView * glView = [EAGLView viewWithFrame:self.view.bounds
                                  pixelFormat:kEAGLColorFormatRGB565  // kEAGLColorFormatRGBA8
                                  depthFormat:0];                     // GL_DEPTH_COMPONENT16_OES
  [glView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
  [[CCDirector sharedDirector] setOpenGLView:glView];
  //[self setView:glView];
  //[self.view insertSubview:glView atIndex:0];
  [self.view addSubview:glView];
  
  // Run a blank scene & pause the it untile a Pokemon appeared
  CCScene * blankScene = [CCScene node];
  [[CCDirector sharedDirector] runWithScene:blankScene];
  blankScene = nil;
//  [[CCDirector sharedDirector] enableRetinaDisplay:YES];
  [[CCDirector sharedDirector] pause];
  
  // Game Menu View Controller
  gameMenuViewController_ = [[GameMenuViewController alloc] init];
  gameMenuViewController_.delegate = self;
  [self.view addSubview:gameMenuViewController_.view];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Unload |director|
  [[CCDirector sharedDirector] end];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

- (void)startBattleWithPreviousCenterMainButtonStatus:(CenterMainButtonStatus)previousCenterMainButtonStatus
{
  NSLog (@"START GAME BATTLE...");
  // Remember previous |centerMainButton_|'s status
  previousCenterMainButtonStatus_ = previousCenterMainButtonStatus;
  
  // If Trainer has no battle available Pokemon, don't load Battle Scene,
  //   load |gameBattleEventView| to show a message instead
  if ([[TrainerController sharedInstance] battleAvailablePokemonIndex] == 0) {
    if (self.gameBattleEventViewController == nil) {
      GameBattleEventViewController * gameBattleEventViewController = [[GameBattleEventViewController alloc] init];
      self.gameBattleEventViewController = gameBattleEventViewController;
    }
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.gameBattleEventViewController.view];
    [self.gameBattleEventViewController loadViewWithEventType:kGameBattleEventTypeNoPMAvailable
                                                         info:nil
                                                     animated:YES
                                                   afterDelay:0];
    return;
  }
  
  // Mark now is loading resources for battle,
  //   so it can load battle scene when receives the notification from |LoadingManageer|
  isLoadingResourceForBattle_ = YES;
  
  // Preload audio resources for battle scene.
  // If no resources available, just load battle scene;
  // Otherwise, when resources are loaded, load battle scene
  //   by sending |kPMNLoadingDone| notification to dispatch |-_loadBattleScene:|.
  if ([[NSUserDefaults standardUserDefaults] integerForKey:kUDKeyGameSettingsMaster] == 0
      || ! [ResourceManager sharedInstance].bundle)
    [self _loadBattleScene:nil];
  else [self.audioPlayer preloadForBattleVSWildPokemon];
}

#pragma mark - GameMenuViewControllerDelegate

- (void)unloadBattleScene
{
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithInt:previousCenterMainButtonStatus_],
                             @"previousCenterMainButtonStatus", nil];
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.view setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.view setFrame:CGRectMake(kViewWidth, 0.f, kViewWidth, kViewHeight)];
//                     [[CCDirector sharedDirector] pause];
                     [[CCDirector sharedDirector] end];
                     // Reset all status
                     [[GameStatusMachine sharedInstance] resetStatus];
                     [[GameSystemProcess sharedInstance] reset];
                     [self.audioPlayer cleanForBattle]; // Clean AUDIO resources for battle scene
                     [self.gameMenuViewController reset];
                     [self.view removeFromSuperview];
                     [[NSNotificationCenter defaultCenter] postNotificationName:kPMNBattleEnd
                                                                         object:self
                                                                       userInfo:userInfo];
                   }];
}

#pragma mark - Private Methods

// Setup notification observers
- (void)_setupNotificationObservers
{
  NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
  // Notification from |LoadingManageer| when loading done
  [notificationCenter addObserver:self
                         selector:@selector(_loadBattleScene:)
                             name:kPMNLoadingDone
                           object:nil];
  // Notification from |GameSystemProcess| when an EVENT occurred
  [notificationCenter addObserver:self
                         selector:@selector(_loadViewForEvent:)
                             name:kPMNGameBattleRunEvent
                           object:nil];
  // Notification from |GameSystemProcess| when battle END
  [notificationCenter addObserver:self
                         selector:@selector(_endGameBattleWithEvent:)
                             name:kPMNGameBattleEndWithEvent
                           object:nil];
}

// Load battle scene
- (void)_loadBattleScene:(NSNotification *)notification
{
  // Only load scene when it is loading resource for battle
  if (! isLoadingResourceForBattle_)
    return;
  // Reset mark
  isLoadingResourceForBattle_ = NO;
  
  // Replace the previous scene before show the battle scene
  //   and prepare data for new scene
  [[CCDirector sharedDirector] replaceScene:[GameBattleLayer scene]];
  [[GameSystemProcess sharedInstance] prepareForNewSceneBattleBetweenTrainers:NO];
  [self.gameMenuViewController        prepareForNewScene];
  
  [self.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.view setAlpha:1.f];
                   }
                   completion:^(BOOL finished) {
                     [[CCDirector sharedDirector] resume];
                   }];
}

// Load game EVENT view
- (void)_loadViewForEvent:(NSNotification *)notification
{
  GameBattleEventType eventType = [[notification.userInfo valueForKey:@"eventType"] intValue];
  if (eventType == kGameBattleEventTypeNone)
    return;
  
  if (self.gameBattleEventViewController == nil) {
    self.gameBattleEventViewController = [[GameBattleEventViewController alloc] init];
  }
  
  [self.view.window addSubview:self.gameBattleEventViewController.view];
  NSTimeInterval delay = 1.5f;
  [self.gameBattleEventViewController loadViewWithEventType:eventType
                                                       info:notification.userInfo
                                                   animated:YES
                                                 afterDelay:delay];
}

// End game battle with Events:
//   Player WIN/LOSE
//   Caught Wild Pokemon
- (void)_endGameBattleWithEvent:(NSNotification *)notification
{
  GameBattleEndEventType battleEndEventType;
  if ([notification.userInfo valueForKey:@"battleEndEventType"])
    battleEndEventType = [[notification.userInfo valueForKey:@"battleEndEventType"] intValue];
  else battleEndEventType = kGameBattleEndEventTypeNone;
   
  // If no more Event need to be occurred, just unload battle scene
  if (battleEndEventType == kGameBattleEndEventTypeNone) {
    [self unloadBattleScene];
    return;
  }
  
  if (self.gameBattleEndViewController == nil) {
    self.gameBattleEndViewController = [[GameBattleEndViewController alloc] init];
  }
  
  NSTimeInterval delay = 1.8f;
  if (battleEndEventType != kGameBattleEndEventTypeWin &&
      battleEndEventType != kGameBattleEndEventTypeRun)
  {
    //[[[[UIApplication sharedApplication] delegate] window] addSubview:self.gameBattleEndViewController.view];
    [self.view.window addSubview:self.gameBattleEndViewController.view];
    [self.gameBattleEndViewController loadViewWithEventType:battleEndEventType
                                                   animated:YES
                                                 afterDelay:delay];
  }
  
  [self performSelector:@selector(unloadBattleScene)
             withObject:nil
             afterDelay:delay];
}

@end
