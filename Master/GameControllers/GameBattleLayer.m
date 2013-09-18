//
//  GameBattleLayer.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameBattleLayer.h"

#import "PMAudioPlayer.h"
#import "GameStatusMachine.h"
#import "GameSystemProcess.h"
#import "GamePlayerProcess.h"
#import "GameEnemyProcess.h"
#import "GamePokemonSprite.h"
#import "TrainerController.h"
#import "WildPokemonController.h"


@interface GameBattleLayer () {
 @private
  PMAudioPlayer     * audioPlayer_;
  TrainerController * trainer_;
  GameStatusMachine * gameStatusMachine_;
  GameSystemProcess * gameSystemProcess_;
  GamePlayerProcess * playerProcess_;
  GameEnemyProcess  * enemyProcess_;
  CCSprite          * background_;
  CCSprite          * playerPokemonPoint_;
  CCSprite          * enemyPokemonPoint_;
  GamePokemonSprite * playerPokemonSprite_;
  GamePokemonSprite * enemyPokemonSprite_;
}

@property (nonatomic, strong) PMAudioPlayer     * audioPlayer;
@property (nonatomic, strong) TrainerController * trainer;
@property (nonatomic, strong) GameStatusMachine * gameStatusMachine;
@property (nonatomic, strong) GameSystemProcess * gameSystemProcess;
@property (nonatomic, strong) GamePlayerProcess * playerProcess;
@property (nonatomic, strong) GameEnemyProcess  * enemyProcess;
@property (nonatomic, strong) CCSprite          * background;
@property (nonatomic, strong) CCSprite          * playerPokemonPoint;
@property (nonatomic, strong) CCSprite          * enemyPokemonPoint;
@property (nonatomic, strong) GamePokemonSprite * playerPokemonSprite;
@property (nonatomic, strong) GamePokemonSprite * enemyPokemonSprite;

- (void)_setupNotificationObservers;
- (void)_createNewSceneWithWildPokemon:(WildPokemon *)wildPokemon;
- (void)_startGameLoop;
- (void)_runBattleBeginAnimation;
- (void)_replacePlayerPokemon:(NSNotification *)notification;
- (void)_getWildPokemonIntoPokeball:(NSNotification *)notification;
- (void)_getWildPokemonOutOfPokeball:(NSNotification *)notification;
- (void)_playerPokemonFaint:(NSNotification *)notification;
- (void)_enemyPokemonFaint:(NSNotification *)notification;
- (void)_loadNewPokemon;
- (void)_endGameBattle:(NSNotification *)notification;

@end


@implementation GameBattleLayer

@synthesize gameMoveEffect  = gameMoveEffect_;

@synthesize audioPlayer         = audioPlayer_;
@synthesize trainer             = trainer_;
@synthesize gameStatusMachine   = gameStatusMachine_;
@synthesize gameSystemProcess   = gameSystemProcess_;
@synthesize playerProcess       = playerProcess_;
@synthesize enemyProcess        = enemyProcess_;
@synthesize background          = background_;
@synthesize playerPokemonPoint  = playerPokemonPoint_;
@synthesize enemyPokemonPoint   = enemyPokemonPoint_;
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
  // Remove observer
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
  if (self = [super initWithColor:ccc4(0,0,0,0)]) {
    [self setIsTouchEnabled:YES];
    
    // Status Machine for Game
    self.audioPlayer       = [PMAudioPlayer     sharedInstance];
    self.trainer           = [TrainerController sharedInstance];
    self.gameStatusMachine = [GameStatusMachine sharedInstance];
    self.gameSystemProcess = [GameSystemProcess sharedInstance];
    
    // Create a new scene
    // Generate a Wild Pokemon as the appeared Pokemon
#ifdef KY_DEFAULT_VIEW_GAME_BATTLE_ON
    [self _createNewSceneWithWildPokemon:[WildPokemon queryPokemonDataWithUID:8]];
#else
    [self _createNewSceneWithWildPokemon:[[WildPokemonController sharedInstance] appearedPokemon]];
#endif
    
    // Setup notification observers
    [self _setupNotificationObservers];
    
    // check whether a selector is scheduled. schedules the "update" method.
    // It will use the order number 0.
    // This method will be called every frame.
    // Scheduled methods with a lower order value will be called before the ones that have a higher order value.
    // Only one "udpate" method could be scheduled per node.
    [self scheduleUpdate];
  }
  return self;
}

