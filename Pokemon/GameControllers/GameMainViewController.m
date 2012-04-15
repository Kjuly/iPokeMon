//
//  GameMainViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMainViewController.h"

//#import "GameConfig.h"
#import "GlobalConstants.h"
#import "GlobalNotificationConstants.h"
#import "PMAudioPlayer.h"
#import "GameBattleLayer.h"
#import "GameMenuViewController.h"
#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "WildPokemonController.h"
#import "GameBattleEventViewController.h"
#import "GameBattleEndViewController.h"

#import "cocos2d.h"


@interface GameMainViewController () {
 @private
  PMAudioPlayer                 * audioPlayer_;
  CenterMainButtonStatus previousCenterMainButtonStatus_;
  GameBattleEventViewController * gameBattleEventViewController_;
  GameBattleEndViewController   * gameBattleEndViewController_;
  BOOL                            isLoadingResourceForBattle_;
}

@property (nonatomic, retain) PMAudioPlayer                 * audioPlayer;
@property (nonatomic, assign) CenterMainButtonStatus previousCenterMainButtonStatus;
@property (nonatomic, retain) GameBattleEventViewController * gameBattleEventViewController;
@property (nonatomic, retain) GameBattleEndViewController   * gameBattleEndViewController;

- (void)startBattle:(NSNotification *)notification;
- (void)loadBattleScene:(NSNotification *)notification;
- (void)loadViewForEvent:(NSNotification *)notification;
- (void)endGameBattleWithEvent:(NSNotification *)notification;

@end


@implementation GameMainViewController

@synthesize gameMenuViewController         = gameMenuViewController_;

@synthesize audioPlayer                    = audioPlayer_;
@synthesize previousCenterMainButtonStatus = previousCenterMainButtonStatus_;
@synthesize gameBattleEventViewController  = gameBattleEventViewController_;
@synthesize gameBattleEndViewController    = gameBattleEndViewController_;

- (void)dealloc
{
  [audioPlayer_                 release];
  [gameMenuViewController_      release];
  [gameBattleEndViewController_ release];
  
  // Remove observers
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNBattleStart object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNGameBattleRunEvent object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNGameBattleEndWithEvent object:nil];
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
  [super loadView];
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(kViewWidth, 0.f, kViewWidth, kViewHeight)];
  self.view = view;
  [view release];
  [self.view setAlpha:0.f];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Basic settings
  isLoadingResourceForBattle_ = NO;
  
  // Add Notification Observer
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(startBattle:)
                                               name:kPMNBattleStart
                                             object:nil];
  // Notification from |LoadingManageer| when loading done
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadBattleScene:)
                                               name:kPMNLoadingDone
                                             object:nil];
  // Notification from |GameSystemProcess| when an EVENT occurred
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadViewForEvent:)
                                               name:kPMNGameBattleRunEvent
                                             object:nil];
  // Notification from |GameSystemProcess| when battle END
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(endGameBattleWithEvent:)
                                               name:kPMNGameBattleEndWithEvent
                                             object:nil];
  
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
  [[CCDirector sharedDirector] pause];
  
  // Audio Player
  self.audioPlayer = [PMAudioPlayer sharedInstance];
  
  // Game Menu View Controller
  gameMenuViewController_ = [[GameMenuViewController alloc] init];
  gameMenuViewController_.delegate = self;
  [self.view addSubview:gameMenuViewController_.view];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.gameMenuViewController = nil;
  self.gameBattleEndViewController = nil;
  
  // Unload |director|
  [[CCDirector sharedDirector] end];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - GameMenuViewControllerDelegate

- (void)unloadBattleScene
{
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithInt:self.previousCenterMainButtonStatus],
                             @"previousCenterMainButtonStatus", nil];
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.view setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.view setFrame:CGRectMake(kViewWidth, 0.f, kViewWidth, kViewHeight)];
                     [[NSNotificationCenter defaultCenter] postNotificationName:kPMNBattleEnd
                                                                         object:self
                                                                       userInfo:userInfo];
                     [userInfo release];
                     [[CCDirector sharedDirector] pause];
                     // Reset all status
                     [[GameStatusMachine sharedInstance] resetStatus];
                     [[GameSystemProcess sharedInstance] reset];
                     [self.audioPlayer endBattle];
                     [self.gameMenuViewController reset];
                   }];
}

#pragma mark - Private Methods

- (void)startBattle:(NSNotification *)notification {
  // Mark now is loading resources for battle,
  //   so it can load battle scene when receives the notification from |LoadingManageer|
  isLoadingResourceForBattle_ = YES;
  
  // Remember previous |centerMainButton_|'s status
  NSLog(@"Pokemon Info: %@", notification.userInfo);
  self.previousCenterMainButtonStatus = [[notification.userInfo objectForKey:@"previousCenterMainButtonStatus"] intValue];
  
  // Preload audio resources for battle scene
  [self.audioPlayer preloadForBattleVSWildPokemon];
}

// Load battle scene
- (void)loadBattleScene:(NSNotification *)notification {
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
                      options:UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.view setAlpha:1.f];
                   }
                   completion:^(BOOL finished) {
                     [[CCDirector sharedDirector] resume];
                   }];
}

// Load game EVENT view
- (void)loadViewForEvent:(NSNotification *)notification {
  GameBattleEventType eventType = [[notification.userInfo valueForKey:@"eventType"] intValue];
  if (eventType == kGameBattleEventTypeNone)
    return;
  
  if (self.gameBattleEventViewController == nil) {
    GameBattleEventViewController * gameBattleEventViewController = [[GameBattleEventViewController alloc] init];
    self.gameBattleEventViewController = gameBattleEventViewController;
    [gameBattleEventViewController release];
  }
  
  [[[[UIApplication sharedApplication] delegate] window] addSubview:self.gameBattleEventViewController.view];
  NSTimeInterval delay = 1.5f;
  [self.gameBattleEventViewController loadViewWithEventType:eventType
                                                       info:notification.userInfo
                                                   animated:YES
                                                 afterDelay:delay];
}

// End game battle with Events:
//   Player WIN/LOSE
//   Caught Wild Pokemon
- (void)endGameBattleWithEvent:(NSNotification *)notification {
  GameBattleEndEventType battleEndEventType = [[notification.userInfo valueForKey:@"battleEndEventType"] intValue];
  
  // If no more Event need to be occurred, just unload battle scene
  if (battleEndEventType == kGameBattleEndEventTypeNone) {
    [self unloadBattleScene];
    return;
  }
  
  if (self.gameBattleEndViewController == nil) {
    GameBattleEndViewController * gameBattleEndViewController = [[GameBattleEndViewController alloc] init];
    self.gameBattleEndViewController = gameBattleEndViewController;
    [gameBattleEndViewController release];
  }
  
  NSTimeInterval delay = 1.5f;
  if (battleEndEventType != kGameBattleEndEventTypeWin && battleEndEventType != kGameBattleEndEventTypeRun) {
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.gameBattleEndViewController.view];
    [self.gameBattleEndViewController loadViewWithEventType:battleEndEventType
                                                   animated:YES
                                                 afterDelay:delay];
  }
  
  [self performSelector:@selector(unloadBattleScene) withObject:nil afterDelay:delay];
}

@end
