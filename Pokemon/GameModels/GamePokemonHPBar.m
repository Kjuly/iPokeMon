//
//  GamePokemonHPBar.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GamePokemonHPBar.h"


@interface GamePokemonHPBar () {
 @private
  int oldHP_;
  int oldHPMax_;
}

@property (nonatomic, assign) int oldHP;
@property (nonatomic, assign) int oldHPMax;

@end

@implementation GamePokemonHPBar

@synthesize hpMaxBar = hpMaxBar_;
@synthesize hpBar    = hpBar_;

@synthesize oldHP    = oldHP_;
@synthesize oldHPMax = oldHPMax_;

- (void)dealloc
{
  self.hpMaxBar = nil;
  self.hpBar    = nil;
  
  [super dealloc];
}

- (id)initWithHP:(int)hp hpMax:(int)hpMax
{
  if (self = [super init]) {
    self.oldHP    = hp;
    self.oldHPMax = hpMax;
    
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

- (void)update:(ccTime)dt withCurrntHP:(NSInteger)currHP currentHPMax:(int)currHPMax
{
  if (currHP < self.oldHP)
    [self.hpBar setScaleX:(float)(--self.oldHP) / (float)self.oldHPMax];
  else if (currHP > self.oldHP)
    [self.hpBar setScaleX:(float)(++self.oldHP) / (float)self.oldHPMax];
  
  if (currHPMax > self.oldHPMax)
    self.oldHPMax = currHPMax;
}

@end
