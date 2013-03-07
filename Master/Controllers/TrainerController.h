//
//  TrainerCoreData.h
//  iPokeMon
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
- (void)saveWithSync:(BOOL)withSync;

// Sync data between Client & Server
- (void)sync;
- (void)addModifyFlag:(DataModifyFlag)flag;
- (void)syncDoneWithFlag:(DataModifyFlag)flag;

// Trainer's device data
- (NSString *)deviceUID;                                       // Device's UID
// Trainer's data
- (NSInteger)UID;                                              // UID
- (NSString *)name;                                            // Name
- (NSInteger)money;                                            // Money
- (NSArray *)badges;                                           // Badges
- (NSDate *)timeStarted;                                       // Adventured Time Started
- (NSString *)pokedex;                                         // Pokedex
- (NSInteger)numberOfPokemonsForPokedex;                       // Number of Pokemons for Pokedex
- (NSInteger)numberOfTamedPokemons;                            // Number of tamed Pokemons (total) (include duplicate)
- (NSArray *)sixPokemons;                                      // Six Pokemons
- (NSString *)sixPokemonsUID;                                  // Six Pokemons' UID
- (NSInteger)numberOfSixPokemons;                              // Number of Six Pokemons
- (NSURL *)avatarURL;                                          // Avatar URL (Gravatar)
- (TrainerTamedPokemon *)firstPokemonOfSix;                    // First of Six Pokemons
- (TrainerTamedPokemon *)pokemonOfSixAtIndex:(NSInteger)index; // Pokemon at |index| of Six Pokemons
- (NSInteger)battleAvailablePokemonIndex;                      // Check whether Pokemons in Six can battle, & return the first
- (NSArray *)bagItemsFor:(BagQueryTargetType)targetType;       // Bag Items

// Setting
- (void)setName:(NSString *)name; // Set trainer name
- (void)earnMoney:(NSInteger)money; // earn money when WIN from another trainer or exchange between currency
- (void)consumeMoney:(NSInteger)money; // consume money when LOSE or buy items in Store
- (void)updatePokedexWithPokemonSID:(NSInteger)pokemonSID;
- (void)caughtNewWildPokemon:(WildPokemon *)wildPokemon memo:(NSString *)memo;
- (void)addPokemonToSixPokemonsWithPokemonUID:(NSInteger)pokemonUID;
- (void)replacePokemonAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex; // Replace Pokemon's index
- (void)useBagItemForType:(BagQueryTargetType)targetType withItemIndex:(NSInteger)itemIndex; // Used a bag item (with type)
- (void)addBagItemsForType:(BagQueryTargetType)targetType withItemSID:(NSInteger)itemSID quantity:(NSInteger)quantity;
- (void)tossBagItemsForType:(BagQueryTargetType)targetType withItemIndex:(NSInteger)itemIndex quantity:(NSInteger)quantity;

@end
