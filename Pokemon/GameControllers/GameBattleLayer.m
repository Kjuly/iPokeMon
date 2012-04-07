//
//  GameBattleLayer.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameBattleLayer.h"

#import "GlobalNotificationConstants.h"
#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "GamePlayerProcess.h"
#import "GameEnemyProcess.h"
#import "GamePokemonSprite.h"
#import "TrainerController.h"
#import "WildPokemon+DataController.h"


@interface GameBattleLayer () {
 @private
  GameStatusMachine * gameStatusMachine_;
  GameSystemProcess * gameSystemProcess_;
  GamePlayerProcess * playerProcess_;
  GameEnemyProcess  * enemyProcess_;
  GamePokemonSprite * playerPokemonSprite_;
  GamePokemonSprite * enemyPokemonSprite_;
}

@property (nonatomic, retain) GameStatusMachine * gameStatusMachine;
@property (nonatomic, retain) GameSystemProcess * gameSystemProcess;
@property (nonatomic, retain) GamePlayerProcess * playerProcess;
@property (nonatomic, retain) GameEnemyProcess  * enemyProcess;
@property (nonatomic, retain) GamePokemonSprite * playerPokemonSprite;
@property (nonatomic, retain) GamePokemonSprite * enemyPokemonSprite;

- (void)createNewSceneWithWildPokemonID:(NSInteger)wildPokemonID;
- (void)startGameLoop;
- (void)runBattleBeginAnimation;
- (void)replacePlayerPokemon:(NSNotification *)notification;
- (void)getWildPokemonIntoPokeball:(NSNotification *)notification;
- (void)getWildPokemonOutOfPokeball:(NSNotification *)notification;
- (void)loadNewPokemon;

@end


@implementation GameBattleLayer

@synthesize gameMoveEffect  = gameMoveEffect_;

@synthesize gameStatusMachine   = gameStatusMachine_;
@synthesize gameSystemProcess   = gameSystemProcess_;
@synthesize playerProcess       = playerProcess_;
@synthesize enemyProcess        = enemyProcess_;
@synthesize playerPokemonSprite = playerPokemonSprite_;
@synthesize enemyPokemonSprite  = enemyPokemonSprite_;

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
  self.playerProcess       = nil;
  self.enemyProcess        = nil;
  self.playerPokemonSprite = nil;
  self.enemyPokemonSprite  = nil;
  
  // Remove observer
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNReplacePlayerPokemon object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNPokeballGetWildPokemon object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNPokeballLossWildPokemon object:nil];
  [super dealloc];
}

- (id)init
{
  if (self = [super initWithColor:ccc4(0,0,0,0)]) {
    [self setIsTouchEnabled:YES];
    
    // Status Machine for Game
    self.gameStatusMachine = [GameStatusMachine sharedInstance];
    self.gameSystemProcess = [GameSystemProcess sharedInstance];
    
    // Create a new scene
    [self createNewSceneWithWildPokemonID:8];
    
    // Add observer for notification to replace player, enemy's pokemon
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replacePlayerPokemon:)
                                                 name:kPMNReplacePlayerPokemon
                                               object:nil];
    // Notification from |GameMenuViewController| - |animationDidStop:finished:|
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getWildPokemonIntoPokeball:)
                                                 name:kPMNPokeballGetWildPokemon
                                               object:nil];
    // Notification from |GameSystemProcess| - |caughtWildPokemonSucceed:| if |succeed == NO|
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getWildPokemonOutOfPokeball:)
                                                 name:kPMNPokeballLossWildPokemon
                                               object:nil];
    
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
  TrainerTamedPokemon * playerPokemon = [[TrainerController sharedInstance] firstPokemonOfSix];
  WildPokemon * enemyPokemon  = [WildPokemon queryPokemonDataWithID:wildPokemonID];
  
  // Set pokemon for |gameSystemProcess_|
  self.gameSystemProcess.playerPokemon = playerPokemon;
  self.gameSystemProcess.enemyPokemon  = enemyPokemon;
  
  
  GamePlayerProcess * playerProcess = [[GamePlayerProcess alloc] init];
  self.playerProcess = playerProcess;
  [playerProcess release];
  
  GameEnemyProcess * enemyProcess = [[GameEnemyProcess alloc] init];
  self.enemyProcess = enemyProcess;
  [enemyProcess release];
  
  // Player pokemon sprite setting
  NSString * spriteKeyPlayerPokemon = [NSString stringWithFormat:@"SpriteKeyPlayerPokemon%.3d",
                                      [playerPokemon.sid intValue]];
  GamePokemonSprite * playerPokemonSprite
  = [[GamePokemonSprite alloc] initWithCGImage:((UIImage *)playerPokemon.pokemon.image).CGImage
                                           key:spriteKeyPlayerPokemon];
  self.playerPokemonSprite = playerPokemonSprite;
  [playerPokemonSprite release];
  [self.playerPokemonSprite setPosition:ccp(410, 250)];
  [self.playerPokemonSprite setStatus:kGamePokemonStatusNormal];
  [self addChild:self.playerPokemonSprite];
  
  // Enemy pokemon sprite setting
  NSString * spriteKeyEnemyPokemon = [NSString stringWithFormat:@"SpriteKeyEnemyPokemon%.3d",
                                      [enemyPokemon.sid intValue]];
  GamePokemonSprite * enemyPokemonSprite =
  [[GamePokemonSprite alloc] initWithCGImage:((UIImage *)enemyPokemon.pokemon.image).CGImage
                                         key:spriteKeyEnemyPokemon];
  self.enemyPokemonSprite = enemyPokemonSprite;
  [enemyPokemonSprite release];
  [self.enemyPokemonSprite setPosition:ccp(-90, 350)];
  [self.enemyPokemonSprite setStatus:kGamePokemonStatusNormal];
  [self addChild:self.enemyPokemonSprite];
  
  playerPokemon = nil;
  enemyPokemon  = nil;
  
  // Run battle begin animation is it's a new battle with the Pokemon
  [self runBattleBeginAnimation];
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
      [self.playerProcess reset];
      break;
      
    case kGameStatusPlayerTurn:
      [self.playerProcess update:dt];
      break;
      
    case kGameStatusEnemyTurn:
      [self.enemyProcess update:dt];
      break;
      
    case kGameStatusInitialization:
      // Pass, until |startGameLoop| was sent
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

