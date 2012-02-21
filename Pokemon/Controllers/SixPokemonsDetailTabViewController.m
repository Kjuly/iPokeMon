//
//  SixPokemonsDetailTabViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsDetailTabViewController.h"

#import "TrainerTamedPokemon.h"

@implementation SixPokemonsDetailTabViewController

@synthesize pokemon = pokemon_;

-(void)dealloc
{
  [pokemon_ release];
  
  [super dealloc];
}

- (id)initWithPokemon:(TrainerTamedPokemon *)pokemon
{
  self = [super init];
  if (self) {
    // Set View Frame
    self.viewFrame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    
    self.pokemon = pokemon;
    
    NSLog(@"%@", self.pokemon);
    
//    // Add child view controllers to each tab
//    PokemonInfoViewController * pokemonInfoViewController = [[PokemonInfoViewController alloc]
//                                                             initWithPokemonDataDict:self.pokemonDataDict];
//    PokemonAreaViewController * pokemonAreaViewController = [[PokemonAreaViewController alloc] initWithPokemonID:pokemonID];
//    PokemonSizeViewController * pokemonSizeViewController = [[PokemonSizeViewController alloc]
//                                                             initWithPokemonDataDict:self.pokemonDataDict];
//    
//    // Set child views' Frame
//    CGRect childViewFrame = CGRectMake(0.0f, kTopBarHeight, 320.0f, 480.0f - kTopBarHeight);
//    [pokemonInfoViewController.view setFrame:childViewFrame];
//    [pokemonAreaViewController.view setFrame:childViewFrame];
//    [pokemonSizeViewController.view setFrame:childViewFrame];
//    
//    // Add child views as tab bar items
//    self.tabBarItems = [NSArray arrayWithObjects:
//                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Info.png", @"image", pokemonInfoViewController, @"viewController", nil],
//                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Area.png", @"image", pokemonAreaViewController, @"viewController", nil],
//                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Size.png", @"image", pokemonSizeViewController, @"viewController", nil],
//                        nil];
//    
//    // Release child view controllers
//    [pokemonInfoViewController release];
//    [pokemonAreaViewController release];
//    [pokemonSizeViewController release];
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
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.pokemon = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
