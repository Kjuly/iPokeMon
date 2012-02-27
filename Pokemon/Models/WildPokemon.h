//
//  WildPokemon.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Move, Pokemon;

@interface WildPokemon : NSManagedObject

@property (nonatomic, retain) NSNumber * currEXP;
@property (nonatomic, retain) NSNumber * currHP;
@property (nonatomic, retain) id fourMovesPP;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) id maxStats;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * toNextLevel;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSSet *fourMoves;
@property (nonatomic, retain) Pokemon *pokemon;
@end

@interface WildPokemon (CoreDataGeneratedAccessors)

- (void)addFourMovesObject:(Move *)value;
- (void)removeFourMovesObject:(Move *)value;
- (void)addFourMoves:(NSSet *)values;
- (void)removeFourMoves:(NSSet *)values;
@end
