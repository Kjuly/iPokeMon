//
//  GameSystemProcess.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GlobalConstants.h"

@class TrainerTamedPokemon;
@class WildPokemon;

//typedef enum {
//  kGameSystemProcessTargetPlayer = 0,
//  kGameSystemProcessTargetEnemy  = 1
//}GameSystemProcessTarget;

// User
typedef enum {
  kGameSystemProcessUserNone   = 0, // None
  kGameSystemProcessUserPlayer = 1, // Player
  kGameSystemProcessUserEnemy  = 2  // Enemy
}GameSystemProcessUser;

// Move Real Target
typedef enum {
  kMoveRealTargetNone   = 0,      // None
  kMoveRealTargetEnemy  = 1 << 0, // Enemy
  kMoveRealTargetPlayer = 1 << 1, // Player
}MoveRealTarget;


@interface GameSystemProcess : CCNode {
  TrainerTamedPokemon * playerPokemon_;
  WildPokemon         * enemyPokemon_;
}

@property (nonatomic, retain) TrainerTamedPokemon * playerPokemon;
@property (nonatomic, retain) WildPokemon         * enemyPokemon;

+ (GameSystemProcess *)sharedInstance;

- (void)prepareForNewScene;
- (void)reset;
- (void)update:(ccTime)dt;
- (void)endTurn;

// Setting Methods
- (void)setSystemProcessOfFightWithUser:(GameSystemProcessUser)user moveIndex:(NSInteger)moveIndex;
- (void)setSystemProcessOfUseBagItemWithUser:(GameSystemProcessUser)user;
- (void)setSystemProcessOfReplacePokemonWithUser:(GameSystemProcessUser)user;
- (void)setSystemProcessOfRunWithUser:(GameSystemProcessUser)user;

@end
