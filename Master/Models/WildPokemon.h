//
//  WildPokemon.h
//  iPokeMon
//
//  Created by Kaijie Yu on 4/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pokemon;

@interface WildPokemon : NSManagedObject

@property (nonatomic, strong) NSNumber * exp;
@property (nonatomic, strong) NSString * fourMoves;
@property (nonatomic, strong) NSNumber * gender;
@property (nonatomic, strong) NSNumber * hp;
@property (nonatomic, strong) NSNumber * level;
@property (nonatomic, strong) NSString * maxStats;
@property (nonatomic, strong) NSNumber * sid;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSNumber * toNextLevel;
@property (nonatomic, strong) NSNumber * uid;
@property (nonatomic, strong) Pokemon *pokemon;

@end
