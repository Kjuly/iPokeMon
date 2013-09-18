//
//  GameEnemy.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameEnemyProcess.h"

#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "WildPokemon+DataController.h"


@interface GameEnemyProcess () {
 @private
  BOOL      complete_;
  NSInteger numberOfMoves_;
}

- (void)_attack;

@end


@implementation GameEnemyProcess

- (id)init
{
  if (self = [super init]) {
    complete_      = NO;
    numberOfMoves_ = 0;
  }
  return self;
}

- (void)update:(ccTime)dt
{
  if (complete_) {
    [[GameStatusMachine sharedInstance] endStatus:kGameStatusEnemyTurn];
    complete_ = NO;
  }
  else [self _attack];
}

- (void)endTurn
{
  complete_ = YES;
}

#pragma mark - Private Methods

// Do Move Attack
- (void)_attack
{
  // Get number of Moves in |fourMoves_|
  if (numberOfMoves_ == 0)
    numberOfMoves_ = [[GameSystemProcess sharedInstance].enemyPokemon numberOfMoves];
  
  NSInteger moveIndex = arc4random() % numberOfMoves_ + 1;
  
  // System process setting
  GameSystemProcess * gameSystemProcess = [GameSystemProcess sharedInstance];
  [gameSystemProcess setSystemProcessOfFightWithUser:kGameSystemProcessUserEnemy
                                           moveIndex:moveIndex];
  
  [self endTurn];
}

@end
