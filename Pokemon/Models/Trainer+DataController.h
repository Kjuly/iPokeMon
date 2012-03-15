//
//  Trainer+DataController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/16/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Trainer.h"

@interface Trainer (DataController)

+ (BOOL)updateDataForTrainer:(NSInteger)trainerID;
+ (void)addData;
+ (NSArray *)queryAllData;
+ (Trainer *)queryTrainerWithTrainerID:(NSInteger)trainerID;
+ (void)setTrainerWith:(NSInteger)id Name:(NSString *)name;

- (NSArray *)sixPokemons;

@end
