//
//  UtilityBallMenuViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CenterMenuUtilityViewController.h"

#import "PokedexTableViewController.h"
#import "SixPokemonsTableViewController.h"
#import "BagTableViewController.h"
#import "TrainerCardViewController.h"
#import "StoreTableViewController.h"
#import "SettingTableViewController.h"


@interface CenterMenuUtilityViewController ()

// Buttons' Action
- (void)_showPokedex:(id)sender;
- (void)_showPokemon:(id)sender;
- (void)_showBag:(id)sender;
- (void)_showTrainerCard:(id)sender;
- (void)_runHotkey:(id)sender;
- (void)_setGame:(id)sender;

@end


@implementation CenterMenuUtilityViewController

@synthesize managedObjectContext;

-(void)dealloc {
  self.managedObjectContext = nil;
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  [super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Set Buttons' style in center menu view
  for (UIButton * button in [self.centerMenu subviews]) {
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:kPMINMainMenuUtilityButton, button.tag]]
            forState:UIControlStateNormal];
    [button setAlpha:.95f];
  }
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

#pragma mark - Button Action

- (void)runButtonActions:(id)sender {
  [super runButtonActions:sender];
  
  // Change |centerMainButton_|'s status
  [self changeCenterMainButtonStatusToMove:kCenterMainButtonStatusAtBottom];
  
  NSInteger buttonTag = ((UIButton *)sender).tag;
  switch (buttonTag) {
    case 1://kTagUtilityBallButtonShowPokedex:
      [self _showPokedex:sender];
      break;
      
    case 2://kTagUtilityBallButtonShowPokemon:
      [self _showPokemon:sender];
      break;
      
    case 3://kTagUtilityBallButtonShowBag:
      [self _showBag:sender];
      break;
      
    case 4://kTagUtilityBallButtonShowTrainerCard:
      [self _showTrainerCard:sender];
      break;
      
    case 5://kTagUtilityBallButtonHotkey:
      [self _runHotkey:sender];
      break;
      
    case 6://kTagUtilityBallButtonSetGame:
      [self _setGame:sender];
      break;
      
    default:
      break;
  }
}

#pragma mark - Private Methods

///Buttons' Action
- (void)_showPokedex:(id)sender {  
  PokedexTableViewController * pokedexTableViewController = [PokedexTableViewController alloc];
  [pokedexTableViewController initWithStyle:UITableViewStylePlain];
  [self pushViewController:pokedexTableViewController];
  [pokedexTableViewController release];
}

- (void)_showPokemon:(id)sender {
  SixPokemonsTableViewController * sixPokemonsTableViewController = [SixPokemonsTableViewController alloc];
  [sixPokemonsTableViewController initWithStyle:UITableViewStylePlain];
  [self pushViewController:sixPokemonsTableViewController];
  [sixPokemonsTableViewController release];
}

- (void)_showBag:(id)sender {
  BagTableViewController * bagTableViewController = [BagTableViewController alloc];
  [bagTableViewController initWithStyle:UITableViewStylePlain];
  [self pushViewController:bagTableViewController];
  [bagTableViewController release];
}

- (void)_showTrainerCard:(id)sender {
  TrainerCardViewController * trainerCardViewController = [[TrainerCardViewController alloc] init];
  [self pushViewController:trainerCardViewController];
  [trainerCardViewController release];
}

- (void)_runHotkey:(id)sender {
  StoreTableViewController * storeTableViewController;
  storeTableViewController = [[StoreTableViewController alloc] initWithStyle:UITableViewStylePlain];
  [self pushViewController:storeTableViewController];
  [storeTableViewController release];
}

- (void)_setGame:(id)sender {
  SettingTableViewController * settingTableViewController = [[SettingTableViewController alloc] init];
  settingTableViewController.managedObjectContext = self.managedObjectContext;
  [self pushViewController:settingTableViewController];
  [settingTableViewController release];
}

@end
