//
//  GamePokemonHPBar.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GamePokemonHPBar.h"


@implementation GamePokemonHPBar

@synthesize hpMaxBar = hpMaxBar_;
@synthesize hpBar    = hpBar_;

- (void)dealloc
{
  self.hpMaxBar = nil;
  self.hpBar    = nil;
  
  [super dealloc];
}

- (id)initWithHp:(NSInteger)hp hpMax:(NSInteger)hpMax
{
  if (self = [super init]) {
    self.hpMaxBar = [CCSprite spriteWithFile:@"hpMaxBar.png"];
    [self.hpMaxBar setPosition:ccp(0, 9)];
    [self.hpMaxBar setAnchorPoint:ccp(0, 0)];
    [self addChild:self.hpMaxBar];
    
    self.hpBar = [CCSprite spriteWithFile:@"hpBar.png"];
    [self.hpBar setScaleX:(float)hp / (float)hpMax];
    [self.hpBar setPosition:ccp(0, 9)];
    [self.hpBar setAnchorPoint:ccp(0, 0)];
    [self addChild:self.hpBar];
  }
  return self;
}

@end
