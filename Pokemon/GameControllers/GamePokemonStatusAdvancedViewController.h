//
//  GamePokemonStatusViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GamePokemonStatusViewController.h"

@class PokemonEXPBar;

@interface GamePokemonStatusAdvancedViewController : GamePokemonStatusViewController {
  PokemonEXPBar * pokemonEXPBar_;
}

@property (nonatomic, retain) PokemonEXPBar * pokemonEXPBar;

@end
