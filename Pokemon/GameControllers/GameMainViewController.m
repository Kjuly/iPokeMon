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

#import "cocos2d.h"


@interface GameMainViewController () {
 @private
  CenterMainButtonStatus previousCenterMainButtonStatus_;
}

@property (nonatomic, assign) CenterMainButtonStatus previousCenterMainButtonStatus;

- (void)loadBattleScene:(NSNotification *)notification;

@end

@implementation GameMainViewController

@synthesize gameMenuViewController = gameMenuViewController_;
@synthesize previousCenterMainButtonStatus = previousCenterMainButtonStatus_;

- (void)dealloc
{
  [gameMenuViewController_ release];
  
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
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(320.0f, 0.0f, 320.0f, 480.0f)];
  self.view = view;
  [view release];
  
  [self.view setBackgroundColor:[UIColor grayColor]];
  [self.view setAlpha:0.0f];
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
  
  // Cocos2D Part
  EAGLView * glView = [EAGLView viewWithFrame:self.view.bounds
                                  pixelFormat:kEAGLColorFormatRGB565  // kEAGLColorFormatRGBA8
                                  depthFormat:0];                     // GL_DEPTH_COMPONENT16_OES
  [glView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
  [[CCDirector sharedDirector] setOpenGLView:glView];
  //[self setView:glView];
  //[self.view insertSubview:glView atIndex:0];
  [self.view addSubview:glView];
  
  // Run Game Scene & but pause the game untile a Pokemon Appeared
  [[CCDirector sharedDirector] runWithScene:[GameBattleLayer scene]];
  [[CCDirector sharedDirector] pause];
  
  // Set Game Menu View Controller
  gameMenuViewController_ = [[GameMenuViewController alloc] init];
  gameMenuViewController_.delegate = self;
  [self.view addSubview:gameMenuViewController_.view];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.gameMenuViewController = nil;

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
  NSLog(@"Battle Scene Unloading...");
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithInt:self.previousCenterMainButtonStatus],
                             @"previousCenterMainButtonStatus", nil];
  
  [UIView animateWithDuration:0.3f
                        delay:0.0f
                      options:UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.view setAlpha:0.0f];
                   }
                   completion:^(BOOL finished) {
                     [self.view setFrame:CGRectMake(320.0f, 0.0f, 320.0f, 480.0f)];
                     [[NSNotificationCenter defaultCenter] postNotificationName:kPMNBattleEnd
                                                                         object:self
                                                                       userInfo:userInfo];
                     [userInfo release];
                     [[CCDirector sharedDirector] pause];
                   }];
}

#pragma mark - Private Methods

- (void)loadBattleScene:(NSNotification *)notification
{
  // Remember previous |centerMainButton_|'s status
  self.previousCenterMainButtonStatus = [[notification.userInfo objectForKey:@"previousCenterMainButtonStatus"] intValue];
  
  NSLog(@"Battle Scene Loading...");
  [[CCDirector sharedDirector] replaceScene:[GameBattleLayer scene]];
  [self.view setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  [UIView animateWithDuration:0.3f
                        delay:0.0f
                      options:UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.view setAlpha:1.0f];
                   }
                   completion:^(BOOL finished) {
//                     [[GameBattleLayer sharedInstance] generateNewSceneWithWildPokemonID:8];
                     [[CCDirector sharedDirector] resume];
                   }];
  NSLog(@"Pokemon Info: %@", notification.userInfo);
}

@end
