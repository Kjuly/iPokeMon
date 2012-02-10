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
    self.viewFrame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    
    // Add child view controllers to each tab
    PokemonInfoViewController * pokemonInfoViewController = [[PokemonInfoViewController alloc] initWithPokemonID:pokemonID];
    PokemonAreaViewController * pokemonAreaViewController = [[PokemonAreaViewController alloc] initWithPokemonID:pokemonID];
    PokemonSizeViewController * pokemonSizeViewController = [[PokemonSizeViewController alloc] initWithPokemonID:pokemonID];
    
    self.tabBarItems = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"Categories.png", @"image", pokemonInfoViewController, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"MyDownload.png", @"image", pokemonAreaViewController, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"WordList.png", @"image", pokemonSizeViewController, @"viewController", nil],
                        nil];
    
    [pokemonInfoViewController release];
    [pokemonAreaViewController release];
    [pokemonSizeViewController release];
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
  
//  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
//  self.view = view;
//  [view release];
//  [self.view setBackgroundColor:[UIColor clearColor]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

@end
