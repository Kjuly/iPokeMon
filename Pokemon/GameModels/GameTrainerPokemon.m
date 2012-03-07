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
    // Base Setting
    self.pokemonBattleStatus = kPokemonBattleStatusNormal;
    
    // Data Setting
    self.trainerPokemon = [[TrainerCoreDataController sharedInstance] firstPokemonOfSix];
    self.pokemonID      = [self.trainerPokemon.sid intValue];
    self.pokemonSprite  = [CCSprite spriteWithCGImage:((UIImage *)self.trainerPokemon.pokemon.image).CGImage
                                                  key:@"TrainerPokemon"];
    [self.pokemonSprite setPosition:ccp(410, 250)];
    [self addChild:self.pokemonSprite];
    
    // Set HP
    //
    // TODO:
    //   Data Transform NSString -> NSArray
    //
//    NSLog(@"TODO: %@, %@", self.trainerPokemon.maxStats, [self.trainerPokemon.maxStats class]);
//    NSArray * maxStats;
//    if ([self.trainerPokemon.maxStats isKindOfClass:[NSString class]]) {
//      NSLog(@"!!! WARNING: self.trainerPokemon.maxStats isKindOfClass:[NSString class]");
//      NSMutableArray * maxStatsArray = [NSMutableArray arrayWithCapacity:8];
//      for (id stat in [self.trainerPokemon.maxStats componentsSeparatedByString:@","])
//        [maxStatsArray addObject:[NSNumber numberWithInt:[stat intValue]]];
//      maxStats = [[NSArray alloc] initWithArray:maxStatsArray];
//      maxStatsArray = nil;
//    }
//    else maxStats = [[NSArray alloc] initWithArray:self.trainerPokemon.maxStats];
    
//    self.hpMax = [[maxStats objectAtIndex:0] intValue];
    self.hpMax = [[self.trainerPokemon.maxStats objectAtIndex:0] intValue];
    self.hp    = [self.trainerPokemon.currHP intValue];
//    maxStats = nil;
    
    // Create Hp Bar
//    hpBar_ = [[GamePokemonHPBar alloc] initWithHP:self.hp hpMax:self.hpMax];
//    [hpBar_ setPosition:ccp(150, 220)];
//    [self addChild:hpBar_];
  }
  return self;
}

- (void)update:(ccTime)dt
{
  [super update:dt];
}

@end
