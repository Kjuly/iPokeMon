//
//  GameMoveEffect.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameMoveEffect.h"

#import "GlobalNotificationConstants.h"
#import "GameWildPokemon.h"
#import "GameTrainerPokemon.h"


@interface GameMoveEffect () {
 @private
}

- (void)applyMoveEffect:(NSNotification *)notification;

@end

@implementation GameMoveEffect

@synthesize gameWildPokemon    = gameWildPoekmon_;
@synthesize gameTrainerPokemon = gameTrainerPokemon_;

- (void)dealloc
{
  [gameWildPoekmon_    release];
  [gameTrainerPokemon_ release];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNMoveEffect object:nil];
  [super dealloc];
}

- (id)initWithwildPokemon:(GameWildPokemon *)gameWildPokemon
           trainerPokemon:(GameTrainerPokemon *)gameTrainerPokemon
{
  if (self = [super init]) {
    self.gameWildPokemon    = gameWildPokemon;
    self.gameTrainerPokemon = gameTrainerPokemon;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applyMoveEffect:)
                                                 name:kPMNMoveEffect
                                               object:nil];
  }
  return self;
}

- (id)init
{
  if (self = [super init]) {
  }
  return self;
}

#pragma mark - Private Methods

- (void)applyMoveEffect:(NSNotification *)notification
{
  NSDictionary * userInfo = notification.userInfo;
  if ([[userInfo objectForKey:@"MoveOwner"] isEqualToString:@"TrainerPokemon"]) {
    self.gameWildPokemon.hp -= [[userInfo objectForKey:@"damage"] intValue];
    if (self.gameWildPokemon.hp < 0)
      self.gameWildPokemon.hp = 0;
  }
  else {
    self.gameTrainerPokemon.hp -= [[userInfo objectForKey:@"damage"] intValue];
    if (self.gameTrainerPokemon.hp < 0)
      self.gameTrainerPokemon.hp = 0;
  }
  userInfo = nil;
}

@end
