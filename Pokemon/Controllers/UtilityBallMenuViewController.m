//
//  UtilityBallMenuViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "UtilityBallMenuViewController.h"

#import "GlobalConstants.h"
#import "GlobalRender.h"
#import "PokedexTableViewController.h"
#import "SixPokemonsTableViewController.h"
#import "BagTableViewController.h"
#import "TrainerCardViewController.h"
#import "GameSettingTableViewController.h"


@implementation UtilityBallMenuViewController

@synthesize buttonOpen = buttonOpen_;

@synthesize ballMenu              = ballMenu_;
@synthesize buttonShowPokedex     = buttonShowPokedex_;
@synthesize buttonShowPokemon     = buttonShowPokemon_;
@synthesize buttonShowBag         = buttonShowBag_;
@synthesize buttonShowTrainerCard = buttonShowTrainerCard_;
@synthesize buttonHotkey          = buttonHotkey_;
@synthesize buttonSetGame         = buttonSetGame_;
@synthesize buttonClose           = buttonClose_;

@synthesize pokedexTableViewController     = pokedexTableViewController_;
@synthesize sixPokemonsTableViewController = sixPokemonsTableViewController_;
@synthesize bagTableViewController         = bagTableViewController_;
@synthesize trainerCardViewController      = trainerCardViewController_;
@synthesize gameSettingTableViewController = gameSettingTableViewController_;

