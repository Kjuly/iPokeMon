//
//  GameSystemProcess.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameSystemProcess.h"

#import "GlobalNotificationConstants.h"
#import "GameStatusMachine.h"
#import "TrainerTamedPokemon.h"
#import "WildPokemon.h"


@interface GameSystemProcess () {
@private
  BOOL complete_;
}

- (void)applyMove;

@end


@implementation GameSystemProcess

@synthesize playerPokemon = playerPokemon_;
@synthesize enemyPokemon  = enemyPokemon_;

@synthesize moveTarget = moveTarget_;
@synthesize baseDamage = baseDamage_;

static GameSystemProcess * gameSystemProcess = nil;

+ (GameSystemProcess *)sharedInstance
{
  if (gameSystemProcess != nil)
    return gameSystemProcess;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gameSystemProcess = [[GameSystemProcess alloc] init];
  });
  
  return gameSystemProcess;
}

- (void)dealloc
{
  [super dealloc];
}

- (id)init
{
  if (self = [super init]) {
    complete_   = NO;
    moveTarget_ = kGameSystemProcessMoveTargetEnemy;
    baseDamage_ = 0;
  }
  return self;
}

- (void)update:(ccTime)dt
{
  if (complete_) {
    [[GameStatusMachine sharedInstance] endStatus:kGameStatusSystemProcess];
    complete_ = NO;
  }
  else [self applyMove];
}

- (void)endTurn {
  complete_ = YES;
}

#pragma mark - Private Methods

- (void)applyMove
{
  NSString * moveTarget;
  NSInteger  pokemonHP;
  if (self.moveTarget == kGameSystemProcessMoveTargetEnemy) {
    moveTarget = @"WildPokemon";
    pokemonHP = [self.enemyPokemon.currHP intValue];
    NSLog(@"Pokemon HP: %d", pokemonHP);
    pokemonHP -= self.baseDamage;
    pokemonHP = pokemonHP > 0 ? pokemonHP : 0;
    self.enemyPokemon.currHP = [NSNumber numberWithInt:pokemonHP];
    NSLog(@"Pokemon HP: %d", pokemonHP);
  }
  
/*
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
 */
  
  // Post to |GameMenuViewController|
  NSDictionary * newUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                moveTarget, @"target", [NSNumber numberWithInt:pokemonHP], @"HP", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdatePokemonStatus object:self userInfo:newUserInfo];
  [newUserInfo release];
  
  [self endTurn];
}

@end
