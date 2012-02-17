//
//  Trainer.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pokemon;

@interface Trainer : NSManagedObject

@property (nonatomic, retain) NSDate * adventureStarted;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * trainerID;
@property (nonatomic, retain) NSSet *pokedex;
@property (nonatomic, retain) NSSet *sixPokemons;
@end

@interface Trainer (CoreDataGeneratedAccessors)

- (void)addPokedexObject:(Pokemon *)value;
- (void)removePokedexObject:(Pokemon *)value;
- (void)addPokedex:(NSSet *)values;
- (void)removePokedex:(NSSet *)values;

- (void)addSixPokemonsObject:(Pokemon *)value;
- (void)removeSixPokemonsObject:(Pokemon *)value;
- (void)addSixPokemons:(NSSet *)values;
- (void)removeSixPokemons:(NSSet *)values;

@end