-(void)dealloc
{
  [buttonOpen_ release];
  
  [ballMenu_              release];
  [buttonShowPokedex_     release];
  [buttonShowPokemon_     release];
  [buttonShowBag_         release];
  [buttonShowTrainerCard_ release];
  [buttonHotkey_          release];
  [buttonSetGame_         release];
  [buttonClose_           release];
  
  [pokedexTableViewController_     release];
  [sixPokemonsTableViewController_ release];
  [bagTableViewController_         release];
  [trainerCardViewController_      release];
  [gameSettingTableViewController_ release];
  
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
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  self.view = view;
  [view release];
//  [self.view setBackgroundColor:[GlobalRender backgroundColorTransparentBlack]];
  
  // Ball Menu View
  UIView * ballMenu = [[UIView alloc] initWithFrame:CGRectMake((320.0f - kCenterMenuSize) / 2,
                                                              (480.0f - kCenterMenuSize) / 2,
                                                              kCenterMenuSize,
                                                              kCenterMenuSize)];
  self.ballMenu = ballMenu;
  [ballMenu release];
  
  [self.ballMenu setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewCenterCircle.png"]]];
  [self.ballMenu setOpaque:NO];
  [self.view addSubview:self.ballMenu];
  
  // Buttons in Ball Menu View
  //
  //  Triangle Values for Buttons' Position
  // 
  //      /|      a: triangleA = c * COSx 
  //   c / | b    b: triangleB = c * SINx
  //    /)x|      c: triangleHypotenuse
  //   -----      x: degree
  //     a
  //
  CGFloat degree = 60.0f * M_PI / 180.0f;
  CGFloat triangleHypotenuse = 112.0f; // Distance to Ball Center
  CGFloat triangleA = triangleHypotenuse * cosf(degree);
  CGFloat triangleB = triangleHypotenuse * sinf(degree);
  CGFloat buttonRadius = kCenterMenuButtonSize / 2.0f;
  CGFloat centerBallMenuHalfSize = kCenterMenuSize / 2.0f;
  
  {
    // Button: Show Pokedex
    //
    //   o
    //    \|/
    //   --|--
    //    /|\
    //
    buttonShowPokedex_ = [[UIButton alloc] initWithFrame:CGRectMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                                    centerBallMenuHalfSize - triangleA - buttonRadius,
                                                                    kCenterMenuButtonSize,
                                                                    kCenterMenuButtonSize)];
    [buttonShowPokedex_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                                  forState:UIControlStateNormal];
    [buttonShowPokedex_ setImage:[UIImage imageNamed:@"MainViewCenterMenuButton1.png"]
                        forState:UIControlStateNormal];
    [buttonShowPokedex_ setTag:kTagUtilityBallButtonShowPokedex];
    [buttonShowPokedex_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonShowPokedex_];
  }{
    // Button: Show Pokemon
    //
    //     o
    //    \|/
    //   --|--
    //    /|\
    //
    buttonShowPokemon_ = [[UIButton alloc] initWithFrame:CGRectMake(centerBallMenuHalfSize - buttonRadius,
                                                                    centerBallMenuHalfSize - triangleHypotenuse - buttonRadius,
                                                                    kCenterMenuButtonSize,
                                                                    kCenterMenuButtonSize)];
    [buttonShowPokemon_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                                  forState:UIControlStateNormal];
    [buttonShowPokemon_ setImage:[UIImage imageNamed:@"MainViewCenterMenuButton2.png"]
                        forState:UIControlStateNormal];
    [buttonShowPokemon_ setTag:kTagUtilityBallButtonShowPokemon];
    [buttonShowPokemon_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonShowPokemon_];
  }{
    // Button: Show Bag
    //
    //       o
    //    \|/
    //   --|--
    //    /|\
    //
    buttonShowBag_ = [[UIButton alloc] initWithFrame:CGRectMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                                centerBallMenuHalfSize - triangleA - buttonRadius,
                                                                kCenterMenuButtonSize,
                                                                kCenterMenuButtonSize)];
    [buttonShowBag_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                              forState:UIControlStateNormal];
    [buttonShowBag_ setImage:[UIImage imageNamed:@"MainViewCenterMenuButton3.png"]
                    forState:UIControlStateNormal];
    [buttonShowBag_ setTag:kTagUtilityBallButtonShowBag];
    [buttonShowBag_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonShowBag_];
  }{
    // Button: Show Trainer Card
    //
    //    \|/
    //   --|--
    //    /|\
    //   o
    //
    buttonShowTrainerCard_ = [[UIButton alloc] initWithFrame:CGRectMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                                        centerBallMenuHalfSize + triangleA - buttonRadius,
                                                                        kCenterMenuButtonSize,
                                                                        kCenterMenuButtonSize)];
    [buttonShowTrainerCard_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                                      forState:UIControlStateNormal];
    [buttonShowTrainerCard_ setImage:[UIImage imageNamed:@"MainViewCenterMenuButton4.png"]
                            forState:UIControlStateNormal];
    [buttonShowTrainerCard_ setTag:kTagUtilityBallButtonShowTrainerCard];
    [buttonShowTrainerCard_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonShowTrainerCard_];
  }{
    // Button: Hot Key
    //
    //    \|/
    //   --|--
    //    /|\
    //     o
    //
    buttonHotkey_ = [[UIButton alloc] initWithFrame:CGRectMake(centerBallMenuHalfSize - buttonRadius,
                                                               centerBallMenuHalfSize + triangleHypotenuse - buttonRadius,
                                                               kCenterMenuButtonSize,
                                                               kCenterMenuButtonSize)];
    [buttonHotkey_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                             forState:UIControlStateNormal];
    [buttonHotkey_ setImage:[UIImage imageNamed:@"MainViewCenterMenuButton5.png"]
                   forState:UIControlStateNormal];
    [buttonHotkey_ setTag:kTagUtilityBallButtonHotkey];
    [buttonHotkey_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonHotkey_];
  }{
    // Button: Set Game
    //
    //    \|/
    //   --|--
    //    /|\
    //       o
    //
    buttonSetGame_ = [[UIButton alloc] initWithFrame:CGRectMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                                centerBallMenuHalfSize + triangleA - buttonRadius,
                                                                kCenterMenuButtonSize,
                                                                kCenterMenuButtonSize)];
    [buttonSetGame_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                              forState:UIControlStateNormal];
    [buttonSetGame_ setImage:[UIImage imageNamed:@"MainViewCenterMenuButton6.png"]
                    forState:UIControlStateNormal];
    [buttonSetGame_ setTag:kTagUtilityBallButtonSetGame];
    [buttonSetGame_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonSetGame_];
  }{
    // Button: Close
    //
    //    \|/
    //   - o -
    //    /|\
    //
    buttonClose_ = [[UIButton alloc] initWithFrame:CGRectMake(centerBallMenuHalfSize - buttonRadius,
                                                              centerBallMenuHalfSize - buttonRadius,
                                                              kCenterMenuButtonSize,
                                                              kCenterMenuButtonSize)];
    [buttonClose_ setBackgroundImage:[UIImage imageNamed:@"MainViewCenterMenuButtonBackground.png"]
                                  forState:UIControlStateNormal];
    [buttonClose_ setTag:kTagUtilityBallButtonClose];
    [buttonClose_ addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.ballMenu addSubview:buttonClose_];
  }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.buttonOpen = nil;
  
  self.ballMenu               = nil;
  self.buttonShowPokedex      = nil;
  self.buttonShowPokemon      = nil;
  self.buttonShowBag          = nil;
  self.buttonShowTrainerCard  = nil;
  self.buttonHotkey           = nil;
  self.buttonSetGame          = nil;
  self.buttonClose            = nil;
  
  self.pokedexTableViewController     = nil;
  self.sixPokemonsTableViewController = nil;
  self.bagTableViewController         = nil;
  self.trainerCardViewController      = nil;
  self.gameSettingTableViewController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Hide custom |navigationBar|
  if (! self.navigationController.isNavigationBarHidden)
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button Action

