//
//  GameWildPokemon.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameAbstractPokemon.h"

@interface GameWildPokemon : GameAbstractPokemon {
    
}

- (id)initWithPokemonID:(NSInteger)pokemonID keyName:(NSString *)keyName;
- (void)update:(ccTime)dt;

// Wild Pokemon's Move Attack
- (void)attack;

@end
