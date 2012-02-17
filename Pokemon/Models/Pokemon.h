//
//  Pokemon.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PokemonSpecies, PokemonType, Trainer;

@interface Pokemon : NSManagedObject

@property (nonatomic, retain) NSString * detailDescription;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * pokemonID;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) UIImage * image;
@property (nonatomic, retain) PokemonSpecies *species;
@property (nonatomic, retain) NSSet *types;
@property (nonatomic, retain) NSManagedObject *icon;
@property (nonatomic, retain) NSSet *owners;
@end

@interface Pokemon (CoreDataGeneratedAccessors)

- (void)addTypesObject:(PokemonType *)value;
- (void)removeTypesObject:(PokemonType *)value;
- (void)addTypes:(NSSet *)values;
- (void)removeTypes:(NSSet *)values;

- (void)addOwnersObject:(Trainer *)value;
- (void)removeOwnersObject:(Trainer *)value;
- (void)addOwners:(NSSet *)values;
- (void)removeOwners:(NSSet *)values;

@end
