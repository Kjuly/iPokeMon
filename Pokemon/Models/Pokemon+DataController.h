//
//  Pokemon+DataController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Pokemon.h"

@interface Pokemon (DataController)

+ (void)hardUpdateData;

+ (NSArray *)queryAllData;
+ (Pokemon *)queryPokemonDataWithID:(NSInteger)pokemonID;

// Six Pokemons

@end