#pragma mark - Private Method

// Setup notification observers
- (void)_setupNotificationObservers
{
  NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
  // Add observer for notification to replace player, enemy's pokemon
  [notificationCenter addObserver:self
                         selector:@selector(_replacePlayerPokemon:)
                             name:kPMNReplacePlayerPokemon
                           object:nil];
  // Notification from |GameMenuViewController| - |animationDidStop:finished:|
  [notificationCenter addObserver:self
                         selector:@selector(_getWildPokemonIntoPokeball:)
                             name:kPMNPokeballGetWildPokemon
                           object:nil];
  // Notification from |GameSystemProcess| - |caughtWildPokemonSucceed:| if |succeed == NO|
  [notificationCenter addObserver:self
                         selector:@selector(_getWildPokemonOutOfPokeball:)
                             name:kPMNPokeballLossWildPokemon
                           object:nil];
  // Notifications from |GameSystemProcess| - |calculateEffectForMove|
  [notificationCenter addObserver:self
                         selector:@selector(_playerPokemonFaint:)
                             name:kPMNPlayerPokemonFaint
                           object:nil];
  [notificationCenter addObserver:self
                         selector:@selector(_enemyPokemonFaint:)
                             name:kPMNEnemyPokemonFaint
                           object:nil];
  // Notification from |GameBattleEndViewController| when it's view did load
  [notificationCenter addObserver:self
                         selector:@selector(_endGameBattle:)
                             name:kPMNGameBattleEnd
                           object:nil];
}

