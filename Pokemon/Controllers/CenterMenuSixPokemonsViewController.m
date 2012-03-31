//
//  CenterMenuSixPokemonsViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CenterMenuSixPokemonsViewController.h"

#import "GlobalNotificationConstants.h"
#import "TrainerCoreDataController.h"
#import "SixPokemonsDetailTabViewController.h"


@interface CenterMenuSixPokemonsViewController () {
 @private
  NSArray * sixPokemons_;
}

@property (nonatomic, copy) NSArray * sixPokemons;

@end


@implementation CenterMenuSixPokemonsViewController

@synthesize sixPokemons = sixPokemons_;

- (void)dealloc
{
  [sixPokemons_ release];
  
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
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.sixPokemons = [[TrainerCoreDataController sharedInstance] sixPokemons];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.sixPokemons = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if ([self.sixPokemons count] > 0) {
    // Set Buttons' style in center menu view
    NSInteger i = -1;
    for (UIButton * button in [self.centerMenu subviews]) {
      TrainerTamedPokemon * pokemonData = [self.sixPokemons objectAtIndex:++i];
      Pokemon * pokemonBaseInfo = pokemonData.pokemon;
      //
      // TODO:
      //   Replace |image| to |imageIcon|
      //
      [button setImage:pokemonBaseInfo.imageIcon forState:UIControlStateNormal];
    }
  }
}

#pragma mark - Button Action

// Button actions, declared in parent VC
- (void)runButtonActions:(id)sender
{
  [super runButtonActions:sender];
  
  // Load Pokemon's detail information view
  SixPokemonsDetailTabViewController * sixPokemonsDetailTabViewController =
    [[SixPokemonsDetailTabViewController alloc] initWithPokemon:
      [self.sixPokemons objectAtIndex:((UIButton *)sender).tag - 1]];
  [self pushViewController:sixPokemonsDetailTabViewController];
  [sixPokemonsDetailTabViewController release];
  
  // Change |centerMainButton_|'s status
  [self changeCenterMainButtonStatusToMove:kCenterMainButtonStatusAtBottom];
}

@end
