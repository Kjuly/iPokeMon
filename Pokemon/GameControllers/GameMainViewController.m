//
//  GameMainViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMainViewController.h"

//#import "GameConfig.h"
#import "GlobalNotificationConstants.h"
#import "GameBattleLayer.h"

#import "cocos2d.h"


@interface GameMainViewController ()

- (void)loadBattleScene:(NSNotification *)notification;
- (void)unloadBattleScene:(id)sender;

@end

@implementation GameMainViewController

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
                                               name:kPMNPokemonAppeared
                                             object:nil];
  
  UIButton * buttonForGameEnding = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 160.0f, 300.0f, 32.0f)];
  [buttonForGameEnding setBackgroundColor:[UIColor blackColor]];
  [buttonForGameEnding setTitle:@"Battle End" forState:UIControlStateNormal];
  [buttonForGameEnding addTarget:self action:@selector(unloadBattleScene:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:buttonForGameEnding];
  [buttonForGameEnding release];
  
  
  // Cocos2D Part
  EAGLView * glView = [EAGLView viewWithFrame:self.view.bounds
                                  pixelFormat:kEAGLColorFormatRGB565  // kEAGLColorFormatRGBA8
                                  depthFormat:0];                     // GL_DEPTH_COMPONENT16_OES
  [glView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
  [[CCDirector sharedDirector] setOpenGLView:glView];
//  [self setView:glView];
//  [self.view insertSubview:glView atIndex:0];
  [self.view addSubview:glView];
  
  // Run Game Scene
  [[CCDirector sharedDirector] runWithScene:[GameBattleLayer scene]];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  // Remove Notification Observer
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNPokemonAppeared object:nil];
  
  // Unload |director|
  [[CCDirector sharedDirector] end];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

- (void)loadBattleScene:(NSNotification *)notification
{
  NSLog(@"Battle Scene Loading...");
  [self.view setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  [UIView animateWithDuration:0.3f
                        delay:0.0f
                      options:UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.view setAlpha:1.0f];
                   }
                   completion:nil];
  
  NSLog(@"Pokemon Info: %@", notification.userInfo);
}

- (void)unloadBattleScene:(id)sender
{
  NSLog(@"Battle Scene Unloading...");
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
                                                                       userInfo:nil];
                   }];
}

@end
