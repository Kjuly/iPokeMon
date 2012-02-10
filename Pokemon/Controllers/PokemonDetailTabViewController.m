//
//  PokemonDetailTabViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonDetailTabViewController.h"

#import "PokemonInfoViewController.h"
#import "PokemonAreaViewController.h"
#import "PokemonSizeViewController.h"


@implementation PokemonDetailTabViewController

- (void)dealloc
{
  [super dealloc];
}

- (id)initWithPokemonID:(NSInteger)pokemonID
{
  self = [super init];
  if (self) {
    // Set View Frame
    self.viewFrame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    
    // Add child view controllers to each tab
    PokemonInfoViewController * pokemonInfoViewController = [[PokemonInfoViewController alloc] initWithPokemonID:pokemonID];
    PokemonAreaViewController * pokemonAreaViewController = [[PokemonAreaViewController alloc] initWithPokemonID:pokemonID];
    PokemonSizeViewController * pokemonSizeViewController = [[PokemonSizeViewController alloc] initWithPokemonID:pokemonID];
    
    self.tabBarItems = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Info.png", @"image", pokemonInfoViewController, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Area.png", @"image", pokemonAreaViewController, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Size.png", @"image", pokemonSizeViewController, @"viewController", nil],
                        nil];
    
    [pokemonInfoViewController release];
    [pokemonAreaViewController release];
    [pokemonSizeViewController release];
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)loadView
{
  [super loadView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

@end
