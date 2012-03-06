//
//  GameBattleLayer.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameBattleLayer.h"

#import "GameWildPokemon.h"
#import "GameTrainerPokemon.h"
#import "GameMoveEffect.h"


@interface GameBattleLayer () {  
 @private
  BOOL isReadyToPlay_;
}

@property (nonatomic, assign) BOOL isReadyToPlay;

- (void)generateNewSceneWithWildPokemonID:(NSInteger)wildPokemonID;
- (void)runBattleBeginAnimation;

@end


@implementation GameBattleLayer

@synthesize gameWildPokemon    = gameWildPoekmon_;
@synthesize gameTrainerPokemon = gameTrainerPokemon_;
@synthesize gameMoveEffect     = gameMoveEffect_;

@synthesize isReadyToPlay      = isReadyToPlay_;

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
//  [gameWildPoekmon_    release];
//  [gameTrainerPokemon_ release];
//  [gameMoveEffect_     release];
  
  self.gameWildPokemon    = nil;
  self.gameTrainerPokemon = nil;
  self.gameMoveEffect     = nil;
  
  [super dealloc];
}

- (id)init
{
  if (self = [super initWithColor:ccc4(255,255,255,255)]) {
    [self setIsTouchEnabled:YES];
    
    [self generateNewSceneWithWildPokemonID:8];
    self.isReadyToPlay = NO;
    
    // check whether a selector is scheduled. schedules the "update" method.
    // It will use the order number 0.
    // This method will be called every frame.
    // Scheduled methods with a lower order value will be called before the ones that have a higher order value.
    // Only one "udpate" method could be scheduled per node.
    [self scheduleUpdate];
  }
  return self;
}

// Generate a new scene
- (void)generateNewSceneWithWildPokemonID:(NSInteger)wildPokemonID
{
  NSLog(@"Generating a new scene......");
  // Wild Pokemon Node
  GameWildPokemon * gameWildPoekmon = [[GameWildPokemon alloc] initWithPokemonID:wildPokemonID keyName:@"Pokemom"];
  self.gameWildPokemon = gameWildPoekmon;
  [gameWildPoekmon release];
  [self addChild:self.gameWildPokemon];
  NSLog(@"HP: %d / %d", self.gameWildPokemon.hp, self.gameWildPokemon.hpMax);
  
  // Trainer's Pokemon Node
  GameTrainerPokemon * gameTrainerPokemon = [[GameTrainerPokemon alloc] init];
  self.gameTrainerPokemon = gameTrainerPokemon;
  [gameTrainerPokemon release];
  [self addChild:self.gameTrainerPokemon];
  NSLog(@"HP: %d / %d", self.gameTrainerPokemon.hp, self.gameTrainerPokemon.hpMax);
  
  // Create Move Effect Object
  gameMoveEffect_ = [[GameMoveEffect alloc] initWithwildPokemon:gameWildPoekmon_ trainerPokemon:gameTrainerPokemon_];
  [self addChild:gameMoveEffect_ z:9999];
  
  // Run battle begin animation is it's a new battle with the Pokemon
  [self runBattleBeginAnimation];
}

// The method to be scheduled
- (void)update:(ccTime)dt
{
  // Update Wild Pokemon & Trainer Pokemon
  [self.gameWildPokemon    update:dt];
  [self.gameTrainerPokemon update:dt];
}

#pragma mark - Touch Handler

- (void)registerWithTouchDispatcher {
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
  CGPoint location = [self convertTouchToNodeSpace:touch];
  [self.gameWildPokemon.pokemonSprite runAction:[CCMoveTo actionWithDuration:1 position:location]];
}

#pragma mark - Private Methods

// Battle Begin Animation
- (void)runBattleBeginAnimation
{
  // Battle begin animation
  [self.gameWildPokemon.pokemonSprite    runAction:[CCMoveTo actionWithDuration:1.5 position:ccp(220, 380)]];
  [self.gameTrainerPokemon.pokemonSprite runAction:[CCMoveTo actionWithDuration:1.5 position:ccp(100, 300)]];
  
  // Set game play to ready
  self.isReadyToPlay = YES;
}

@end
