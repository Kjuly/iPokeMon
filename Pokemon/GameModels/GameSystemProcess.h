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
  kGameSystemProcessTargetPlayer = 0,
  kGameSystemProcessTargetEnemy  = 1
}GameSystemProcessTarget;

typedef enum {
  kGameSystemProcessUserNone   = 0,
  kGameSystemProcessUserPlayer = 1,
  kGameSystemProcessUserEnemy  = 2
}GameSystemProcessUser;

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
- (void)setSystemProcessOfBagWithUser:(GameSystemProcessUser)user;
- (void)setSystemProcessOfReplacePokemonWithUser:(GameSystemProcessUser)user;

@end
