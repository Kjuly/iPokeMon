//
//  GameStatus.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/28/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameStatus.h"

#import "GlobalNotificationConstants.h"


@interface GameStatus () {
 @private
  BOOL isTrainerTurn_;
  BOOL isWildPokemonTurn_;
}

- (void)setTrainerAsControllerForNextTurn;
- (void)setWildPokemonAsControllerForNextTurn;

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
  return isWildPokemonTurn_;
}

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
