//
//  WildPokemon+DataController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "WildPokemon.h"

@interface WildPokemon (DataController)

+ (BOOL)updateDataForCurrentRegion:(NSInteger)regionID;

+ (WildPokemon *)queryPokemonDataWithID:(NSInteger)pokemonID;

@end
