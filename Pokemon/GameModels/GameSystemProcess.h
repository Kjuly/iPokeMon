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

// User
typedef enum {
  kGameSystemProcessUserNone   = 0, // None
  kGameSystemProcessUserPlayer = 1, // Player
  kGameSystemProcessUserEnemy  = 2  // Enemy
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
- (void)setSystemProcessOfUseBagItemWithUser:(GameSystemProcessUser)user
                                  targetType:(BagQueryTargetType)targetType
                                   itemIndex:(NSInteger)itemIndex;
- (void)setSystemProcessOfReplacePokemonWithUser:(GameSystemProcessUser)user;
- (void)setSystemProcessOfRunWithUser:(GameSystemProcessUser)user;

@end
