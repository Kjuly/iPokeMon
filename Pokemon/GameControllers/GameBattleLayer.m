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


@interface GameBattleLayer () {  
 @private
  BOOL isReadyToPlay_;
}

@property (nonatomic, assign) BOOL isReadyToPlay;

- (void)runBattleBeginAnimation;

@end


@implementation GameBattleLayer

@synthesize gameWildPokemon    = gameWildPoekmon_;
@synthesize gameTrainerPokemon = gameTrainerPokemon_;

@synthesize isReadyToPlay        = isReadyToPlay_;

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
  [gameWildPoekmon_    release];
  [gameTrainerPokemon_ release];
  
  self.gameWildPokemon    = nil;
  self.gameTrainerPokemon = nil;
  
  [super dealloc];
}

- (id)init
{
  if (self = [super initWithColor:ccc4(255,255,255,255)]) {
    [self setIsTouchEnabled:YES];
    
    // Wild Pokemon Node
    gameWildPoekmon_ = [[GameWildPokemon alloc] initWithPokemonID:1 keyName:@"Pokemom"];
    [self addChild:gameWildPoekmon_];
    NSLog(@"HP: %d / %d", gameWildPoekmon_.hp, gameWildPoekmon_.hpMax);
    
    // Trainer's Pokemon Node
    gameTrainerPokemon_ = [[GameTrainerPokemon alloc] init];
    [self addChild:gameTrainerPokemon_];
    NSLog(@"HP: %d / %d", gameTrainerPokemon_.hp, gameTrainerPokemon_.hpMax);
    
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

// The method to be scheduled
- (void)update:(ccTime)dt
{
//  NSLog(@"...Update game...");
  // Run battle begin animation is it's a new battle with the Pokemon
  if (! self.isReadyToPlay)
    [self runBattleBeginAnimation];
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
