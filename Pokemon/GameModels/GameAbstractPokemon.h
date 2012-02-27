//
//  GameAbstractPokemon.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GamePokemonHPBar.h"

typedef enum {
  kPokemonBattleStatusNormal    = 0,
  kPokemonBattleStatusPoisoning = 1 << 0,
  kPokemonBattleStatusBurn      = 1 << 1
}PokemonBattleStatus;

@interface GameAbstractPokemon : CCNode {
  CCSprite * pokemonSprite_;
  int        hp_;
  int        hpMax_;
  GamePokemonHPBar * hpBar_;
  PokemonBattleStatus pokemonBattleStatus_;
}

@property (nonatomic, retain) CCSprite * pokemonSprite;
@property (nonatomic, assign) int        hp;
@property (nonatomic, assign) int        hpMax;
@property (nonatomic, retain) GamePokemonHPBar * hpBar;
@property (nonatomic, assign) PokemonBattleStatus pokemonBattleStatus;

- (void)update:(ccTime)dt;
- (void)newTurn;

@end
