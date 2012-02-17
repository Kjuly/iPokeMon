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

// Pokedex
+ (NSArray *)queryAllData;

// Six Pokemons

@end
