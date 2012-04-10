//
//  Pokemon.h
//  Pokemon
//
//  Created by Kaijie Yu on 4/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TrainerTamedPokemon, WildPokemon;

@interface Pokemon : NSManagedObject

@property (nonatomic, retain) NSNumber * ability1;
@property (nonatomic, retain) NSNumber * ability2;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSNumber * baseEXP;
@property (nonatomic, retain) NSString * baseStats;
@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSNumber * compatibility;
@property (nonatomic, retain) NSString * effortPoints;
@property (nonatomic, retain) NSString * eggMoves;
@property (nonatomic, retain) NSString * evolutions;
@property (nonatomic, retain) NSNumber * genderRate;
@property (nonatomic, retain) NSNumber * growthRate;
@property (nonatomic, retain) NSNumber * habitat;
@property (nonatomic, retain) NSNumber * happiness;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * hiddenAbility;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) id imageIcon;
@property (nonatomic, retain) NSString * info;
@property (nonatomic, retain) NSString * moves;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rareness;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * species;
@property (nonatomic, retain) NSNumber * stepsToHatch;
@property (nonatomic, retain) NSNumber * type1;
@property (nonatomic, retain) NSNumber * type2;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) id imageBack;
@property (nonatomic, retain) NSSet *tamedGroup;
@property (nonatomic, retain) NSSet *wildGroup;
@end

@interface Pokemon (CoreDataGeneratedAccessors)

- (void)addTamedGroupObject:(TrainerTamedPokemon *)value;
- (void)removeTamedGroupObject:(TrainerTamedPokemon *)value;
- (void)addTamedGroup:(NSSet *)values;
- (void)removeTamedGroup:(NSSet *)values;
- (void)addWildGroupObject:(WildPokemon *)value;
- (void)removeWildGroupObject:(WildPokemon *)value;
- (void)addWildGroup:(NSSet *)values;
- (void)removeWildGroup:(NSSet *)values;
@end
