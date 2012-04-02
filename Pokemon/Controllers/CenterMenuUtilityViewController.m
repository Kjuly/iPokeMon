//
//  UtilityBallMenuViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CenterMenuUtilityViewController.h"

#import "GlobalNotificationConstants.h"
#import "PokedexTableViewController.h"
#import "SixPokemonsTableViewController.h"
#import "BagTableViewController.h"
#import "TrainerInfoViewController.h"
#import "SettingTableViewController.h"


@interface CenterMenuUtilityViewController () {
 @private
  PokedexTableViewController     * pokedexTableViewController_;
  SixPokemonsTableViewController * sixPokemonsTableViewController_;
  BagTableViewController         * bagTableViewController_;
  TrainerInfoViewController      * trainerInfoViewController_;
  SettingTableViewController     * settingTableViewController_;
}

@property (nonatomic, retain) PokedexTableViewController     * pokedexTableViewController;
@property (nonatomic, retain) SixPokemonsTableViewController * sixPokemonsTableViewController;
@property (nonatomic, retain) BagTableViewController         * bagTableViewController;
@property (nonatomic, retain) TrainerInfoViewController      * trainerInfoViewController;
@property (nonatomic, retain) SettingTableViewController     * settingTableViewController;

// Buttons' Action
- (void)showPokedex:(id)sender;
- (void)showPokemon:(id)sender;
- (void)showBag:(id)sender;
- (void)showTrainerCard:(id)sender;
- (void)runHotkey:(id)sender;
- (void)setGame:(id)sender;

@end


@implementation CenterMenuUtilityViewController

@synthesize pokedexTableViewController     = pokedexTableViewController_;
@synthesize sixPokemonsTableViewController = sixPokemonsTableViewController_;
@synthesize bagTableViewController         = bagTableViewController_;
@synthesize trainerInfoViewController      = trainerInfoViewController_;
@synthesize settingTableViewController     = settingTableViewController_;

-(void)dealloc
{ 
  [pokedexTableViewController_     release];
  [sixPokemonsTableViewController_ release];
  [bagTableViewController_         release];
  [trainerInfoViewController_      release];
  [settingTableViewController_     release];
  
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
  
  // Set Buttons' style in center menu view
  for (UIButton * button in [self.centerMenu subviews])
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MainViewCenterMenuButton%d", button.tag]]
            forState:UIControlStateNormal];
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
  self.trainerInfoViewController      = nil;
  self.settingTableViewController     = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

#pragma mark - Button Action

- (void)runButtonActions:(id)sender
{
  [super runButtonActions:sender];
  
  NSInteger buttonTag = ((UIButton *)sender).tag;
  
  if (buttonTag != 5)
    // Change |centerMainButton_|'s status
    [self changeCenterMainButtonStatusToMove:kCenterMainButtonStatusAtBottom];
  
  switch (buttonTag) {
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

#pragma mark - Private Methods

//
// Buttons' Action
//
- (void)showPokedex:(id)sender {  
  if (self.pokedexTableViewController == nil)
    pokedexTableViewController_ = [[PokedexTableViewController alloc] initWithStyle:UITableViewStylePlain];
  [self pushViewController:self.pokedexTableViewController];
}

- (void)showPokemon:(id)sender {
  if (self.sixPokemonsTableViewController == nil)
    sixPokemonsTableViewController_ = [[SixPokemonsTableViewController alloc] initWithStyle:UITableViewStylePlain];
  [self pushViewController:self.sixPokemonsTableViewController];
}

- (void)showBag:(id)sender {
  if (! self.bagTableViewController)
    bagTableViewController_ = [[BagTableViewController alloc] initWithStyle:UITableViewStylePlain];
  [self pushViewController:self.bagTableViewController];
}

- (void)showTrainerCard:(id)sender {
  if (self.trainerInfoViewController == nil)
    trainerInfoViewController_ = [[TrainerInfoViewController alloc] initWithNibName:nil bundle:nil];
  [trainerInfoViewController_.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  [self pushViewController:self.trainerInfoViewController];
}

- (void)runHotkey:(id)sender {
  NSLog(@"--- Button Clicked: runHotKey");
}

- (void)setGame:(id)sender {
  if (self.settingTableViewController == nil)
    settingTableViewController_ = [[SettingTableViewController alloc] init];
  [self pushViewController:self.settingTableViewController];
}

@end
