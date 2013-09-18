//
//  CenterMenuSixPokemonsViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CenterMenuSixPokemonsViewController.h"

#import "TrainerController.h"
#import "SixPokemonsDetailTabViewController.h"


@interface CenterMenuSixPokemonsViewController () {
 @private
  NSArray * sixPokemons_;
}

@property (nonatomic, copy) NSArray * sixPokemons;

@end


@implementation CenterMenuSixPokemonsViewController

@synthesize sixPokemons = sixPokemons_;

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
  self.sixPokemons = nil;
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
  self.sixPokemons = [[TrainerController sharedInstance] sixPokemons];
  
  // Implement the completion block
  // iOS4 will not call |viewWillAppear:| when the VC is a child of another VC
  if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    [self viewWillAppear:YES];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if ([self.sixPokemons count] > 0) {
    // Set Buttons' style in center menu view
    NSInteger i = -1;
    for (UIButton * button in [self.menu subviews]) {
      TrainerTamedPokemon * tamedPokemon = [self.sixPokemons objectAtIndex:++i];
      [button setBackgroundImage:[UIImage imageNamed:kPMINMainMenuButtonBackground]
                        forState:UIControlStateNormal];
      [button setImage:tamedPokemon.pokemon.imageIcon forState:UIControlStateNormal];
      tamedPokemon = nil;
    }
  }
}

#pragma mark - KYCircleMenu

// Overwrite KYCircleMenu's |-runButtonActions:|
- (void)runButtonActions:(id)sender
{
  [super runButtonActions:sender];
  
  // Load Pokemon's detail information view
  SixPokemonsDetailTabViewController * sixPokemonsDetailTabViewController;
  sixPokemonsDetailTabViewController = [SixPokemonsDetailTabViewController alloc];
  TrainerTamedPokemon * tamedPokemon = [self.sixPokemons objectAtIndex:([sender tag] - 1)];
  (void)[sixPokemonsDetailTabViewController initWithPokemon:tamedPokemon
                                                 withTopbar:YES];
  [self pushViewController:sixPokemonsDetailTabViewController];
  
  // Change |centerMainButton_|'s status
  [self changeCenterMainButtonStatusToMove:kCenterMainButtonStatusAtBottom];
}

@end
