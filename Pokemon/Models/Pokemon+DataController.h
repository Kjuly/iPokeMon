//
//  Pokemon+DataController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Pokemon.h"

@interface Pokemon (DataController)

// Hard Initialize the DB data
+ (void)populateData;
+ (void)hardUpdateData;

// Pokemon Data Query Mthods
+ (NSArray *)queryAllData;
+ (NSDictionary *)queryPokemonDataWithID:(NSInteger)pokemonID;

// Six Pokemons

@end
