//
//  WildPokemon+DataController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "WildPokemon.h"
#import "Move+DataController.h"

@interface WildPokemon (DataController)

+ (WildPokemon *)queryPokemonDataWithID:(NSInteger)pokemonID;
+ (NSArray *)queryPokemonsWithID:(NSArray *)pokemonsID fetchLimit:(NSInteger)fetchLimit;

// Base data dispatch
- (Move *)moveWithIndex:(NSInteger)index;
- (Move *)move1;
- (Move *)move2;
- (Move *)move3;
- (Move *)move4;
- (NSArray *)fourMovesPP;
- (void)setFourMovesPPWith:(NSArray *)newPPArray;

@end
