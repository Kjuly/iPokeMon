//
//  GameBattleLayer.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameBattleLayer.h"

#import "Pokemon+DataController.h"


@implementation GameBattleLayer

@synthesize pokemonData = pokemonData_;
@synthesize pokemon     = pokemon_;

+ (CCScene *)scene
{
  // |scene| & |layer| are autorelease objects
  // 'layer' is an autorelease object.
	CCScene * scene = [CCScene node];
	GameBattleLayer * layer = [GameBattleLayer node];
	
	// add |layer| as a child to |scene|
	[scene addChild:layer];
	
	return scene;
}

- (void)dealloc
{
  [pokemonData_ release];
  self.pokemonData = nil;
  
  [super dealloc];
}

- (id)init
{
  if (self = [super initWithColor:ccc4(255,255,255,255)]) {
    [self setIsTouchEnabled:YES];
    
    self.pokemonData = [Pokemon queryPokemonDataWithID:1];
    self.pokemon = [CCSprite spriteWithCGImage:((UIImage *)self.pokemonData.image).CGImage key:@"Pokemon"];
    [self.pokemon setPosition:ccp(-90, 430)];
    [self addChild:self.pokemon];
  }
  return self;
}



- (void)registerWithTouchDispatcher {
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  CGPoint location = [self convertTouchToNodeSpace:touch];
  [self.pokemon runAction:[CCMoveTo actionWithDuration:1 position:location]];
}

@end
