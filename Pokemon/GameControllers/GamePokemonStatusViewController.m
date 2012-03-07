//
//  GamePokemonStatusViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GamePokemonStatusViewController.h"

#import "GlobalRender.h"
#import "PokemonHPBar.h"
#import "PokemonEXPBar.h"


@implementation GamePokemonStatusViewController

@synthesize pokemonHPBar   = pokemonHPBar_;
@synthesize pokemonName    = pokemonName_;
@synthesize pokemonLevel   = pokemonLevel_;
@synthesize pokemonGender  = pokemonGender_;
@synthesize backgroundView = backgroundView_;

- (void)dealloc
{
  [pokemonHPBar_   release];
  [pokemonName_    release];
  [pokemonLevel_   release];
  [pokemonGender_  release];
  [backgroundView_ release];
  
  [super dealloc];
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 170.f, 60.f)];
  self.view = view;
  [view release];
  
  // Constants
  CGRect backgroundViewFrame = CGRectMake(0.f, 0.f, 180.f, 65.f);
  CGRect pokemonGenderFrame = CGRectMake(15.f, 0.f, 26.f, 26.f);
  CGRect pokemonLevelFrame  = CGRectMake(45.f, 0.f, 70.f, 32.f);
  CGRect pokemonNameFrame   = CGRectMake(20.f, 18.f, 150.f, 32.f);
  CGRect pokemonHPBarFrame  = CGRectMake(15.f, 45.f, 150.f, 13.f);
  
  // Background View
  backgroundView_ = [[UIImageView alloc] initWithFrame:backgroundViewFrame];
  [backgroundView_ setImage:[UIImage imageNamed:@"GamePokemonStatusBackground.png"]];
  [backgroundView_ setOpaque:NO];
  [backgroundView_ setUserInteractionEnabled:YES];
  [self.view addSubview:backgroundView_];
  
  // Pokemon Gender
  pokemonGender_ = [[UIImageView alloc] initWithFrame:pokemonGenderFrame];
  [pokemonGender_ setBackgroundColor:[UIColor clearColor]];
  [backgroundView_ addSubview:pokemonGender_];
  
  // Name
  pokemonName_ = [[UILabel alloc] initWithFrame:pokemonNameFrame];
  [pokemonName_ setBackgroundColor:[UIColor clearColor]];
  [pokemonName_ setTextColor:[GlobalRender textColorOrange]];
  [pokemonName_ setFont:[GlobalRender textFontBoldInSizeOf:12.f]];
  [backgroundView_ addSubview:pokemonName_];
  
  // Lv.
  pokemonLevel_ = [[UILabel alloc] initWithFrame:pokemonLevelFrame];
  [pokemonLevel_ setBackgroundColor:[UIColor clearColor]];
  [pokemonLevel_ setTextColor:[UIColor blackColor]];
  [pokemonLevel_ setFont:[GlobalRender textFontBoldInSizeOf:12.f]];
  [backgroundView_ addSubview:pokemonLevel_];
  
  // HP bar
  pokemonHPBar_ = [[PokemonHPBar alloc] initWithFrame:pokemonHPBarFrame HP:60.f HPMax:100.f];
  [backgroundView_ addSubview:pokemonHPBar_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [pokemonName_ setText:@"Pokemon Name"];
  [pokemonGender_ setImage:[UIImage imageNamed:
                            1 ? @"IconPokemonGenderM.png" : @"IconPokemonGenderF.png"]];
  [pokemonLevel_ setText:[NSString stringWithFormat:@"Lv.%d", 12]];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.pokemonHPBar   = nil;
  self.pokemonName    = nil;
  self.pokemonLevel   = nil;
  self.pokemonGender  = nil;
  self.backgroundView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// Update Pokemon's Status
- (void)updatePokemonStatus:(NSDictionary *)statusInfo
{ 
  if ([statusInfo objectForKey:@"name"])
    [self.pokemonName setText:[statusInfo objectForKey:@"name"]];
  if ([statusInfo objectForKey:@"gender"])
    [self.pokemonGender setImage:[UIImage imageNamed:[[statusInfo objectForKey:@"gender"] intValue]
                                  ? @"IconPokemonGenderM.png" : @"IconPokemonGenderF.png"]];
  if ([statusInfo objectForKey:@"level"])
    [self.pokemonLevel setText:[NSString stringWithFormat:@"Lv.%d", [[statusInfo objectForKey:@"level"] intValue]]];
  if ([statusInfo objectForKey:@"HP"])
    [self.pokemonHPBar updateHPBarWithHP:[[statusInfo objectForKey:@"HP"] intValue]];
  if ([statusInfo objectForKey:@"HPMax"])
    [self.pokemonHPBar updateHpBarWithHPMax:[[statusInfo objectForKey:@"HPMax"] intValue]];
}

@end
