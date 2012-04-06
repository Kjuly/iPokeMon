//
//  TrainerCoreData.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TrainerTamedPokemon+DataController.h"
#import "WildPokemon+DataController.h"
#import "BagDataController.h"


@interface TrainerController : NSObject

+ (TrainerController *)sharedInstance;
- (void)initTrainerWithUserID:(NSInteger)userID;
- (void)save;

// Sync data between Client & Server
- (void)sync;
- (void)syncDoneWithFlag:(DataModifyFlag)flag;

// Trainer's Data
- (NSInteger)UID;                                              // UID
- (NSString *)name;                                            // Name
- (NSInteger)money;                                            // Money
- (NSArray *)badges;                                           // Badges
- (NSDate *)timeStarted;                                       // Adventured Time Started
- (NSString *)pokedex;                                         // Pokedex
- (NSInteger)numberOfPokemonsForPokedex;                       // Number of Pokemons for Pokedex
- (NSArray *)sixPokemons;                                      // Six Pokemons
- (NSInteger)numberOfSixPokemons;                              // Number of Six Pokemons
- (NSURL *)avatarURL;                                          // Avatar URL (Gravatar)
- (TrainerTamedPokemon *)firstPokemonOfSix;                    // First of Six Pokemons
- (TrainerTamedPokemon *)pokemonOfSixAtIndex:(NSInteger)index; // Pokemon at |index| of Six Pokemons
- (NSArray *)bagItemsFor:(BagQueryTargetType)targetType;       // Bag Items

// Setting
- (void)setName:(NSString *)name; // Set trainer name
- (void)caughtNewWildPokemon:(WildPokemon *)wildPokemon memo:(NSString *)memo;
- (void)addPokemonToSixPokemonsWithPokemonUID:(NSInteger)pokemonUID;
- (void)useBagItemForType:(BagQueryTargetType)targetType withItemIndex:(NSInteger)itemIndex; // Used a bag item (with type)
- (void)addBagItemsForType:(BagQueryTargetType)targetType withItemIndex:(NSInteger)itemIndex quantity:(NSInteger)quantity;
- (void)tossBagItemsForType:(BagQueryTargetType)targetType withItemIndex:(NSInteger)itemIndex quantity:(NSInteger)quantity;

@end
