//
//  Trainer.h
//  iPokeMon
//
//  Created by Kaijie Yu on 4/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TrainerTamedPokemon;

@interface Trainer : NSManagedObject

@property (nonatomic, retain) NSDate * adventureStarted;
@property (nonatomic, retain) NSString * badges;
@property (nonatomic, retain) NSString * bagBattleItems;
@property (nonatomic, retain) NSString * bagBerries;
@property (nonatomic, retain) NSString * bagItems;
@property (nonatomic, retain) NSString * bagKeyItems;
@property (nonatomic, retain) NSString * bagMedicineHP;
@property (nonatomic, retain) NSString * bagMedicinePP;
@property (nonatomic, retain) NSString * bagMedicineStatus;
@property (nonatomic, retain) NSString * bagPokeballs;
@property (nonatomic, retain) NSString * bagTMsHMs;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pokedex;
@property (nonatomic, retain) NSString * sixPokemonsID;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSSet *tamedPokemons;
@end

@interface Trainer (CoreDataGeneratedAccessors)

- (void)addTamedPokemonsObject:(TrainerTamedPokemon *)value;
- (void)removeTamedPokemonsObject:(TrainerTamedPokemon *)value;
- (void)addTamedPokemons:(NSSet *)values;
- (void)removeTamedPokemons:(NSSet *)values;
@end
