//
//  GameEnemyPokemonStatusViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameEnemyPokemonStatusViewController.h"

#import "GameSystemProcess.h"
#import "WildPokemon.h"


@implementation GameEnemyPokemonStatusViewController

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView {
//  [super loadView];
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
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
  
  if ([statusInfo objectForKey:@"enemyPokemonHP"]) {
    [self.pokemonHPBar updateHPBarWithHP:
      [[statusInfo objectForKey:@"enemyPokemonHP"] intValue]];
  }
}

- (void)prepareForNewScene
{
  WildPokemon * enemyPokemon = [GameSystemProcess sharedInstance].enemyPokemon;
  [pokemonName_ setText:KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d",
                                                    [enemyPokemon.sid intValue]]), nil)];
  [pokemonGender_ setImage:
    [UIImage imageNamed:[NSString stringWithFormat:kPMINIconPMGender, [enemyPokemon.gender intValue]]]];
  [pokemonLevel_ setText:[NSString stringWithFormat:@"Lv.%d", [enemyPokemon.level intValue]]];
  [self.pokemonHPBar updateHPBarWithHP:[enemyPokemon.hp intValue]
                                 HPMax:[[[enemyPokemon.maxStats componentsSeparatedByString:@","]
                                         objectAtIndex:0] intValue]];
}

@end
