//
//  GamePokemonStatusViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GamePlayerPokemonStatusViewController.h"

#import "GlobalRender.h"
#import "GameSystemProcess.h"
#import "TrainerTamedPokemon.h"
#import "PokemonHPBar.h"
#import "PokemonEXPBar.h"


@interface GamePlayerPokemonStatusViewController () {
 @private
  UILabel  * pokemonHP_;
  BOOL       isStatusBarOpening_;
}

@property (nonatomic, retain) UILabel  * pokemonHP;
@property (nonatomic, assign) BOOL       isStatusBarOpening;

- (void)toggleStatusBar;

@end


@implementation GamePlayerPokemonStatusViewController

@synthesize pokemonEXPBar      = pokemonEXPBar_;
@synthesize pokemonHP          = pokemonHP_;
@synthesize isStatusBarOpening = isStatusBarOpening_;

- (void)dealloc
{
  [pokemonEXPBar_     release];
  [pokemonHP_         release];
  
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
  [super loadView];
  
  // Constants
  CGRect pokemonHPBarFrame   = CGRectMake(0.f, 0.f, 320.f, 8.f);
  CGRect pokemonHPFrame      = CGRectMake(250.f, 22.f, 70.f, 20.f);
  CGRect pokemonEXPBarFrame  = CGRectMake(0.f, 58.f, 320.f, 6.f);
  
  // Reset HPBar's frame
  [pokemonHPBar_ setFrame:pokemonHPBarFrame];
  
  // Add HP
  pokemonHP_ = [[UILabel alloc] initWithFrame:pokemonHPFrame];
  [pokemonHP_ setBackgroundColor:[UIColor clearColor]];
  [pokemonHP_ setTextColor:[UIColor blackColor]];
  [pokemonHP_ setFont:[GlobalRender textFontBoldInSizeOf:14.f]];
  [self.view addSubview:pokemonHP_];
  
  // Add Exp Bar
  pokemonEXPBar_ = [[PokemonEXPBar alloc] initWithFrame:pokemonEXPBarFrame];
  [self.view addSubview:pokemonEXPBar_];
  
  // Add a transparent button for toggling status view
  isStatusBarOpening_ = NO;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.pokemonEXPBar     = nil;
  self.pokemonHP         = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// Parent |GamePokemonStatusViewController|
- (void)updatePokemonStatus:(NSDictionary *)statusInfo
{
  [super updatePokemonStatus:statusInfo];
  
  if ([statusInfo objectForKey:@"playerPokemonHP"])
    [self.pokemonHPBar updateHPBarWithHP:[[statusInfo objectForKey:@"playerPokemonHP"] intValue]];
  
  [self.pokemonHP setText:[NSString stringWithFormat:@"%d / %d", self.pokemonHPBar.hp, self.pokemonHPBar.hpMax]];
  
  if ([statusInfo objectForKey:@"Exp"])
    [self.pokemonEXPBar updateExpBarWithExp:[[statusInfo objectForKey:@"Exp"] intValue]];
}

- (void)prepareForNewScene
{
  TrainerTamedPokemon * playerPokemon = [GameSystemProcess sharedInstance].playerPokemon;
  [self.pokemonName setText:NSLocalizedString(([NSString stringWithFormat:@"PMSName%.3d",
                                                [playerPokemon.sid intValue]]), nil)];
  [self.pokemonGender setImage:[UIImage imageNamed:[playerPokemon.gender intValue]
                                ? @"IconPokemonGenderM.png" : @"IconPokemonGenderF.png"]];
  [self.pokemonLevel setText:[NSString stringWithFormat:@"Lv.%d", [playerPokemon.level intValue]]];
  NSInteger hp    = [playerPokemon.hp intValue];
  NSInteger hpMax = [[[playerPokemon.maxStats componentsSeparatedByString:@","] objectAtIndex:0] intValue];
  [self.pokemonHPBar updateHPBarWithHP:hp HPMax:hpMax];
  [self.pokemonHP setText:[NSString stringWithFormat:@"%d / %d", hp, hpMax]];
  //
  // TODO:
  //   Max Exp Value not got here!!
  //
  [self.pokemonEXPBar updateExpBarWithExp:[playerPokemon.hp intValue] ExpMax:20000];
}

- (void)reset {
  [super reset];
  if (self.isStatusBarOpening) [self toggleStatusBar];
}

#pragma mark - Private Methods

- (void)toggleStatusBar
{
  CGRect viewFrame = CGRectMake(0.f, 0.f, 280.f, 65.f);
  if (self.isStatusBarOpening)
    viewFrame.origin.x += 100.f;
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.view setFrame:viewFrame];
                   }
                   completion:nil];
  self.isStatusBarOpening = ! self.isStatusBarOpening;
}

@end