// Start game loop
- (void)startGameLoop
{
  // Post notification to show pokemon status view
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNShowPokemonStatus object:self userInfo:nil];
  // Set game play to ready
  [self.gameStatusMachine startNewTurn];
}

// Battle Begin Animation
- (void)runBattleBeginAnimation
{
  // Battle begin animation
  [self.playerPokemonSprite runAction:[CCMoveTo actionWithDuration:1.5f position:ccp(70, 250)]];
  [self.enemyPokemonSprite  runAction:[CCMoveTo actionWithDuration:1.5f position:ccp(250, 350)]];
  
  // Start game loop after some time delay (waiting the animation done)
  [self performSelector:@selector(startGameLoop) withObject:nil afterDelay:2.f];
}

// Replace player's pokemon image
- (void)replacePlayerPokemon:(NSNotification *)notification
{
  [self.playerPokemonSprite removeFromParentAndCleanup:YES];
  self.playerPokemonSprite = nil;
  
  NSInteger newPokemon = [[notification.userInfo objectForKey:@"newPokemon"] intValue];
  TrainerTamedPokemon * playerPokemon =
    [[[TrainerController sharedInstance] sixPokemons] objectAtIndex:newPokemon];
  [GameSystemProcess sharedInstance].playerPokemon = playerPokemon;
  
  NSString * spriteKeyPlayerPokemon = [NSString stringWithFormat:@"SpriteKeyPlayerPokemon%.3d",
                                       [playerPokemon.sid intValue]];
  GamePokemonSprite * playerPokemonSprite =
    [[GamePokemonSprite alloc] initWithCGImage:((UIImage *)playerPokemon.pokemon.image).CGImage
                                           key:spriteKeyPlayerPokemon];
  self.playerPokemonSprite = playerPokemonSprite;
  [playerPokemonSprite release];
  playerPokemon = nil;
  [self.playerPokemonSprite setPosition:ccp(70, 250)];
  [self.playerPokemonSprite setStatus:kGamePokemonStatusNormal];
  [self addChild:self.playerPokemonSprite];
  
  [self.playerPokemonSprite setOpacity:0];
  [self performSelector:@selector(loadNewPokemon) withObject:nil afterDelay:1.2f];
}

// Get WildPokemon into Pokeball
- (void)getWildPokemonIntoPokeball:(NSNotification *)notification {
  NSLog(@"|%@| - |getWildPokemonIntoPokeball:|", [self class]);
  [self.enemyPokemonSprite runAction:[CCActionTween actionWithDuration:.3f key:@"opacity" from:255 to:0]];
}

// Get WildPokemon out of Pokeball
- (void)getWildPokemonOutOfPokeball:(NSNotification *)notification {
  NSLog(@"|%@| - |getWildPokemonOutOfPokeball:|", [self class]);
  [self.enemyPokemonSprite runAction:[CCActionTween actionWithDuration:.3f key:@"opacity" from:0 to:255]];
}

// Load new pokemon
- (void)loadNewPokemon {
  [self.playerPokemonSprite runAction:[CCActionTween actionWithDuration:.3f key:@"opacity" from:0 to:255]];
}

@end
