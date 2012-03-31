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


@interface TrainerCoreDataController : NSObject

+ (TrainerCoreDataController *)sharedInstance;
- (void)initTrainerWithUserID:(NSInteger)userID;

// Sync data between Client & Server
- (void)sync;

// Trainer's Data
- (NSInteger)UID;                                              // UID
- (NSString *)name;                                            // Name
- (NSInteger)money;                                            // Money
- (NSDate *)timeStarted;                                       // Adventured Time Started
- (NSString *)pokedex;                                         // Pokedex
- (NSArray *)sixPokemons;                                      // Six Pokemons
- (TrainerTamedPokemon *)firstPokemonOfSix;                    // First of Six Pokemons
- (TrainerTamedPokemon *)pokemonOfSixAtIndex:(NSInteger)index; // Pokemon at |index| of Six Pokemons
- (NSArray *)bagItemsFor:(BagQueryTargetType)targetType;       // Bag Items

@end