// Generate a new scene with Wild Pokemon
- (void)_createNewSceneWithWildPokemon:(WildPokemon *)wildPokemon
{
  NSLog(@"Generating a new scene......");
  NSInteger currentBattleAblePokemonIndex = [self.trainer battleAvailablePokemonIndex];
  TrainerTamedPokemon * playerPokemon = [self.trainer pokemonOfSixAtIndex:currentBattleAblePokemonIndex];
  WildPokemon * enemyPokemon          = wildPokemon;
  
  // Update PokeDEX for trainer
  [self.trainer updatePokedexWithPokemonSID:[enemyPokemon.sid intValue]];
  
  NSLog(@"New WILD POKEMON:moves:%@, hp:%@, exp:%@, stats:%@",
        enemyPokemon.fourMoves, enemyPokemon.hp, enemyPokemon.exp, enemyPokemon.maxStats);
  
  // Set pokemon for |gameSystemProcess_|
  self.gameSystemProcess.playerPokemon = playerPokemon;
  self.gameSystemProcess.enemyPokemon  = enemyPokemon;
  
  
  GamePlayerProcess * playerProcess = [[GamePlayerProcess alloc] init];
  self.playerProcess = playerProcess;
  
  GameEnemyProcess * enemyProcess = [[GameEnemyProcess alloc] init];
  self.enemyProcess = enemyProcess;
  
  // Game battle scene's background
  NSString * backgroundImageName =
  [NSString stringWithFormat:kPMINBattleSceneBackground, [enemyPokemon.pokemon.habitat intValue]];
  self.background = [CCSprite spriteWithFile:backgroundImageName];
  [self.background setPosition:
    ccp(kViewWidth * .5f, kGameBattleSceneBackgroundHeight * .5f + kGameMenuBattleLogViewHeight)];
  [self addChild:self.background];
  
  // Pokemons' Points
//  CGRect pokemonPointFrame = CGRectMake(0.f, 0.f, kGameBattlePlayerPMPointWidth, kGameBattlePlayerPMPointHeight);
  self.playerPokemonPoint = [CCSprite spriteWithFile:kPMINBattleScenePMPoint];
  self.enemyPokemonPoint  = [CCSprite spriteWithFile:kPMINBattleScenePMPoint];
//  self.playerPokemonPoint = [CCSprite spriteWithFile:kPMINBattleScenePMPoint rect:pokemonPointFrame];
//  self.enemyPokemonPoint  = [CCSprite spriteWithFile:kPMINBattleScenePMPoint rect:pokemonPointFrame];
  [self.playerPokemonPoint setPosition:ccp(kGameBattlePlayerPMPointPosX, kGameBattlePlayerPMPointPosY)];
  [self.enemyPokemonPoint  setPosition:ccp(kGameBattleEnemyPMPointPosX,  kGameBattleEnemyPMPointPosY)];
  [self addChild:self.playerPokemonPoint];
  [self addChild:self.enemyPokemonPoint];
  
  // Player & Enemy's Pokemon sprite setting
  // Player Pokemon sprite setting
  NSString * spriteKeyPlayerPokemon =
  [NSString stringWithFormat:@"SpriteKeyPlayerPokemon%.3d", [playerPokemon.sid intValue]];
  GamePokemonSprite * playerPokemonSprite =
  [[GamePokemonSprite alloc] initWithCGImage:((UIImage *)playerPokemon.pokemon.imageBack).CGImage
                                         key:spriteKeyPlayerPokemon];
  self.playerPokemonSprite = playerPokemonSprite;
  [self.playerPokemonSprite setPosition:ccp(kGameBattlePlayerPokemonPosOffsetX, kGameBattlePlayerPokemonPosY)];
  [self.playerPokemonSprite setStatus:kGamePokemonStatusNormal];
  [self addChild:self.playerPokemonSprite];
  
  // Enemy Pokemon sprite setting
  NSString * spriteKeyEnemyPokemon =
  [NSString stringWithFormat:@"SpriteKeyEnemyPokemon%.3d", [enemyPokemon.sid intValue]];
  GamePokemonSprite * enemyPokemonSprite =
  [[GamePokemonSprite alloc] initWithCGImage:((UIImage *)enemyPokemon.pokemon.image).CGImage
                                         key:spriteKeyEnemyPokemon];
  self.enemyPokemonSprite = enemyPokemonSprite;
  [self.enemyPokemonSprite setPosition:ccp(kGameBattleEnemyPokemonPosOffsetX, kGameBattleEnemyPokemonPosY)];
  [self.enemyPokemonSprite setStatus:kGamePokemonStatusNormal];
  [self addChild:self.enemyPokemonSprite];
  
  playerPokemon = nil;
  enemyPokemon  = nil;
  
  // Run battle begin background music
  [self.audioPlayer playForAudioType:kAudioBattleStartVSWildPM afterDelay:0];
  [self.audioPlayer playForAudioType:kAudioBattlingVSWildPM afterDelay:2.95f];
  
  // Run battle begin animation is it's a new battle with the Pokemon
  [self _runBattleBeginAnimation];
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
      // Pass, until |_startGameLoop| was sent
    default:
      break;
  }
}

#pragma mark - Touch Handler

