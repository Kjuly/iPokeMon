//
//  MainViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MainViewController.h"

#import "../GlobalConstants.h"
#import "MapViewController.h"
#import "UtilityViewController.h"
#import "PoketchTabViewController.h"
#import "CustomNavigationController.h"
#import "UtilityBallMenuViewController.h"

@implementation MainViewController

@synthesize mapViewController     = mapViewController_;
@synthesize utilityViewController = utilityViewController_;
@synthesize poketchViewController = poketchViewController_;

@synthesize buttonOpenBallMenu            = buttonOpenBallMenu_;
@synthesize utilityNavigationController   = utilityNavigationController_;

- (void)dealloc
{
  [mapViewController_ release];
  [utilityViewController_ release];
  [poketchViewController_ release];
  
  [buttonOpenBallMenu_ release];
  [utilityNavigationController_ release];
  
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
  
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  self.view = view;
  [view release];
  
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
  [self.view addSubview:self.utilityViewController.view];
  
  // Ball menu which locate at center
  UIButton * buttonOpenBallMenu = [[UIButton alloc] initWithFrame:CGRectMake(kUtilityButtonWidth * 3, kMapViewHeight, 104.0f, kUtilityBarHeight)];
  self.buttonOpenBallMenu = buttonOpenBallMenu;
  [buttonOpenBallMenu release];
  [self.buttonOpenBallMenu setImage:[UIImage imageNamed:@"UtilityBallMenuIconSmall.png"] forState:UIControlStateNormal];
  [self.buttonOpenBallMenu addTarget:self action:@selector(openBallMenuView:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.buttonOpenBallMenu];
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
    UtilityBallMenuViewController * utilityBallMenuViewController = [[UtilityBallMenuViewController alloc] init];
    CustomNavigationController * utilityNavigationController = [[CustomNavigationController alloc]
                                                                initWithRootViewController:utilityBallMenuViewController];
    [utilityBallMenuViewController release];
    self.utilityNavigationController = utilityNavigationController;
    [utilityNavigationController release];
  }
  
  [self.view addSubview:self.utilityNavigationController.view];
}

@end
