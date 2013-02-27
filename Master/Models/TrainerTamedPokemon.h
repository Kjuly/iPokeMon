//
//  TrainerTamedPokemon.h
//  iPokeMon
//
//  Created by Kaijie Yu on 4/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pokemon, Trainer;

@interface TrainerTamedPokemon : NSManagedObject

@property (nonatomic, retain) NSNumber * box;
@property (nonatomic, retain) NSNumber * exp;
@property (nonatomic, retain) NSString * fourMoves;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSNumber * happiness;
@property (nonatomic, retain) NSNumber * hp;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSString * maxStats;
@property (nonatomic, retain) NSString * memo;
@property (nonatomic, retain) NSNumber * sid;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * toNextLevel;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) Trainer *owner;
@property (nonatomic, retain) Pokemon *pokemon;

@end
