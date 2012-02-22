//
//  TrainerTamedPokemon.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Move, Pokemon, Trainer;

@interface TrainerTamedPokemon : NSManagedObject

@property (nonatomic, retain) id box;
@property (nonatomic, retain) NSNumber * currEXP;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSNumber * happiness;
@property (nonatomic, retain) id leftStats;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) id maxStats;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * toNextLevel;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) Trainer *owner;
@property (nonatomic, retain) Pokemon *pokemon;
@property (nonatomic, retain) NSSet *fourMoves;
@end

@interface TrainerTamedPokemon (CoreDataGeneratedAccessors)

- (void)addFourMovesObject:(Move *)value;
- (void)removeFourMovesObject:(Move *)value;
- (void)addFourMoves:(NSSet *)values;
- (void)removeFourMoves:(NSSet *)values;

@end
