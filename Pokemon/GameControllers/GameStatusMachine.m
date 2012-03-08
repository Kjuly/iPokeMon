//
//  GameStatus.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/28/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameStatusMachine.h"

#import "GlobalNotificationConstants.h"
#import "GameSystemProcess.h"
#import "GamePlayer.h"
//#import "GameEnemy.h"


@interface GameStatusMachine () {
 @private
  GameStatus gameStatus_;
  GameStatus gameNextStatus_;
  
  BOOL isTrainerTurn_;
  BOOL isWildPokemonTurn_;
}

- (void)setTrainerAsControllerForNextTurn;
- (void)setWildPokemonAsControllerForNextTurn;

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



// 
// Turn Check

// Setting after Turn End
- (void)trainerTurnEnd {
  isTrainerTurn_ = NO;
  [self performSelector:@selector(setWildPokemonAsControllerForNextTurn) withObject:self afterDelay:2.5f];
}

- (void)wildPokemonTurnEnd {
  isWildPokemonTurn_ = NO;
  [self performSelector:@selector(setTrainerAsControllerForNextTurn) withObject:self afterDelay:2.5f];
}

// Choose game controller for next turn
- (void)setTrainerAsControllerForNextTurn {
  isTrainerTurn_ = YES;
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdateGameBattleMessage
                                                      object:self
                                                    userInfo:[NSDictionary dictionaryWithObject:@"What's next?"
                                                                                         forKey:@"message"]];
}

- (void)setWildPokemonAsControllerForNextTurn {
  isWildPokemonTurn_ = YES;
}




@end
