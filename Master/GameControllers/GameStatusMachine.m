//
//  GameStatus.m
//  iPokeMon
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

// Singleton
static GameStatusMachine * gameStatusMachine_ = nil;
+ (GameStatusMachine *)sharedInstance
{
  if (gameStatusMachine_ != nil)
    return gameStatusMachine_;
  
  static dispatch_once_t onceToken; // Lock
  dispatch_once(&onceToken, ^{      // This code is called at most once per app
    gameStatusMachine_ = [[GameStatusMachine alloc] init];
  });
  return gameStatusMachine_;
}


- (id)init
{
  if (self = [super init]) {
    gameStatus_     = kGameStatusInitialization;
    gameNextStatus_ = kGameStatusSystemProcess;
  }
  return self;
}

- (GameStatus)status
{
  return gameStatus_;
}

- (void)startNewTurn
{
  gameStatus_ = kGameStatusPlayerTurn;
}

- (void)resetStatus
{
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
