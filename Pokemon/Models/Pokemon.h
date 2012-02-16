//
//  Pokemon.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/16/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PokemonSpecies, PokemonType;

@interface Pokemon : NSManagedObject

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * pokemonID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSString * detailDescription;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSSet *types;
@property (nonatomic, retain) PokemonSpecies *species;
@end

@interface Pokemon (CoreDataGeneratedAccessors)

- (void)addTypesObject:(PokemonType *)value;
- (void)removeTypesObject:(PokemonType *)value;
- (void)addTypes:(NSSet *)values;
- (void)removeTypes:(NSSet *)values;

@end
