//
//  GamePlayer.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GamePlayerProcess.h"

#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "TrainerTamedPokemon.h"


@interface GamePlayerProcess () {
 @private
  BOOL complete_;
}

- (void)_sendMessageToPlayer;

@end


@implementation GamePlayerProcess

- (id)init
{
  if (self = [super init]) {
    complete_ = NO;
  }
  return self;
}

- (void)update:(ccTime)dt
{
  // Player will control the turn and send
  //   |[[GameStatusMachine sharedInstance] endStatus:kGameStatusPlayerTurn];|,
  // so jsut pass here if completed.
  if (complete_)
    return;
  else [self _sendMessageToPlayer];
}

- (void)reset
{
  complete_ = NO;
}

- (void)endTurn
{
  complete_ = YES;
}

#pragma mark - Private Methods

// Send message to Player (i.e. update text in |messageView_| of |GameMenuViewController| )
- (void)_sendMessageToPlayer
{
  TrainerTamedPokemon * playerPokemon = [GameSystemProcess sharedInstance].playerPokemon;
  
  NSString * message;
  if ([playerPokemon.hp intValue] > 0)
    message = [NSString stringWithFormat:@"%@ %@ %@",
               NSLocalizedString(@"PMSMessageWhatWillXXXDoPart1", nil),
               KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", [playerPokemon.sid intValue]]), nil),
               NSLocalizedString(@"PMSMessageWhatWillXXXDoPart3", nil)];
  else message = NSLocalizedString(@"PMSMessageChooseNewPokemon", nil);
  
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             message,                     @"message",
                             [NSNumber numberWithInt:-1], @"user", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdateGameBattleMessage
                                                      object:self
                                                    userInfo:userInfo];
  playerPokemon = nil;
  [self endTurn];
}

@end
