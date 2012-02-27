//
//  GameWildPokemon.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameWildPokemon.h"

#import "Pokemon+DataController.h"


@interface GameWildPokemon () {
 @private
  Pokemon * wildPokemon_;
}

@property (nonatomic, retain) Pokemon * wildPokemon;

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
    self.wildPokemon = [Pokemon queryPokemonDataWithID:pokemonID];
    self.pokemonSprite = [CCSprite spriteWithCGImage:((UIImage *)self.wildPokemon.image).CGImage key:keyName];
    [self.pokemonSprite setPosition:ccp(-90, 380)];
    [self addChild:self.pokemonSprite];
    
    // Set HP
    self.hpMax = [[self.wildPokemon.baseStats objectAtIndex:0] intValue];
    self.hp    = self.hpMax;
    
    // Create Hp Bar
    hpBar_ = [[GamePokemonHPBar alloc] initWithHp:self.hp hpMax:self.hpMax];
    [hpBar_ setPosition:ccp(10, 380)];
    [self addChild:hpBar_];
  }
  return self;
}

@end