- (void)registerWithTouchDispatcher
{
  [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                   priority:0
                                            swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch
           withEvent:(UIEvent *)event
{
  return YES;
}

- (void)ccTouchEnded:(UITouch *)touch
           withEvent:(UIEvent *)event
{
//  CGPoint location = [self convertTouchToNodeSpace:touch];
//  [self.gameWildPokemon.pokemonSprite runAction:[CCMoveTo actionWithDuration:1 position:location]];
}

#pragma mark - Private Methods

// Start game loop
- (void)_startGameLoop
{
  // Post notification to |GamePokemonStatusViewController| to show pokemon status view
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNShowPokemonStatus
                                                      object:self
                                                    userInfo:nil];
  // Set game play to ready
  [self.gameStatusMachine startNewTurn];
}

// Battle Begin Animation
- (void)_runBattleBeginAnimation
{
  // Battle begin animation
  [self.playerPokemonSprite runAction:
    [CCMoveTo actionWithDuration:1.5f position:ccp(kGameBattlePlayerPokemonPosX, kGameBattlePlayerPokemonPosY)]];
  [self.enemyPokemonSprite  runAction:
    [CCMoveTo actionWithDuration:1.5f position:ccp(kGameBattleEnemyPokemonPosX, kGameBattleEnemyPokemonPosY)]];
  
  // Start game loop after some time delay (waiting the animation done)
  [self performSelector:@selector(_startGameLoop) withObject:nil afterDelay:2.f];
}

// Replace player's pokemon image
- (void)_replacePlayerPokemon:(NSNotification *)notification
{
  [self.playerPokemonSprite removeFromParentAndCleanup:YES];
  self.playerPokemonSprite = nil;
  
  NSInteger newPokemon = [[notification.userInfo objectForKey:@"newPokemon"] intValue];
  TrainerTamedPokemon * playerPokemon = [[self.trainer sixPokemons] objectAtIndex:newPokemon];
  [self.gameSystemProcess replacePokemon:playerPokemon forUser:kGameSystemProcessUserPlayer];
  
  NSString * spriteKeyPlayerPokemon = [NSString stringWithFormat:@"SpriteKeyPlayerPokemon%.3d",
                                       [playerPokemon.sid intValue]];
  GamePokemonSprite * playerPokemonSprite =
    [[GamePokemonSprite alloc] initWithCGImage:((UIImage *)playerPokemon.pokemon.imageBack).CGImage
                                           key:spriteKeyPlayerPokemon];
  self.playerPokemonSprite = playerPokemonSprite;
  playerPokemon = nil;
  [self.playerPokemonSprite setPosition:ccp(kGameBattlePlayerPokemonPosX, kGameBattlePlayerPokemonPosY)];
  [self.playerPokemonSprite setStatus:kGamePokemonStatusNormal];
  [self addChild:self.playerPokemonSprite];
  
  [self.playerPokemonSprite setOpacity:0];
  [self performSelector:@selector(_loadNewPokemon) withObject:nil afterDelay:1.2f];
}

// Get WildPokemon into Pokeball
- (void)_getWildPokemonIntoPokeball:(NSNotification *)notification
{
  NSLog(@"get Wild Pokemon into Pokeball");
  [self.enemyPokemonSprite runAction:[CCActionTween actionWithDuration:.3f key:@"opacity" from:255 to:0]];
}

// Get WildPokemon out of Pokeball
- (void)_getWildPokemonOutOfPokeball:(NSNotification *)notification
{
  NSLog(@"get Wild Pokemon out of Pokeball");
  [self.enemyPokemonSprite runAction:[CCActionTween actionWithDuration:.3f key:@"opacity" from:0 to:255]];
}

// Player's Pokemon FAINT
- (void)_playerPokemonFaint:(NSNotification *)notification
{
  [self.playerPokemonSprite runAction:
    [CCMoveTo actionWithDuration:.3f
                        position:ccp(kGameBattlePlayerPokemonPosX,
                                     kGameBattlePlayerPokemonPosY - kGameBattlePokemonFaintedOffsetY)]];
  [self.playerPokemonSprite runAction:[CCActionTween actionWithDuration:.3f
                                                                    key:@"opacity"
                                                                   from:255
                                                                     to:0]];
}

// Enemy's Pokemon (or WildPokemon) FAINT
- (void)_enemyPokemonFaint:(NSNotification *)notification
{
  [self.enemyPokemonSprite runAction:
    [CCMoveTo actionWithDuration:.3f position:ccp(kGameBattleEnemyPokemonPosX,
                                                  kGameBattleEnemyPokemonPosY - kGameBattlePokemonFaintedOffsetY)]];
  [self.enemyPokemonSprite runAction:[CCActionTween actionWithDuration:.3f
                                                                   key:@"opacity"
                                                                  from:255
                                                                    to:0]];
}

// Load new pokemon
- (void)_loadNewPokemon
{
  [self.playerPokemonSprite runAction:[CCActionTween actionWithDuration:.3f
                                                                    key:@"opacity"
                                                                   from:0
                                                                     to:255]];
}

// END Game Battle
- (void)_endGameBattle:(NSNotification *)notification
{
  [self.playerPokemonSprite setPosition:ccp(kGameBattlePlayerPokemonPosOffsetX, kGameBattlePlayerPokemonPosY)];
  [self.enemyPokemonSprite  setPosition:ccp(kGameBattleEnemyPokemonPosOffsetX, kGameBattleEnemyPokemonPosY)];
}

@end
