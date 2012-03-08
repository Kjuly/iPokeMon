//
//  GameStatus.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/28/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameStatusMachine.h"

@interface GameStatusMachine () {
 @private
  GameStatus gameStatus_;
  GameStatus gameNextStatus_;
  
  BOOL isTrainerTurn_;
  BOOL isWildPokemonTurn_;
}

@end


@implementation GameStatusMachine

static GameStatusMachine * gameStatusMachine = nil;

// Singleton
+ (GameStatusMachine *)sharedInstance
{
  if (gameStatusMachine != nil)
    return gameStatusMachine;
  
  static dispatch_once_t pred;        // Lock
  dispatch_once(&pred, ^{             // This code is called at most once per app
    gameStatusMachine = [[GameStatusMachine alloc] init];
  });
  return gameStatusMachine;
}

- (void)dealloc
{
  [super dealloc];
}

- (id)init
{
  if (self = [super init]) {
    gameStatus_     = kGameStatusInitialization;
    gameNextStatus_ = kGameStatusSystemProcess;
  }
  return self;
}

- (GameStatus)status {
  return gameStatus_;
}

- (void)startNewTurn {
  gameStatus_ = kGameStatusPlayerTurn;
}

- (void)resetStatus {
  gameStatus_ = kGameStatusInitialization;
}

- (void)endStatus:(GameStatus)status
{
  switch (status) {
    case kGameStatusSystemProcess:
      gameStatus_ = gameNextStatus_;
      break;
      
    case kGameStatusPlayerTurn:
      gameNextStatus_ = kGameStatusEnemyTurn;
      gameStatus_     = kGameStatusSystemProcess;
      break;
      
    case kGameStatusEnemyTurn:
      gameNextStatus_ = kGameStatusPlayerTurn;
      gameStatus_     = kGameStatusSystemProcess;
      break;
      
    default:
      break;
  }
}

@end
