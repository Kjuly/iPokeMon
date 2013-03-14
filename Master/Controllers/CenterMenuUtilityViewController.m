//
//  CenterMenuUtilityViewController.m
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

#ifdef KY_INVITATION_ONLY
- (BOOL)_isLocationServiceLocked;
#endif

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
#ifdef KY_INVITATION_ONLY
@synthesize unlockCodeManager;
#endif

-(void)dealloc {
  self.managedObjectContext = nil;
#ifdef KY_INVITATION_ONLY
  self.unlockCodeManager = nil;
#endif
  [super dealloc];
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
  for (UIButton * button in [self.menu subviews])
    [button setAlpha:.95f];
}

#pragma mark - Private Methods

#ifdef KY_INVITATION_ONLY
// Return whether the "Location Service" is locked
- (BOOL)_isLocationServiceLocked {
  if (! [self.unlockCodeManager isLockedOnFeature:nil])
    return NO;
  // Post notifi to |MainViewController| to show code input view
  [[NSNotificationCenter defaultCenter] postNotificationName:kKYUnlockCodeManagerNShowCodeInputView
                                                      object:nil];
  return YES;
}
#endif

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

#pragma mark - KYCircleMenu

// Overwrite KYCircleMenu's |-runButtonActions:|
- (void)runButtonActions:(id)sender {
  NSInteger buttonTag = [sender tag];
  
#ifdef KY_INVITATION_ONLY
  // Check whether "Location Service" is locked for Dex & SixPMs buttons
  if (buttonTag == 1 || buttonTag == 2)
    if ([self _isLocationServiceLocked]) return;
#endif
  
  // Run action in super method
  [super runButtonActions:sender];
  
  // Change |centerMainButton_|'s status
  [self changeCenterMainButtonStatusToMove:kCenterMainButtonStatusAtBottom];
  
  // Manage action for different buttons
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

@end
