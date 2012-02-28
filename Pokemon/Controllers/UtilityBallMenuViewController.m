//
//  UtilityBallMenuViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "UtilityBallMenuViewController.h"

#import "GlobalConstants.h"
#import "GlobalNotificationConstants.h"
#import "GlobalRender.h"
#import "PokedexTableViewController.h"
#import "SixPokemonsTableViewController.h"
#import "BagTableViewController.h"
#import "TrainerCardViewController.h"
#import "GameSettingTableViewController.h"


@implementation UtilityBallMenuViewController

@synthesize pokedexTableViewController     = pokedexTableViewController_;
@synthesize sixPokemonsTableViewController = sixPokemonsTableViewController_;
@synthesize bagTableViewController         = bagTableViewController_;
@synthesize trainerCardViewController      = trainerCardViewController_;
@synthesize gameSettingTableViewController = gameSettingTableViewController_;

-(void)dealloc
{ 
  [pokedexTableViewController_     release];
  [sixPokemonsTableViewController_ release];
  [bagTableViewController_         release];
  [trainerCardViewController_      release];
  [gameSettingTableViewController_ release];
  
  [super dealloc];
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
  
  [self.ballMenu setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewCenterCircle.png"]]];
  [self.ballMenu setOpaque:NO];
  [self.view addSubview:self.ballMenu];
  
  // Buttons in Ball Menu View
  //
  for (UIButton * button in [self.ballMenu subviews])
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MainViewCenterMenuButton%d", button.tag]]
            forState:UIControlStateNormal];
  
  // Button: Show Pokedex
  //
  //   o
  //    \|/
  //   --|--
  //    /|\
  //
  // Button: Show Pokemon
  //
  //     o
  //    \|/
  //   --|--
  //    /|\
  //
  // Button: Show Bag
  //
  //       o
  //    \|/
  //   --|--
  //    /|\
  //
  // Button: Show Trainer Card
  //
  //    \|/
  //   --|--
  //    /|\
  //   o
  //
  // Button: Hot Key
  //
  //    \|/
  //   --|--
  //    /|\
  //     o
  //
  // Button: Set Game
  //
  //    \|/
  //   --|--
  //    /|\
  //       o
  //
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
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

#pragma mark - Button Action

- (void)runButtonActions:(id)sender
{
  [super runButtonActions:sender];
  
  switch ([(UIButton *)sender tag]) {
    case 1://kTagUtilityBallButtonShowPokedex:
      [self showPokedex:sender];
      break;
      
    case 2://kTagUtilityBallButtonShowPokemon:
      [self showPokemon:sender];
      break;
      
    case 3://kTagUtilityBallButtonShowBag:
      [self showBag:sender];
      break;
      
    case 4://kTagUtilityBallButtonShowTrainerCard:
      [self showTrainerCard:sender];
      break;
      
    case 5://kTagUtilityBallButtonHotkey:
      [self runHotkey:sender];
      break;
      
    case 6://kTagUtilityBallButtonSetGame:
      [self setGame:sender];
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

@end
