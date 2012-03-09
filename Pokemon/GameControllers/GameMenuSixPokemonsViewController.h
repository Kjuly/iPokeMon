//
//  GameMenuSixPokemonViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameMenuSixPokemonsUnitView.h"

@interface GameMenuSixPokemonsViewController : UIViewController <GameMenuSixPokemonsUnitViewDelegate>

- (void)initWithPokemonCount:(NSInteger)pokemonCount;
- (void)loadSixPokemons;
- (void)unloadSixPokemons;

@end
