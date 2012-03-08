//
//  GameEnemy.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameEnemy.h"

#import "GlobalNotificationConstants.h"
#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "WildPokemon.h"
#import "Move.h"


@interface GameEnemy () {
 @private
  BOOL complete_;
}

- (void)attack;

@end

@implementation GameEnemy

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
  WildPokemon * enemyPokemon = [GameSystemProcess sharedInstance].enemyPokemon;
  Move * move = [[enemyPokemon.fourMoves allObjects] objectAtIndex:0];
  
  // Set data for message in |GameMenuViewController|
  NSInteger pokemonID = [enemyPokemon.sid intValue];
  NSInteger moveID    = [move.sid intValue];
  // Post message: (<PokemonName> used <MoveName>, etc) to |messageView_| in |GameMenuViewController|
  NSString * message = [NSString stringWithFormat:@"%@ %@ %@",
                        NSLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", pokemonID]), nil),
                        NSLocalizedString(@"PMS_used", nil),
                        NSLocalizedString(([NSString stringWithFormat:@"PMSMoveName%.3d", moveID]), nil)];
  NSDictionary * messageInfo = [NSDictionary dictionaryWithObject:message forKey:@"message"];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdateGameBattleMessage object:self userInfo:messageInfo];
  
  // Send parameter to Move Effect Controller
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"WildPokemon", @"MoveOwner",
                             enemyPokemon.sid, @"pokemonID",
                             move.sid, @"moveID",
                             move.baseDamage, @"damage", nil];
  // Notification target: |GameMoveEffect|
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNMoveEffect object:nil userInfo:userInfo];
  [userInfo release];
  
  // System process setting
  GameSystemProcess * gameSystemProcess = [GameSystemProcess sharedInstance];
  gameSystemProcess.moveTarget = kGameSystemProcessMoveTargetPlayer;
  gameSystemProcess.baseDamage = [move.baseDamage intValue];
  
  enemyPokemon = nil;
  [self endTurn];
}

@end
