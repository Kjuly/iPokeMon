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
#import "GameMyPokemon.h"


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
  
  // Remove observer
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNMoveEffect object:nil];
  [super dealloc];
}

- (id)initWithwildPokemon:(GameWildPokemon *)gameWildPokemon
           trainerPokemon:(GameMyPokemon *)gameTrainerPokemon
{
  if (self = [super init]) {
    self.gameWildPokemon    = gameWildPokemon;
    self.gameTrainerPokemon = gameTrainerPokemon;
    
    // Add observer for notification from |GameWildPokemon| & |GameMenuMoveViewController|
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
  NSInteger moveDamage = [[userInfo objectForKey:@"damage"] intValue];
  
  // Prepare data for updating pokemon's status
  NSString * target;
  NSInteger  hp;
  
  if ([[userInfo objectForKey:@"MoveOwner"] isEqualToString:@"MyPokemon"]) {
    self.gameWildPokemon.hp -= moveDamage;
    if (self.gameWildPokemon.hp < 0)
      self.gameWildPokemon.hp = 0;
    if (self.gameWildPokemon.hp > self.gameWildPokemon.hpMax)
      self.gameWildPokemon.hp = self.gameWildPokemon.hpMax;
    
    target = @"WildPokemon";
    hp     = self.gameWildPokemon.hp;
  }
  else {
    self.gameTrainerPokemon.hp -= moveDamage;
    if (self.gameTrainerPokemon.hp < 0)
      self.gameTrainerPokemon.hp = 0;
    if (self.gameTrainerPokemon.hp > self.gameTrainerPokemon.hpMax)
      self.gameTrainerPokemon.hp = self.gameTrainerPokemon.hpMax;
    
    target = @"MyPokemon";
    hp     = self.gameTrainerPokemon.hp;
  }
  userInfo = nil;
  
  // Post to |GameMenuViewController|
  NSDictionary * newUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                target, @"target", [NSNumber numberWithInt:hp], @"HP", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdatePokemonStatus object:self userInfo:newUserInfo];
  [newUserInfo release];
}

@end
