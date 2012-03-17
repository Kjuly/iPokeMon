//
//  Trainer.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TrainerTamedPokemon;

@interface Trainer : NSManagedObject

@property (nonatomic, retain) NSDate * adventureStarted;
@property (nonatomic, retain) id bagBattleItems;
@property (nonatomic, retain) id bagBerries;
@property (nonatomic, retain) id bagItems;
@property (nonatomic, retain) id bagKeyItems;
@property (nonatomic, retain) id bagMedicine;
@property (nonatomic, retain) id bagPokeballs;
@property (nonatomic, retain) id bagTMHMs;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pokedex;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSString * sixPokemonsID;
@property (nonatomic, retain) NSSet *tamedPokemons;
@end

@interface Trainer (CoreDataGeneratedAccessors)

- (void)addTamedPokemonsObject:(TrainerTamedPokemon *)value;
- (void)removeTamedPokemonsObject:(TrainerTamedPokemon *)value;
- (void)addTamedPokemons:(NSSet *)values;
- (void)removeTamedPokemons:(NSSet *)values;
@end
