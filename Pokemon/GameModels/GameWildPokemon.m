//
//  GameWildPokemon.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameWildPokemon.h"

#import "WildPokemon+DataController.h"
#import "Pokemon.h"


@interface GameWildPokemon () {
 @private
  WildPokemon * wildPokemon_;
}

@property (nonatomic, retain) WildPokemon * wildPokemon;

@end

@implementation GameWildPokemon

@synthesize wildPokemon = wildPokemon_;

- (void)dealloc
{
  [super dealloc];
}

- (id)initWithPokemonID:(NSInteger)pokemonID keyName:(NSString *)keyName
{
  if (self = [super init]) {
    // Base Setting
    self.pokemonBattleStatus = kPokemonBattleStatusNormal;
    
    // Data Setting
    self.wildPokemon = [WildPokemon queryPokemonDataWithID:pokemonID];
    self.pokemonSprite = [CCSprite spriteWithCGImage:((UIImage *)self.wildPokemon.pokemon.image).CGImage key:keyName];
    [self.pokemonSprite setPosition:ccp(-90, 380)];
    [self addChild:self.pokemonSprite];
    
    // Set HP
    self.hpMax = [[self.wildPokemon.maxStats objectAtIndex:0] intValue];
    self.hp    = self.hpMax;
    
    // Create Hp Bar
    hpBar_ = [[GamePokemonHPBar alloc] initWithHP:self.hp hpMax:self.hpMax];
    [hpBar_ setPosition:ccp(10, 380)];
    [self addChild:hpBar_];
  }
  return self;
}

- (void)update:(ccTime)dt
{
  [super update:dt];
}

#pragma mark - Wild Pokemon's Move Attack

- (void)attack
{
  
}

@end
