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

- (void)dealloc
{
  [super dealloc];
}

- (id)init
{
  if (self = [super init]) {
    
  }
  return self;
}

@end
