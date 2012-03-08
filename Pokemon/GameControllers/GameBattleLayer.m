//
//  GameBattleLayer.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameBattleLayer.h"

#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "GamePlayer.h"
#import "GameEnemy.h"
#import "GamePokemonSprite.h"
#import "TrainerCoreDataController.h"
#import "WildPokemon+DataController.h"

#import "GameMoveEffect.h"


@interface GameBattleLayer () {
 @private
  GameStatusMachine * gameStatusMachine_;
  GameSystemProcess * gameSystemProcess_;
  GamePlayer        * player_;
  GameEnemy         * enemy_;
  GamePokemonSprite * playerPokemonSprite_;
  GamePokemonSprite * enemyPokemonSprite_;
  
  TrainerTamedPokemon * playerPokemon_;
  WildPokemon         * enemyPokemon_;
}

@property (nonatomic, retain) GameStatusMachine * gameStatusMachine;
@property (nonatomic, retain) GameSystemProcess * gameSystemProcess;
@property (nonatomic, retain) GamePlayer        * player;
@property (nonatomic, retain) GameEnemy         * enemy;
@property (nonatomic, retain) GamePokemonSprite * playerPokemonSprite;
@property (nonatomic, retain) GamePokemonSprite * enemyPokemonSprite;

@property (nonatomic, retain) TrainerTamedPokemon * playerPokemon;
@property (nonatomic, retain) WildPokemon         * enemyPokemon;

- (void)createNewSceneWithWildPokemonID:(NSInteger)wildPokemonID;
- (void)runBattleBeginAnimation;

@end


@implementation GameBattleLayer

@synthesize gameMoveEffect  = gameMoveEffect_;

@synthesize gameStatusMachine   = gameStatusMachine_;
@synthesize gameSystemProcess   = gameSystemProcess_;
@synthesize player              = player_;
@synthesize enemy               = enemy_;
@synthesize playerPokemonSprite = playerPokemonSprite_;
@synthesize enemyPokemonSprite  = enemyPokemonSprite_;

@synthesize playerPokemon = playerPokemon_;
@synthesize enemyPokemon  = enemyPokemon_;

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
  self.gameMoveEffect  = nil;
  
  self.gameStatusMachine   = nil;
  self.player              = nil;
  self.enemy               = nil;
  self.playerPokemonSprite = nil;
  self.enemyPokemonSprite  = nil;
  
  self.playerPokemon = nil;
  self.enemyPokemon  = nil;
  
  [super dealloc];
}

- (id)init
{
  if (self = [super initWithColor:ccc4(255,255,255,255)]) {
    [self setIsTouchEnabled:YES];
    
    // Status Machine for Game
    self.gameStatusMachine = [GameStatusMachine sharedInstance];
    self.gameSystemProcess = [GameSystemProcess sharedInstance];
    
    // Create a new scene
    [self createNewSceneWithWildPokemonID:8];
    
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
- (void)createNewSceneWithWildPokemonID:(NSInteger)wildPokemonID
{
  NSLog(@"Generating a new scene......");
  self.playerPokemon = [[TrainerCoreDataController sharedInstance] firstPokemonOfSix];
  self.enemyPokemon  = [WildPokemon queryPokemonDataWithID:wildPokemonID];
  
  // Set pokemon for |gameSystemProcess_|
  self.gameSystemProcess.playerPokemon = self.playerPokemon;
  self.gameSystemProcess.enemyPokemon  = self.enemyPokemon;
  
  
//  GamePlayer * player = [[GamePlayer alloc] init];
//  self.player = player;
//  [player release];
//  self.player = [GamePlayer sharedInstance];
  
//  GameEnemy * enemy = [[GameEnemy alloc] init];
//  self.enemy = enemy;
//  [enemy release];
  
  // Player pokemon sprite setting
  GamePokemonSprite * playerPokemonSprite
  = [[GamePokemonSprite alloc] initWithCGImage:((UIImage *)self.playerPokemon.pokemon.image).CGImage
                                           key:@"SpriteKeyPlayerPokemon"];
  self.playerPokemonSprite = playerPokemonSprite;
  [playerPokemonSprite release];
  [self.playerPokemonSprite setPosition:ccp(410, 250)];
  [self.playerPokemonSprite setStatus:kGamePokemonStatusNormal];
  [self addChild:self.playerPokemonSprite];
  
  // Enemy pokemon sprite setting
  GamePokemonSprite * enemyPokemonSprite =
  [[GamePokemonSprite alloc] initWithCGImage:((UIImage *)self.enemyPokemon.pokemon.image).CGImage
                                         key:@"SpriteKeyEnemyPokemon"];
  self.enemyPokemonSprite = enemyPokemonSprite;
  [enemyPokemonSprite release];
  [self.enemyPokemonSprite setPosition:ccp(-90, 350)];
  [self.enemyPokemonSprite setStatus:kGamePokemonStatusNormal];
  [self addChild:self.enemyPokemonSprite];
  
    
//  // Create Move Effect Object
//  gameMoveEffect_ = [[GameMoveEffect alloc] initWithwildPokemon:gameWildPoekmon_ trainerPokemon:self.gameMyPokemon];
//  [self addChild:gameMoveEffect_ z:9999];
//  
//  // Run battle begin animation is it's a new battle with the Pokemon
//  [self runBattleBeginAnimation];
}

// The method to be scheduled
- (void)update:(ccTime)dt
{
  switch ([self.gameStatusMachine status]) {
    case kGameStatusSystemProcess:
      [self.gameSystemProcess update:dt];
      
      // Updating for Pokemons
//      [self.playerPokemonSprite update:dt];
//      [self.enemyPokemonSprite  update:dt];
      break;
      
    case kGameStatusPlayerTurn:
//      [self.player update:dt];
      break;
      
    case kGameStatusEnemyTurn:
//      [self.enemy update:dt];
      break;
      
    case kGameStatusInitialization:
      NSLog(@":: Game Status: kGameStatusInitialization");
      [self runBattleBeginAnimation];
    default:
      break;
  }
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
//  CGPoint location = [self convertTouchToNodeSpace:touch];
//  [self.gameWildPokemon.pokemonSprite runAction:[CCMoveTo actionWithDuration:1 position:location]];
}

#pragma mark - Private Methods

// Battle Begin Animation
- (void)runBattleBeginAnimation
{
  // Battle begin animation
  [self.playerPokemonSprite runAction:[CCMoveTo actionWithDuration:1.5 position:ccp(70, 250)]];
  [self.enemyPokemonSprite  runAction:[CCMoveTo actionWithDuration:1.5 position:ccp(250, 350)]];
  
  // Set game play to ready
  [self.gameStatusMachine startNewTurn];
}

@end
