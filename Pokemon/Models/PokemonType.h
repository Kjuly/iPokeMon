//
//  PokemonType.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pokemon;

@interface PokemonType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * typeID;
@property (nonatomic, retain) NSSet *pokemons;
@end

@interface PokemonType (CoreDataGeneratedAccessors)

- (void)addPokemonsObject:(Pokemon *)value;
- (void)removePokemonsObject:(Pokemon *)value;
- (void)addPokemons:(NSSet *)values;
- (void)removePokemons:(NSSet *)values;

@end
