//
//  GameStatus.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/28/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameStatus.h"


@interface GameStatus () {
 @private
  BOOL isTrainerTurn_;
}

@end

@implementation GameStatus

static GameStatus * gameStatus = nil;

// Singleton
+ (GameStatus *)sharedInstance
{
  if (gameStatus != nil)
    return gameStatus;
  
  static dispatch_once_t pred;        // Lock
  dispatch_once(&pred, ^{             // This code is called at most once per app
    gameStatus = [[GameStatus alloc] init];
  });
  return gameStatus;
}

- (void)dealloc
{
  [super dealloc];
}

- (id)init
{
  if (self = [super init]) {
    isTrainerTurn_ = YES;
  }
  return self;
}

// Turn Check
- (BOOL)isTrainerTurn {
  return isTrainerTurn_;
}

- (BOOL)isWildPokemonTurn {
  return ! isTrainerTurn_;
}

// Setting after Turn End
- (void)trainerTurnEnd {
  isTrainerTurn_ = NO;
}

- (void)wildPokemonTurnEnd {
  isTrainerTurn_ = YES;
}

@end
