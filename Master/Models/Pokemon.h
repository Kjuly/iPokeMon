//
//  Pokemon.h
//  iPokeMon
//
//  Created by Kaijie Yu on 4/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TrainerTamedPokemon, WildPokemon;

@interface Pokemon : NSManagedObject

@property (nonatomic, strong) NSNumber * ability1;
@property (nonatomic, strong) NSNumber * ability2;
@property (nonatomic, strong) NSString * area;
@property (nonatomic, strong) NSNumber * baseEXP;
@property (nonatomic, strong) NSString * baseStats;
@property (nonatomic, strong) NSNumber * color;
@property (nonatomic, strong) NSNumber * compatibility;
@property (nonatomic, strong) NSString * effortPoints;
@property (nonatomic, strong) NSString * eggMoves;
@property (nonatomic, strong) NSString * evolutions;
@property (nonatomic, strong) NSNumber * genderRate;
@property (nonatomic, strong) NSNumber * growthRate;
@property (nonatomic, strong) NSNumber * habitat;
@property (nonatomic, strong) NSNumber * happiness;
@property (nonatomic, strong) NSNumber * height;
@property (nonatomic, strong) NSNumber * hiddenAbility;
@property (nonatomic, strong) id image;
@property (nonatomic, strong) id imageIcon;
@property (nonatomic, strong) NSString * info;
@property (nonatomic, strong) NSString * moves;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSNumber * rareness;
@property (nonatomic, strong) NSNumber * sid;
@property (nonatomic, strong) NSNumber * species;
@property (nonatomic, strong) NSNumber * stepsToHatch;
@property (nonatomic, strong) NSNumber * type1;
@property (nonatomic, strong) NSNumber * type2;
@property (nonatomic, strong) NSNumber * weight;
@property (nonatomic, strong) id imageBack;
@property (nonatomic, strong) NSSet *tamedGroup;
@property (nonatomic, strong) NSSet *wildGroup;
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
