//
//  TrainerCoreData.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Trainer+DataController.h"
#import "TrainerTamedPokemon+DataController.h"
#import "WildPokemon+DataController.h"
#import "BagDataController.h"


@interface TrainerCoreDataController : NSObject

+ (TrainerCoreDataController *)sharedInstance;

- (void)initTrainerWithUserID:(NSInteger)userID;

// Sync data between Client & Server
- (void)sync;

// Get Trainer's Data
- (Trainer *)trainer;
- (NSArray *)sixPokemons;
- (TrainerTamedPokemon *)firstPokemonOfSix;
- (TrainerTamedPokemon *)pokemonOfSixAtIndex:(NSInteger)index;
- (NSArray *)bagItemsFor:(BagQueryTargetType)targetType;

@end
