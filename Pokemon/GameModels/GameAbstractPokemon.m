//
//  GameAbstractPokemon.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameAbstractPokemon.h"


@implementation GameAbstractPokemon

@synthesize pokemonSprite = pokemonSprite_;
@synthesize hp            = hp_;
@synthesize hpMax         = hpMax_;
@synthesize hpBar         = hpBar_;
@synthesize pokemonBattleStatus = pokemonBattleStatus_;

- (void)dealloc
{
  self.hpBar = nil;
  
  [super dealloc];
}

- (id)init
{
  if (self = [super init]) {
  }
  return self;
}

- (void)update:(ccTime)dt
{
  [self.hpBar update:dt withCurrntHP:self.hp currentHPMax:self.hpMax];
}

- (void)newTurn
{
  // Battle Status Damage
  if (self.pokemonBattleStatus & kPokemonBattleStatusPoisoning)
    --self.hp;
  if (self.pokemonBattleStatus & kPokemonBattleStatusBurn)
    --self.hp;
}

@end
