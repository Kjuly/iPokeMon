//
//  TrainerTamedPokemon+DataController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerTamedPokemon.h"

#import "Move+DataController.h"
#import "Pokemon+DataController.h"

@class WildPokemon;

@interface TrainerTamedPokemon (DataController)

+ (void)initWithTrainer:(Trainer *)trainer completion:(void (^)())completion;
+ (void)syncWithUserID:(NSInteger)userID
            pokemonUID:(NSInteger)pokemonUID
                  flag:(DataModifyFlag)flag; // CM: Sync data between Client & Server
- (void)syncWithFlag:(DataModifyFlag)flag;   // IM: ...

+ (NSArray *)sixPokemonsForTrainer:(NSInteger)trainerID;
+ (NSArray *)queryPokemonsWithUID:(NSArray *)pokemonsUID trainerUID:(NSInteger)trainerUID fetchLimit:(NSInteger)fetchLimit;
+ (NSInteger)numberOfTamedPokemonsWithTraienrUID:(NSInteger)trainerUID;
+ (TrainerTamedPokemon *)queryPokemonDataWithUID:(NSInteger)pokemonUID trainerUID:(NSInteger)trainerUID;
+ (void)addPokemonWithWildPokemon:(WildPokemon *)wildPokemon
                         withMemo:(NSString *)memo
                            toBox:(NSInteger)box
                       forTrainer:(Trainer *)trainer;

// GET Base data
- (Move *)moveWithIndex:(NSInteger)index;
- (Move *)move1;
- (Move *)move2;
- (Move *)move3;
- (Move *)move4;
- (NSArray *)fourMovesPPInArray; // Current PPs & Max PPs
- (NSInteger)fourMovesPPInOne;   // Current PPs
- (NSArray *)maxStatsInArray;

// SET Base data
- (void)addMoveWithNewMoveID:(NSInteger)newMoveID;                              // Add Move
- (void)replaceMoveAtIndex:(NSInteger)index withNewMoveID:(NSInteger)newMoveID; // Replace move
//- (void)updateFourMovesWithPPArrayWithMax:(NSArray *)ppArrayWithMax;            // update pp & maxPP for moves (NSArray)
- (void)updateFourMovesWithPPArray:(NSArray *)ppArray;                          // Update PP for moves (NSArray)
- (void)updateFourMovesWithPPInOne:(NSInteger)PPInOne;                          // Update PP for moves (NSInteger)
- (NSInteger)levelsUpWithGainedExp:(NSInteger)gainedExp;                        // Levels up by adding gained EXP
- (NSArray *)addStatsWithLevelsUp:(NSInteger)levelsUp;                          // Add stats with number of levels up

@end
