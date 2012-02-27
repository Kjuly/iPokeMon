//
//  GameTrainerPokemon.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameTrainerPokemon.h"

#import "TrainerCoreDataController.h"

@interface GameTrainerPokemon () {
 @private
  TrainerTamedPokemon * trainerPokemon_;
}

@property (nonatomic, retain) TrainerTamedPokemon * trainerPokemon;

@end

@implementation GameTrainerPokemon

@synthesize trainerPokemon = trainerPokemon_;

- (id)init
{
  if (self = [super init]) {
    self.trainerPokemon = [[TrainerCoreDataController sharedInstance] firstPokemonOfSix];
    self.pokemonSprite = [CCSprite spriteWithCGImage:((UIImage *)self.trainerPokemon.pokemon.image).CGImage key:@"TrainerPokemon"];
    [self.pokemonSprite setPosition:ccp(410, 300)];
    [self addChild:self.pokemonSprite];
    
    // Set HP
    self.hpMax = [[self.trainerPokemon.maxStats objectAtIndex:0] intValue];
    self.hp    = [self.trainerPokemon.currHP intValue];
    
    // Create Hp Bar
    hpBar_ = [[GamePokemonHPBar alloc] initWithHp:self.hp hpMax:self.hpMax];
    [hpBar_ setPosition:ccp(150, 300)];
    [self addChild:hpBar_];
  }
  return self;
}

@end
