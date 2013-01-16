//
//  WildPokemon+DataController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "WildPokemon.h"
#import "Move+DataController.h"

@interface WildPokemon (DataController)

+ (WildPokemon *)queryPokemonDataWithUID:(NSInteger)pokemonUID;
+ (WildPokemon *)queryPokemonDataWithSID:(NSInteger)pokemonSID;
+ (NSArray *)queryPokemonsWithUIDs:(NSArray *)pokemonUIDs fetchLimit:(NSInteger)fetchLimit;
+ (NSArray *)queryPokemonsWithSIDs:(NSArray *)pokemonSIDs fetchLimit:(NSInteger)fetchLimit;
+ (NSArray *)queryUniquePokemonsWithSIDs:(NSArray *)pokemonSIDs fetchLimit:(NSInteger)fetchLimit;

// Base data dispatch
- (NSInteger)numberOfMoves;
- (Move *)moveWithIndex:(NSInteger)index;
- (Move *)move1;
- (Move *)move2;
- (Move *)move3;
- (Move *)move4;
- (NSArray *)fourMovesPPInArray;
- (NSArray *)maxStatsInArray;

// Update data for different |level|
- (void)updateToLevel:(NSInteger)level;

@end
