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

@property (nonatomic, strong) NSDate * adventureStarted;
@property (nonatomic, strong) NSString * badges;
@property (nonatomic, strong) NSString * bagBattleItems;
@property (nonatomic, strong) NSString * bagBerries;
@property (nonatomic, strong) NSString * bagItems;
@property (nonatomic, strong) NSString * bagKeyItems;
@property (nonatomic, strong) NSString * bagMedicineHP;
@property (nonatomic, strong) NSString * bagMedicinePP;
@property (nonatomic, strong) NSString * bagMedicineStatus;
@property (nonatomic, strong) NSString * bagPokeballs;
@property (nonatomic, strong) NSString * bagTMsHMs;
@property (nonatomic, strong) NSNumber * money;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * pokedex;
@property (nonatomic, strong) NSString * sixPokemonsID;
@property (nonatomic, strong) NSNumber * uid;
@property (nonatomic, strong) NSSet *tamedPokemons;
@end

@interface Trainer (CoreDataGeneratedAccessors)

- (void)addTamedPokemonsObject:(TrainerTamedPokemon *)value;
- (void)removeTamedPokemonsObject:(TrainerTamedPokemon *)value;
- (void)addTamedPokemons:(NSSet *)values;
- (void)removeTamedPokemons:(NSSet *)values;
@end
