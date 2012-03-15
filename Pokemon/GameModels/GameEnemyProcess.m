//
//  GameEnemy.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameEnemyProcess.h"

#import "GameStatusMachine.h"
#import "GameSystemProcess.h"


@interface GameEnemyProcess () {
 @private
  BOOL complete_;
}

- (void)attack;

@end

@implementation GameEnemyProcess

- (void)dealloc
{
  [super dealloc];
}

- (id)init
{
  if (self = [super init]) {
    complete_ = NO;
  }
  return self;
}

- (void)update:(ccTime)dt
{
  if (complete_) {
    [[GameStatusMachine sharedInstance] endStatus:kGameStatusEnemyTurn];
    complete_ = NO;
  }
  else [self attack];
}

- (void)endTurn {
  complete_ = YES;
}

#pragma mark - Private Methods

- (void)attack
{
  // Do Move Attack
  //
  // TODO:
  //   Need an algorithm to choose the MOVE
  //
  NSInteger moveIndex = 1;
  
  // System process setting
  GameSystemProcess * gameSystemProcess = [GameSystemProcess sharedInstance];
  [gameSystemProcess setSystemProcessOfFightWithUser:kGameSystemProcessUserEnemy
                                           moveIndex:moveIndex];
  
  [self endTurn];
}

@end
