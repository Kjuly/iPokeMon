//
//  WildPokemonController.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "WildPokemonController.h"

@implementation WildPokemonController

// Singleton
static WildPokemonController * wildPokemonController_ = nil;
+ (WildPokemonController *)sharedInstance {
  if (wildPokemonController_ != nil)
    return wildPokemonController_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    wildPokemonController_ = [[WildPokemonController alloc] init];
  });
  return wildPokemonController_;
}

- (id)init {
  if (self = [super init]) {
  }
  return self;
}

@end
