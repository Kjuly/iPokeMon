//
//  TrainerTamedPokemon.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pokemon, Trainer;

@interface TrainerTamedPokemon : NSManagedObject

@property (nonatomic, retain) id box;
@property (nonatomic, retain) NSNumber * currEXP;
@property (nonatomic, retain) id fourMoves;
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

@end
