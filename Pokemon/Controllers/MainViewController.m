//
//  MainViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MainViewController.h"

#import "GlobalConstants.h"
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

@implementation MainViewController

@synthesize mapViewController     = mapViewController_;
@synthesize utilityViewController = utilityViewController_;
@synthesize poketchViewController = poketchViewController_;

@synthesize buttonOpenBallMenu            = buttonOpenBallMenu_;
@synthesize utilityNavigationController   = utilityNavigationController_;

@synthesize gameMainViewController = gameMainViewController_;

- (void)dealloc
{
  [mapViewController_ release];
  [utilityViewController_ release];
  [poketchViewController_ release];
  
  [buttonOpenBallMenu_ release];
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
  
  // Set Background Color
//  [self.view setBackgroundColor:[GlobalColor backgroundColorMain]];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  // Map View Controller
  MapViewController * mapViewController = [[MapViewController alloc] init];
  self.mapViewController = mapViewController;
  [mapViewController release];
  [self.view addSubview:self.mapViewController.view];
  
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
  
  // Ball menu which locate at center
  UIButton * buttonOpenBallMenu = [[UIButton alloc] initWithFrame:CGRectMake((320.0f - kUtilityBarHeight) / 2,
                                                                             kMapViewHeight,
                                                                             kUtilityBarHeight,
                                                                             kUtilityBarHeight)];
  self.buttonOpenBallMenu = buttonOpenBallMenu;
  [buttonOpenBallMenu release];
  [self.buttonOpenBallMenu setContentMode:UIViewContentModeScaleAspectFit];
  [self.buttonOpenBallMenu setBackgroundImage:[UIImage imageNamed:@"UtilityBallMenuIcon.png"]
                                     forState:UIControlStateNormal];
  [self.buttonOpenBallMenu addTarget:self action:@selector(openBallMenuView:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.buttonOpenBallMenu];
  
  // Game Main View
//  gameMainViewController_ = [[GameMainViewController alloc] init];
//  [self.view addSubview:gameMainViewController_.view];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.mapViewController = nil;
  self.utilityViewController = nil;
  self.poketchViewController = nil;
  
  self.buttonOpenBallMenu            = nil;
  self.utilityNavigationController   = nil;
  
  self.gameMainViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button Action

- (void)openBallMenuView:(id)sender
{
  if (! self.utilityNavigationController) {
    NSLog(@"--- MainViewController openBallMenuView if(!): Create new CustomNavigationController ---");    
    UtilityBallMenuViewController * utilityBallMenuViewController = [[UtilityBallMenuViewController alloc] init];
    utilityNavigationController_ = [CustomNavigationController initWithRootViewController:utilityBallMenuViewController
                                                             navigationBarBackgroundImage:[UIImage imageNamed:@"NavigationBarBackgroundBlue.png"]];
    [utilityBallMenuViewController release];
  }
  [self.view addSubview:self.utilityNavigationController.view];
}

@end
