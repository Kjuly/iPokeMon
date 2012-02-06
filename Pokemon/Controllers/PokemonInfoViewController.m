//
//  PokemonInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonInfoViewController.h"

#import "PListParser.h"

@implementation PokemonInfoViewController

@synthesize pokemonID = pokemonID_;
@synthesize pokemonInfoDict = pokemonInfoDict_;

- (void)dealloc
{
  [pokemonInfoDict_ release];
  
  [super dealloc];
}

- (id)initWithPokemonID:(NSInteger)pokemonID
{
  self = [self init];
  if (self) {
    self.pokemonID       = pokemonID;
    self.pokemonInfoDict = [PListParser pokemonInfo:pokemonID];
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
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
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  self.view = view;
  [view release];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  // Set Pokemon Photo
  UIImageView * pokemonPhotoView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 180.0f)];
  [pokemonPhotoView setUserInteractionEnabled:YES];
  [pokemonPhotoView setContentMode:UIViewContentModeCenter];
  [pokemonPhotoView setImage:[PListParser pokedexGenerationOneImageForPokemon:self.pokemonID]];
  [self.view addSubview:pokemonPhotoView];
  [pokemonPhotoView release];
  
  // Set Pokemon Name & ID Labels
  UILabel * pokemonNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 60.0f, 200.0f, 60.0f)];
  [pokemonNameLabel setText:[self.pokemonInfoDict objectForKey:@"name"]];
  [self.view addSubview:pokemonNameLabel];
  [pokemonNameLabel release];
  
  UILabel * pokemonIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 120.0f, 200.0f, 60.0f)];
  [pokemonIDLabel setText:[NSString stringWithFormat:@"#%.3d", self.pokemonID + 1]];
  [self.view addSubview:pokemonIDLabel];
  [pokemonIDLabel release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.pokemonInfoDict = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
