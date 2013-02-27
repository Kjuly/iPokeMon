//
//  Trainer+DataController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/16/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Trainer.h"

@interface Trainer (DataController)

// Class Methods
+ (void)initWithUserID:(NSInteger)userID completion:(void (^)())completion;
+ (void)addData;
+ (NSArray *)queryAllData;
+ (Trainer *)queryTrainerWithUserID:(NSInteger)userID;
+ (void)setTrainerWith:(NSInteger)id Name:(NSString *)name;

// Instance Methods
- (void)syncWithFlag:(DataModifyFlag)flag; // Sync data between Client & Server
- (NSArray *)sixPokemons;
- (void)addPokemonToSixPokemonsWithPokemonUID:(NSInteger)pokemonUID;

@end
