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
#import "GameBattleLayer.h"
#import "GameMenuViewController.h"
#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "GameBattleEndViewController.h"

#import "cocos2d.h"


@interface GameMainViewController () {
 @private
  CenterMainButtonStatus previousCenterMainButtonStatus_;
  GameBattleEndViewController * gameBattleEndViewController_;
}

@property (nonatomic, assign) CenterMainButtonStatus previousCenterMainButtonStatus;
@property (nonatomic, retain) GameBattleEndViewController * gameBattleEndViewController;

- (void)loadBattleScene:(NSNotification *)notification;
- (void)endGameBattleWithPlayerWin:(NSNotification *)notification;
- (void)endGameBattleWithPlayerLose:(NSNotification *)notification;
- (void)endGameBattleWithCaughtWildPokemon:(NSNotification *)notification;

@end


@implementation GameMainViewController

@synthesize gameMenuViewController         = gameMenuViewController_;

@synthesize previousCenterMainButtonStatus = previousCenterMainButtonStatus_;
@synthesize gameBattleEndViewController    = gameBattleEndViewController_;

- (void)dealloc
{
  [gameMenuViewController_ release];
  [gameBattleEndViewController_ release];
  
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
  
  // Add Notification Observer
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadBattleScene:)
                                               name:kPMNBattleStart
                                             object:nil];
  // Notification from ||
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(endGameBattleWithPlayerWin:)
                                               name:kPMNGameBattleEndWithPlayerWin
                                             object:nil];
  // Notification from ||
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(endGameBattleWithPlayerLose:)
                                               name:kPMNGameBattleEndWithPlayerLose
                                             object:nil];
  // Notification from |GameSystemProcess| when caught a Wild Pokemon
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(endGameBattleWithCaughtWildPokemon:)
                                               name:kPMNGameBattleEndWithCaughtWildPokemon
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

  // Remove Notification Observer
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNBattleStart object:nil];
  
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
                     [self.gameMenuViewController reset];
                   }];
}

#pragma mark - Private Methods

- (void)loadBattleScene:(NSNotification *)notification
{
  NSLog(@"Pokemon Info: %@", notification.userInfo);
  // Remember previous |centerMainButton_|'s status
  self.previousCenterMainButtonStatus = [[notification.userInfo objectForKey:@"previousCenterMainButtonStatus"] intValue];
  
  // Replace the previous scene before show the battle scene
  [[CCDirector sharedDirector] replaceScene:[GameBattleLayer scene]];
  // Prepare data for new scene
  [[GameSystemProcess sharedInstance] prepareForNewScene];
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

// End game battle with Player Win Event
- (void)endGameBattleWithPlayerWin:(NSNotification *)notification {
  
}

// End game battle with Player Lose Event
- (void)endGameBattleWithPlayerLose:(NSNotification *)notification {
  
}

// End game battle with Caught WildPokemon Event
- (void)endGameBattleWithCaughtWildPokemon:(NSNotification *)notification {
  if (self.gameBattleEndViewController == nil) {
    GameBattleEndViewController * gameBattleEndViewController = [[GameBattleEndViewController alloc] init];
    self.gameBattleEndViewController = gameBattleEndViewController;
    [gameBattleEndViewController release];
  }
  [[[[UIApplication sharedApplication] delegate] window] addSubview:self.gameBattleEndViewController.view];
  [self.gameBattleEndViewController loadViewWithEventType:kGameBattleEndEventTypeCaughtWildPokemon animated:YES];
  [self unloadBattleScene];
}

@end
