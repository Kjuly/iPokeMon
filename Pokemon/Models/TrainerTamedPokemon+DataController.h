//
//  TrainerTamedPokemon+DataController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerTamedPokemon.h"

#import "GlobalConstants.h"
#import "Move+DataController.h"
#import "Pokemon+DataController.h"

@interface TrainerTamedPokemon (DataController)

+ (void)initWithUserID:(NSInteger)userID;
+ (void)syncWithUserID:(NSInteger)userID flag:(DataModifyFlag)flag; // Sync data between Client & Server

+ (NSArray *)sixPokemonsForTrainer:(NSInteger)trainerID;
+ (NSArray *)queryPokemonsWithID:(NSArray *)pokemonsID fetchLimit:(NSInteger)fetchLimit;
+ (TrainerTamedPokemon *)queryPokemonDataWithID:(NSInteger)pokemonID;

// Base data dispatch
- (Move *)moveWithIndex:(NSInteger)index;
- (Move *)move1;
- (Move *)move2;
- (Move *)move3;
- (Move *)move4;
- (NSArray *)fourMovesPP;
- (void)setFourMovesPPWith:(NSArray *)newPPArray;

@end
