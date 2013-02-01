//
//  WildPokemonController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 4/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class WildPokemon;

@interface WildPokemonController : NSObject

+ (WildPokemonController *)sharedInstance;

- (void)listen;
- (void)addWildPokemonsWithSIDs:(NSArray *)pokemonSIDs;
- (NSArray *)pokemonsAddedWithSIDs:(NSArray *)pokemonSIDs;
- (WildPokemon *)appearedPokemon;

@end
