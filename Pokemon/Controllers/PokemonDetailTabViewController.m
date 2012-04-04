//
//  PokemonDetailTabViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonDetailTabViewController.h"

#import "GlobalConstants.h"
#import "Pokemon+DataController.h"
#import "PokemonInfoViewController.h"
#import "PokemonAreaViewController.h"
#import "PokemonSizeViewController.h"


@implementation PokemonDetailTabViewController

@synthesize pokemonDataDict = pokemonDataDict_;

- (void)dealloc
{
  [super dealloc];
  
  [pokemonDataDict_ release];
}

- (id)initWithPokemonID:(NSInteger)pokemonID withTopbar:(BOOL)withTopbar {
  self = [super init];
  if (self) {
    // Set View Frame
    self.viewFrame = CGRectMake(0.f, 0.f, kViewWidth, kViewHeight);
    
    self.pokemonDataDict = [Pokemon queryPokemonDataWithID:pokemonID];
    
    // Add child view controllers to each tab
    PokemonInfoViewController * pokemonInfoViewController = [[PokemonInfoViewController alloc]
                                                             initWithPokemonDataDict:self.pokemonDataDict];
    PokemonAreaViewController * pokemonAreaViewController = [[PokemonAreaViewController alloc] initWithPokemonID:pokemonID];
    PokemonSizeViewController * pokemonSizeViewController = [[PokemonSizeViewController alloc]
                                                             initWithPokemonDataDict:self.pokemonDataDict];
    
    // Set child views' Frame
    CGFloat marginTop = withTopbar ? kTopBarHeight : 0.f;
    CGRect childViewFrame = CGRectMake(0.f, marginTop, kViewWidth, kViewHeight - marginTop);
    [pokemonInfoViewController.view setFrame:childViewFrame];
    [pokemonAreaViewController.view setFrame:childViewFrame];
    [pokemonSizeViewController.view setFrame:childViewFrame];
    
    // Add child views as tab bar items
    self.tabBarItems = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Info.png", @"image", pokemonInfoViewController, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Area.png", @"image", pokemonAreaViewController, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PokemonDetail_Size.png", @"image", pokemonSizeViewController, @"viewController", nil],
                        nil];
    
    // Release child view controllers
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
  
  self.pokemonDataDict = nil;
}

@end
