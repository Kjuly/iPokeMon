//
//  Trainer+DataController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/16/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Trainer.h"

#import "GlobalConstants.h"

@interface Trainer (DataController)

+ (void)initWithUserID:(NSInteger)userID;
+ (void)syncWithUserID:(NSInteger)userID flag:(DataModifyFlag)flag; // Sync data between Client & Server
+ (void)addData;
+ (NSArray *)queryAllData;
+ (Trainer *)queryTrainerWithUserID:(NSInteger)userID;
+ (void)setTrainerWith:(NSInteger)id Name:(NSString *)name;

- (NSArray *)sixPokemons;

@end
