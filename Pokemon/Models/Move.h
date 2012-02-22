//
//  Move.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TrainerTamedPokemon;

@interface Move : NSManagedObject

@property (nonatomic, retain) NSNumber * additionalEffectChance;
@property (nonatomic, retain) NSNumber * baseDamage;
@property (nonatomic, retain) NSNumber * basePP;
@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSNumber * contestType;
@property (nonatomic, retain) NSNumber * effectCode;
@property (nonatomic, retain) NSNumber * flags;
@property (nonatomic, retain) NSNumber * hitChance;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * priority;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * target;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *learnedPokemons;
@end

@interface Move (CoreDataGeneratedAccessors)

- (void)addLearnedPokemonsObject:(TrainerTamedPokemon *)value;
- (void)removeLearnedPokemonsObject:(TrainerTamedPokemon *)value;
- (void)addLearnedPokemons:(NSSet *)values;
- (void)removeLearnedPokemons:(NSSet *)values;

@end
