//
//  PListParser.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PListParser : NSObject

// Pokedex
+ (NSArray *)pokedexInBundle:(NSBundle *)bundle;
+ (NSMutableArray *)sixPokemons:(NSMutableArray *)sixPokemonsID;
+ (NSDictionary *)pokemonInfo:(NSInteger)pokemonID;

+ (NSArray *)pokedexGenerationOneImageArray;
+ (UIImage *)pokedexGenerationOneImageForPokemon:(NSInteger)pokemonID;
+ (NSArray *)sixPokemonsImageArrayFor:(NSString *)IDSequence;

// Moves & Ability
+ (NSArray *)movesInBundle:(NSBundle *)bundle;

// Bag[Item]
+ (NSArray *)bagItemsInBundle:(NSBundle *)bundle;
+ (NSArray *)bagMedicineInBundle:(NSBundle *)bundle;
+ (NSArray *)bagPokeballsInBundle:(NSBundle *)bundle;
+ (NSArray *)bagTMsHMsInBundle:(NSBundle *)bundle;
+ (NSArray *)bagBerriesInBundle:(NSBundle *)bundle;
+ (NSArray *)bagMailInBundle:(NSBundle *)bundle;
+ (NSArray *)bagBattleItemsInBundle:(NSBundle *)bundle;
+ (NSArray *)bagKeyItemsInBundle:(NSBundle *)bundle;

// GameSettingOptions
+ (NSArray *)gameSettingOptionsInBundle:(NSBundle *)bundle;

@end
