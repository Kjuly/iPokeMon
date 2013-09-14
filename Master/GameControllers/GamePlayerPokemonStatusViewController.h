//
//  GamePokemonStatusViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GamePokemonStatusViewController.h"

@class PokemonEXPBar;

@interface GamePlayerPokemonStatusViewController : GamePokemonStatusViewController {
  PokemonEXPBar * pokemonEXPBar_;
}

@property (nonatomic, strong) PokemonEXPBar * pokemonEXPBar;

@end
