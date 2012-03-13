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

typedef enum {
  kMoveTargetSinglePokemonOtherThanTheUser      = 0, // Single Pokémon other than the user
  kMoveTargetNone                               = 1, // No target
  kMoveTargetOneOpposingPokemonSelectedAtRandom = 2, // One opposing Pokémon selected at random
  kMoveTargetAllOpposingPokemon                 = 4, // All opposing Pokémon
  kMoveTargetAllPokemonOtherThanTheUser         = 8, // All Pokémon other than the user (All non-users)
  kMoveTargetUser                               = 10, // User
  kMoveTargetBothSides                          = 20, // Both sides (e.g. Light Screen, Reflect, Heal Bell)
  kMoveTargetUserSide                           = 40, // User's side
  kMoveTargetOpposingPokemonSide                = 80, // Opposing Pokémon's side
  kMoveTargetUserPartner                        = 100, // User's partner
  kMoveTargetPlayerChoiceOfUserOrUserPartner    = 200, // Player's choice of user or user's partner (e.g. Acupressure)
  kMoveTargetSinglePokemonOnOpponentSide        = 400 // Single Pokémon on opponent's side (e.g. Me First)
}MoveTarget;


@interface GameSystemProcess () {
@private
  BOOL      complete_;
  NSInteger delayTime_; // Delay time for every turn
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
    [self reset];
    
    moveTarget_ = kGameSystemProcessMoveTargetEnemy;
    baseDamage_ = 0;
  }
  return self;
}

- (void)prepareForNewScene
{
  //
  // TODO:
  //   Data transform problem.
  //   | self.enemyPokemon.currEXP = [self.enemyPokemon.maxStats objectAtIndex:0]; |
  //
  // Reset HP for enemy pokemon
  NSArray * stats = self.enemyPokemon.maxStats;
  NSInteger currHP = [[stats objectAtIndex:0] intValue];
  self.enemyPokemon.currHP = [NSNumber numberWithInt:currHP];
  stats = nil;
}

- (void)update:(ccTime)dt
{
  delayTime_ += 100 * dt;
  if (complete_) {
    if (delayTime_ < 200) return;
    [[GameStatusMachine sharedInstance] endStatus:kGameStatusSystemProcess];
    [self reset];
  }
  else [self applyMove];
}

- (void)endTurn {
  complete_ = YES;
}

#pragma mark - Private Methods

- (void)reset {
  complete_  = NO;
  delayTime_ = 0;
}

- (void)applyMove
{
  NSString * moveTarget;
  NSInteger  pokemonHP;
  if (self.moveTarget == kGameSystemProcessMoveTargetEnemy) {
    moveTarget = @"WildPokemon";
    pokemonHP = [self.enemyPokemon.currHP intValue];
    NSLog(@"EnemyPokemon HP: %d", pokemonHP);
    pokemonHP -= self.baseDamage;
    pokemonHP = pokemonHP > 0 ? pokemonHP : 0;
    self.enemyPokemon.currHP = [NSNumber numberWithInt:pokemonHP];
    NSLog(@"EnemyPokemon HP: %d", pokemonHP);
  }
  else {
    moveTarget = @"MyPokemon";
    pokemonHP = [self.playerPokemon.currHP intValue];
    NSLog(@"PlayerPokemon HP: %d", pokemonHP);
    pokemonHP -= self.baseDamage;
    pokemonHP = pokemonHP > 0 ? pokemonHP : 0;
    self.playerPokemon.currHP = [NSNumber numberWithInt:pokemonHP];
    NSLog(@"PlayerPokemon HP: %d", pokemonHP);
  }
  
  // Post to |GameMenuViewController|
  NSDictionary * newUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                moveTarget, @"target", [NSNumber numberWithInt:pokemonHP], @"HP", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdatePokemonStatus object:self userInfo:newUserInfo];
  [newUserInfo release];
  
  [self endTurn];
}

@end
