//
//  GameSystemProcess.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class TrainerTamedPokemon;
@class WildPokemon;

typedef enum {
  kGameSystemProcessMoveTargetPlayer = 0,
  kGameSystemProcessMoveTargetEnemy  = 1
}GameSystemProcessMoveTarget;

@interface GameSystemProcess : CCNode {
  TrainerTamedPokemon * playerPokemon_;
  WildPokemon         * enemyPokemon_;
  
  GameSystemProcessMoveTarget moveTarget_;
  NSInteger baseDamage_;
}

@property (nonatomic, retain) TrainerTamedPokemon * playerPokemon;
@property (nonatomic, retain) WildPokemon         * enemyPokemon;

@property (nonatomic, assign) GameSystemProcessMoveTarget moveTarget;
@property (nonatomic, assign) NSInteger baseDamage;

+ (GameSystemProcess *)sharedInstance;

- (void)update:(ccTime)dt;
- (void)endTurn;

@end
