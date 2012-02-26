//
//  GameBattleLayer.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameBattleLayer.h"

#import "Pokemon+DataController.h"


@interface GameBattleLayer () {  
 @private
  CCSprite * wildPokemon_;
  CCSprite * myPokemon_;
  BOOL isReadyToPlay_;
}

@property (nonatomic, retain) CCSprite * wildPokemon;
@property (nonatomic, retain) CCSprite * myPokemon;
@property (nonatomic, assign) BOOL isReadyToPlay;

- (void)runBattleBeginAnimation;

@end


@implementation GameBattleLayer

@synthesize pokemonData = pokemonData_;

@synthesize wildPokemon   = wildPokemon_;
@synthesize myPokemon     = myPokemon_;
@synthesize isReadyToPlay = isReadyToPlay_;

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
    self.wildPokemon = [CCSprite spriteWithCGImage:((UIImage *)self.pokemonData.image).CGImage key:@"Pokemon"];
    [self.wildPokemon setPosition:ccp(-90, 430)];
    [self addChild:self.wildPokemon];
    
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
  NSLog(@"...Update game...");
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
  [self.wildPokemon runAction:[CCMoveTo actionWithDuration:1 position:location]];
}

#pragma mark - Private Methods

// Battle Begin Animation
- (void)runBattleBeginAnimation
{
  // Battle begin animation
  [self.wildPokemon runAction:[CCMoveTo actionWithDuration:1 position:ccp(220, 380)]];
  
  // Set game play to ready
  self.isReadyToPlay = YES;
}

@end