- (void)runButtonActions:(id)sender
{
  switch ([(UIButton *)sender tag]) {
    case kTagUtilityBallButtonShowPokedex:
      [self showPokedex:sender];
      break;
      
    case kTagUtilityBallButtonShowPokemon:
      [self showPokemon:sender];
      break;
      
    case kTagUtilityBallButtonShowBag:
      [self showBag:sender];
      break;
      
    case kTagUtilityBallButtonShowTrainerCard:
      [self showTrainerCard:sender];
      break;
      
    case kTagUtilityBallButtonHotkey:
      [self runHotkey:sender];
      break;
      
    case kTagUtilityBallButtonSetGame:
      [self setGame:sender];
      break;
      
    case kTagUtilityBallButtonClose:
      [self closeView:sender];
      break;
      
    default:
      break;
  }
}

- (void)showPokedex:(id)sender {  
  if (! self.pokedexTableViewController)
    pokedexTableViewController_ = [[PokedexTableViewController alloc] initWithStyle:UITableViewStylePlain];
  [self.navigationController pushViewController:self.pokedexTableViewController animated:YES];
}

- (void)showPokemon:(id)sender {
  if (! self.sixPokemonsTableViewController)
    sixPokemonsTableViewController_ = [[SixPokemonsTableViewController alloc] initWithStyle:UITableViewStylePlain];
  [self.navigationController pushViewController:self.sixPokemonsTableViewController animated:YES];
}

- (void)showBag:(id)sender {
  if (! self.bagTableViewController)
    bagTableViewController_ = [[BagTableViewController alloc] initWithStyle:UITableViewStylePlain];
  [self.navigationController pushViewController:self.bagTableViewController animated:YES];
}

- (void)showTrainerCard:(id)sender {
  if (! self.trainerCardViewController)
    trainerCardViewController_ = [[TrainerCardViewController alloc] init];
  [self.navigationController pushViewController:self.trainerCardViewController animated:YES];
}

- (void)runHotkey:(id)sender {
  NSLog(@"--- Button Clicked: runHotKey");
}

- (void)setGame:(id)sender {
  if (! self.gameSettingTableViewController)
    gameSettingTableViewController_ = [[GameSettingTableViewController alloc] init];
  [self.navigationController pushViewController:self.gameSettingTableViewController animated:YES];
}

- (void)closeView:(id)sender {
  [self.navigationController.view removeFromSuperview];
}

@end
