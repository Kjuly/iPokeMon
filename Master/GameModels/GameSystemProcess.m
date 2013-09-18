//
//  GameSystemProcess.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameSystemProcess.h"

#import "PMAudioPlayer.h"
#import "GameStatusMachine.h"
#import "TrainerController.h"


// System Process Type
typedef enum {
  kGameSystemProcessTypeNone = 0,                  // None
  kGameSystemProcessTypeFight,                     // Fight
  kGameSystemProcessTypeUseBagItem,                // Use Bag Item
  kGameSystemProcessTypeReplacePokemon,            // Replace Pokemon
  kGameSystemProcessTypeCathingWildPokemon,        // Cathing WildPokemon
  kGameSystemProcessTypeCathingWildPokemonSucceed, // Cathing WildPokemon Succeed
  kGameSystemProcessTypeCathingWildPokemonFailed,  // Cathing WildPokemon Failed
  kGameSystemProcessTypePlayerPokemonFaint,        // Player Pokemon FAINT
  kGameSystemProcessTypeEnemyPokemonFaint,         // Enemy Pokemon FAINT
  kGameSystemProcessTypePlayerWin,                 // Player WIN
  kGameSystemProcessTypePlayerLose,                // Player LOSE
  kGameSystemProcessTypeRun,                       // Run
  kGameSystemProcessTypeBattleEnd                  // Battle END
}GameSystemProcessType;

// Move Target
typedef enum {
  kMoveTargetSinglePokemonOtherThanTheUser      = 0,   // Single Pokemon other than the user
  kMoveTargetNone                               = 1,   // No target
  kMoveTargetOneOpposingPokemonSelectedAtRandom = 2,   // One opposing Pokemon selected at random
  kMoveTargetAllOpposingPokemon                 = 4,   // All opposing Pokemon
  kMoveTargetAllPokemonOtherThanTheUser         = 8,   // All Pokemon other than the user (All non-users)
  kMoveTargetUser                               = 10,  // User
  kMoveTargetBothSides                          = 20,  // Both sides (e.g. Light Screen, Reflect, Heal Bell)
  kMoveTargetUserSide                           = 40,  // User's side
  kMoveTargetOpposingPokemonSide                = 80,  // Opposing Pokemon's side
  kMoveTargetUserPartner                        = 100, // User's partner
  kMoveTargetPlayerChoiceOfUserOrUserPartner    = 200, // Player's choice of user or user's partner (e.g. Acupressure)
  kMoveTargetSinglePokemonOnOpponentSide        = 400  // Single Pokemon on opponent's side (e.g. Me First)
}MoveTarget;



@interface GameSystemProcess () {
@private
  PMAudioPlayer     * audioPlayer_; // AUDIO player
  TrainerController * trainer_;     // Trainer Controller
  
  // Pokemon transient status
  NSInteger     playerPokemonPPInOne_;            // Store four Moves' PP data
  PokemonStatus playerPokemonStatus_;
  NSInteger     playerPokemonTransientAttack_;
  NSInteger     playerPokemonTransientDefense_;
  NSInteger     playerPokemonTransientSpeAttack_;
  NSInteger     playerPokemonTransientSpeDefense_;
  NSInteger     playerPokemonTransientSpeed_;
  NSInteger     playerPokemonTransientAccuracy_;
  NSInteger     playerPokemonTransientEvasion_;
  PokemonStatus enemyPokemonStatus_;
  NSInteger     enemyPokemonTransientAttack_;
  NSInteger     enemyPokemonTransientDefense_;
  NSInteger     enemyPokemonTransientSpeAttack_;
  NSInteger     enemyPokemonTransientSpeDefense_;
  NSInteger     enemyPokemonTransientSpeed_;
  NSInteger     enemyPokemonTransientAccuracy_;
  NSInteger     enemyPokemonTransientEvasion_;
  
  BOOL                  isBattleBetweenTrainers_;
  GameSystemProcessType processType_;          // What action process the system to deal with
  GameSystemProcessUser user_;                 // Action (use move, bag item, etc) user
  NSInteger             moveIndex_;            // If the action is using move, it's used
  MoveRealTarget        moveRealTarget_;       // Move real target
  BagQueryTargetType    targetType_;           // For bag item's 8 different types
  NSInteger             selectedPokemonIndex_; // The Pokemon bag item used for
  NSInteger             itemIndex_;            // Bag item index
  NSInteger catchingWildPokemonTimeCounter_;   // Time counter for catching Wild Pokemon
  
  GameBattleEventType eventType_;              // Mark for game event type
  BOOL      complete_;                         // Mark for system turn end
  NSInteger delayTime_;                        // Delay time for every turn
}

@property (nonatomic, strong) PMAudioPlayer     * audioPlayer;
@property (nonatomic, strong) TrainerController * trainer;

- (void)_setTransientStatusPokemonForUser:(GameSystemProcessUser)user;
- (void)_fight;
- (void)_calculateEffectForMove:(Move *)move;
- (NSInteger)_calculateDamageForMove:(Move *)move;
- (void)_decreasePPValue;                       // Decrease PP value (playerPokemonPPInOne_) with |moveIndex_|
- (NSInteger)_calculateExpGained;               // Calculate EXP gained
- (void)_checkPokemonFaintOrNot;                // Check Pokemon Faint or not
- (void)_chooseNewPokemonToBattle;              // When Player's Pokemon fainted, choose new PM to battle
- (void)_useBagItem;                            // Use Bag Item
- (void)_replacePokemon;                        // Replace Pokemon
- (void)_catchingWildPokemon;                   // Catching Wild Pokemon
- (BOOL)_hasDoneForCatchingWildPokemonResult;   // ...
- (void)_caughtWildPokemonSucceed:(BOOL)succeed;// ...
- (BOOL)_isRunSucceed;                          // Run scuueed or not
- (void)_postMessageForProcessType:(GameSystemProcessType)processType withMessageInfo:(NSDictionary *)messageInfo;

- (void)_playerWin;  // WIN
- (void)_playerLose; // LOSE
- (void)_confirmToLevelBattleScene:(UITapGestureRecognizer *)recognizer;
- (void)_runFinalProcessForGameBattleEventType:(GameBattleEndEventType)battleEndEventType;

@end


@implementation GameSystemProcess

@synthesize playerPokemon = playerPokemon_;
@synthesize enemyPokemon  = enemyPokemon_;

@synthesize audioPlayer   = audioPlayer_;
@synthesize trainer       = trainer_;

// Singleton
static GameSystemProcess * gameSystemProcess = nil;
+ (GameSystemProcess *)sharedInstance
{
  if (gameSystemProcess != nil)
    return gameSystemProcess;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gameSystemProcess = [[GameSystemProcess alloc] init];
  });
  return gameSystemProcess;
}


- (id)init
{
  if (self = [super init]) {
    [self reset];
    
    self.audioPlayer      = [PMAudioPlayer     sharedInstance];
    self.trainer          = [TrainerController sharedInstance];
    processType_          = kGameSystemProcessTypeNone;
    user_                 = kGameSystemProcessUserNone;
    moveIndex_            = 0;
    selectedPokemonIndex_ = 0;
    itemIndex_            = 0;
    catchingWildPokemonTimeCounter_ = 0;
  }
  return self;
}

// Prepare for new battle scene
- (void)prepareForNewSceneBattleBetweenTrainers:(BOOL)battleBetweenTrainers
{
  isBattleBetweenTrainers_ = battleBetweenTrainers;
  // Reset HP for enemy Pokemon
  NSArray * stats = [self.enemyPokemon.maxStats componentsSeparatedByString:@","];
  NSInteger currHP = [[stats objectAtIndex:0] intValue];
  self.enemyPokemon.hp = [NSNumber numberWithInt:currHP];
  stats = nil;
  
  // Reset data for player Pokemon
  playerPokemonPPInOne_ = [self.playerPokemon fourMovesPPInOne];
  NSLog(@"playerPokemonPPInOne_::%d", playerPokemonPPInOne_);
}

// Reset for Battle scene
- (void)reset
{
  eventType_  = kGameBattleEventTypeNone;
  complete_   = NO;
  delayTime_  = 0;
  
  [self _setTransientStatusPokemonForUser:kGameSystemProcessUserPlayer];
  [self _setTransientStatusPokemonForUser:kGameSystemProcessUserEnemy];
}

///
// Update GAME LOOP
- (void)update:(ccTime)dt
{
  delayTime_ += 100 * dt;
  
  // If there's an EVENT running, wait for it ended
  if (eventType_ != kGameBattleEventTypeNone)
    return;
  
  if (complete_) {
    if (delayTime_ < 200)
      return;
    [[GameStatusMachine sharedInstance] endStatus:kGameStatusSystemProcess];
    [self reset];
  }
  else {
    switch (processType_) {
      case kGameSystemProcessTypeFight:
        [self _fight];
        break;
        
      case kGameSystemProcessTypeUseBagItem:
        [self _useBagItem];
        break;
        
      case kGameSystemProcessTypeReplacePokemon:
        [self _replacePokemon];
        break;
        
      case kGameSystemProcessTypeCathingWildPokemon:
        if (delayTime_ < 150) return;
        [self _catchingWildPokemon];
        break;
        
      case kGameSystemProcessTypeRun:
        break;
        
      case kGameSystemProcessTypeBattleEnd:
        break;
        
      case kGameSystemProcessTypeNone:
      default:
        break;
    }
  }
}

// End Game turn, including Player, Enemy, and System's turn
- (void)endTurn
{
  if (eventType_ != kGameBattleEventTypeNone)
    return;
  if (processType_ != kGameSystemProcessTypeBattleEnd)
    complete_ = YES;
}

// End event e.g. Level Up, Evoluation, Caught WPM, etc
- (void)endEvent
{
  eventType_ = kGameBattleEventTypeNone;
  // If game battle already END, unload battle scene
  if (processType_ == kGameSystemProcessTypeBattleEnd)
    [self endBattleWithEventType:kGameBattleEndEventTypeNone];
}

// Run EVENT with event type
- (void)runEventWithEventType:(GameBattleEventType)eventType
                         info:(NSDictionary *)info
{
  // Mark as running EVENT
  eventType_ = eventType;
  NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithInt:eventType], @"eventType", nil];
  // WIN
  if (eventType & kGameBattleEventTypeWin) {
    // do nothing
  }
  // Level Up
  else if (eventType & kGameBattleEventTypeLevelUp) {
    [userInfo setValue:[info valueForKey:@"levelsUp"] forKey:@"levelsUp"];
  }
  // Evolution
  else if (eventType & kGameBattleEventTypeEvolution) {
    
  }
  // Caught a Wild Pokemon
  else if (eventType & kGameBattleEventTypeCaughtWPM) {
    // Update message in |GameMenuViewController| to show Catching WildPokemon Succeed
    [self _postMessageForProcessType:kGameSystemProcessTypeCathingWildPokemonSucceed withMessageInfo:nil];
  }
  else {
    return;
  }
  
  // Notification to |GameMainViewController| to show view of |GameBattleEventViewController|
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNGameBattleRunEvent
                                                      object:self
                                                    userInfo:userInfo];
}

// Replace Pokemon
- (void)replacePokemon:(id)pokemon
               forUser:(GameSystemProcessUser)user
{
  if (user == kGameSystemProcessUserPlayer) {
    [self.playerPokemon syncWithFlag:kDataModifyTamedPokemon | kDataModifyTamedPokemonBasic];
    self.playerPokemon = pokemon;
    // Reset data for player Pokemon
    playerPokemonPPInOne_ = [self.playerPokemon fourMovesPPInOne];
    NSLog(@"playerPokemonPPInOne_::%d", playerPokemonPPInOne_);
  }
  else {
    self.enemyPokemon = pokemon;
  }
}

#pragma mark - Private Methods

// Set transient status for pokemons
//
// Pokemons stats:
//   0. HP
//   1. Attack
//   2. Defense
//   3. Speed
//   4. Special Attack
//   5. Special Defense
// 
- (void)_setTransientStatusPokemonForUser:(GameSystemProcessUser)user
{
  NSArray * stats;
  if (user == kGameSystemProcessUserPlayer)     stats = [self.playerPokemon maxStatsInArray];
  else if (user == kGameSystemProcessUserEnemy) stats = [self.enemyPokemon  maxStatsInArray];
  else return;
  enemyPokemonStatus_               = kPokemonStatusNormal;
  playerPokemonTransientAttack_     = [[stats objectAtIndex:1] intValue];
  playerPokemonTransientDefense_    = [[stats objectAtIndex:2] intValue];
  playerPokemonTransientSpeed_      = [[stats objectAtIndex:3] intValue];
  playerPokemonTransientSpeAttack_  = [[stats objectAtIndex:4] intValue];
  playerPokemonTransientSpeDefense_ = [[stats objectAtIndex:5] intValue];
  playerPokemonTransientAccuracy_   = 100;                                      // TODO: How to use this two?
  playerPokemonTransientEvasion_    = 100;
  stats = nil;
}

// Fight
- (void)_fight
{
  if (user_ == kGameSystemProcessUserNone || moveIndex_ == 0) {
     NSLog(@"!!! Exception: The Move has no user or the |moveIndex| is 0");
    return;
  }
  
  NSInteger pokemonID;
  Move    * move;
  
  // Case the move user is Player
  if (user_ == kGameSystemProcessUserPlayer) {
    pokemonID = [self.playerPokemon.sid intValue];
    move      = [self.playerPokemon moveWithIndex:moveIndex_];
  }
  // Case the move user is Enemy
  else if (user_ == kGameSystemProcessUserEnemy) {
    pokemonID = [self.enemyPokemon.sid intValue];
    move      = [self.enemyPokemon moveWithIndex:moveIndex_];
  }
  else { NSLog(@"!!! Exception: The Move has no user"); return; }
  
  // Calculate the effect of move
  [self _calculateEffectForMove:move];
  
  // Post Message to update |messageView_| in |GameMenuViewController|
  NSDictionary * messageInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithInt:pokemonID], @"pokemonID",
                                move.sid,                           @"moveID", nil];
  [self _postMessageForProcessType:kGameSystemProcessTypeFight withMessageInfo:messageInfo];
  
  move = nil;
  processType_ = kGameSystemProcessTypeNone;
}

/*
 Move Effect Code Description
 
 00 - Normal Damage (e.g. Pound)
 01 - Puts Enemy to Sleep, no damage
 02 - 29.8% Chance of Poison (e.g. Poison Sting)
 03 - Absorbs half of damage inflicted (e.g. Mega Drain)
 04 - 9.8% Chance of Burn (e.g. Ember)
 05 - 9.8% Chance of Freeze (e.g. Ice Beam)
 06 - 9.8% Chance of Paralyze (e.g. Thunderbolt)
 07 - Opponent's defense is halved during attack, user faints (e.g. Explosion)
 08 - Absorbs half of damage inflicted, only works if opponent is sleeping (e.g. Dream Eater)
 09 - User uses last attack used (e.g. Mirror Move)
 0A - Raises Attack UP 1 Stage (e.g. Meditate)
 0B - Raises Defense UP 1 Stage (e.g. Harden)
 0C - Raises Speed UP 1 Stage (e.g. None)
 0D - Raises Special UP 1 Stage (e.g. Growth)
 0E - Raises Accuracy UP 1 Stage (e.g. None)
 0F - Raises Evasion UP 1 Stage (e.g. Double Team)
 10 - Gain money after battle (User's Level*2*Number of uses) (e.g. Pay Day)
 11 - 99.6% of hitting the opponent (Ignores Stat changes, hits flying/digging opponents) (e.g. Swift)
 12 - Lowers Attack DOWN 1 Stage (Probability = Hit Chance) (e.g. Growl)
 13 - Lowers Defense DOWN 1 Stage (Probability = Hit Chance) (e.g. Leer)
 14 - Lowers Speed DOWN 1 Stage (Probability = Hit Chance) (e.g. String Shot)
 15 - Lowers Special DOWN 1 Stage (Probability = Hit Chance) (e.g. None)
 16 - Lowers Accuracy DOWN 1 Stage (Probability = Hit Chance) (e.g. Sand Attack)
 17 - Lowers Evasion DOWN 1 Stage (Probability = Hit Chance) (e.g. None)
 18 - Changes user's type to match Opponent's (e.g. Conversion)
 19 - Removes all stat changes, returns opponent's status to Normal (e.g. Haze)
 1A - User doesn't attack for 2-3 turns, then returns double the damage taken (e.g. Bide)
 1B - Attacks 2-3 times, afterwards user becomes Confused (e.g. Thrash)
 1C - Ends battle (Probability = Hit Chance) (e.g. Teleport)
 1D - Attacks 2-5 Times in one turn (e.g. Fury Swipes)
 1E - Attacks 2-5 Turns (e.g. None)
 1F - 9.8% Chance of Flinch (e.g. Bite)
 20 - Chance of putting opponent to Sleep for 1-7 Turns (Probability = Hit Chance) (e.g. Sleep Powder)
 21 - 40% Chance of Poison (e.g. Smog)
 22 - 30.1% Chance of Burn (e.g. Fire Blast)
 23 - 30.1% Chance of Freeze (e.g. None)
 24 - 30.1% Chance of Paralyze (e.g. Body Slam)
 25 - 30.1% Chance of Flinch (e.g. Stomp)
 26 - OHKO(One Hit Knock Out) (e.g. Fissure)
 27 - Charges for one turn, attacks on the next (e.g. Razor Wind)
 28 - Deals set damage, leaves 1HP (e.g. Super Fang)
 29 - Deals set damage (Special equation depending on move?) (e.g. Seismic Toss, Dragon Rage, Psywave)
 2A - Attack 2-5 times, prevents opponent from attacking (e.g. Wrap)
 2B - Charges for one turn, attacks on the next (Can't be hit during) (e.g. Fly)
 2C - Attacks 2 times (e.g. Double Kick)
 2D - If user misses, 1 damage to user (e.g. Jump Kick)
 2E - Evade effects that lower stats (e.g. Mist)
 2F - No effect if user is faster than opponent. If user is slower, Critical Hit ratio goes to 0/511 (In other words, completely broken) (e.g. Focus Energy)
 30 - User receives Recoil damage equal to 1/4 the damage dealed (e.g. Take Down)
 31 - Chance of Confusion (Probability = Hit Chance) (e.g. Supersonic)
 32 - Raises Attack UP 2 Stages (e.g. Swords Dance)
 33 - Raises Defense UP 2 Stages (e.g. Barrier)
 34 - Raises Speed UP 2 Stages (e.g. Agility)
 35 - Raises Special UP 2 Stages (e.g. Amnesia)
 36 - Raises Accuracy UP 2 Stages (e.g. None)
 37 - Raises Evasion UP 2 Stages (e.g. None)
 38 - User Recovers HP (Excluding rest HP = Max HP/2) (Examples: Recover, Rest)
 39 - Transform into opponent, inheriting all stats (e.g. Transform)
 3A - Lowers Attack DOWN 2 Stages (Probability = Hit Chance) (e.g. None)
 3B - Lowers Defense DOWN 2 Stages (Probability = Hit Chance) (e.g. Screech)
 3C - Lowers Speed DOWN 2 Stages (Probability = Hit Chance) (e.g. None)
 3D - Lowers Special DOWN 2 Stages (Probability = Hit Chance) (e.g. None)
 3E - Lowers Accuracy DOWN 2 Stages (Probability = Hit Chance) (e.g. None)
 3F - Lowers Evasion DOWN 2 Stages (Probability = Hit Chance) (e.g. None)
 40 - Doubles Special when being attacked (e.g. Light Screen)
 41 - Doubles Defense when being attacked (e.g. Reflect)
 42 - Chance to Poison (Probability = Hit Chance) (e.g. Poison Gas)
 43 - Chance to Paralyze (Probability = Hit Chance) (e.g. Stun Spore)
 44 - 9.8% Chance of lowering Attack DOWN 1 Stage (e.g. Aurora Beam)
 45 - 9.8% Chance of lowering Defence DOWN 1 Stage (e.g. Acid)
 46 - 9.8% Chance of lowering Speed DOWN 1 Stage (e.g. Bubble)
 47 - 29.8% Chance of lowering Special DOWN 1 Stage (e.g. Psychic)
 48 - 9.8%? Chance of lowering Accuracy DOWN 1 Stage (e.g. None)
 49 - 9.8%? Chance of lowering Evasion DOWN 1 Stage (e.g. None)
 4A - None
 4B - None
 4C - 9.8% Chance of Confusion (e.g. Confusion)
 4D - Attacks 2 times, 19.8% chance of Poison (e.g. Twineedle)
 4E - Game crashes after attack
 4F - Creates close of user, user HP decreases about 1/4 (e.g. Substitute)
 50 - User can't attack second turn if opponent doesn't faint (e.g. Hyper Beam)
 51 - User's attack raises UP 1 stage each time user is hit, can't be cancelled (e.g. Rage)
 52 - Move is replaced by chosen move of opponent's for the rest of the battle or until switched (e.g. Mimic)
 53 - Uses a random attack (e.g. Metronome)
 54 - Absorbs HP each turn (About 1/16 of enemy HP) (e.g. Leech Seed)
 55 - No effect (e.g. Splash)
 56 - Disables a random attack of the opponent for 2-5 turns (e.g. Disable)
 57-65 - None?
 66 - Teleports you to the last used Pokemon Center. If used in battle, the battle restarts outside of the Center.
 67-76 - None?
 77 - Unknown Effect
 78-7F - None?
 80 - Freezes
 81-82- None?
 83 - Absorbs HP
 84 - None?
 85 - May Paralyze opponent
 86 - May Paralyze opponent
 87 - User faints after attacking
 88 - Absorbs HP
 89 - Crashes
 8A - Unknown Effect ("Nothing Happened" after attack)
 8B-8F - None?
 90 - Same as 10 (e.g. Pay Day)
 91-98 - None?
 99 - All status changes eliminated
 Most past 99 are all glitched.
 */
//
// Calculate the effect of move
//
// Version Yellow has 8 types of move target:
//  0   1   2   4   8   10  20  40
// 选择 最近 随机 二体 全体 自身 全场 己方                     
// 01  01  01 00/01 01  10  11  10   1vs1: 00-无, 01-对方, 10-自身, 11-双方
//
- (void)_calculateEffectForMove:(Move *)move
{
  // Real move target
  //  1vs1: 00-无, 01-对方, 10-自身, 11-双方
  //  2vs2: ...
  moveRealTarget_ = kMoveRealTargetNone; // Real move target
  
  switch ([move.target intValue]) {
    case kMoveTargetSinglePokemonOtherThanTheUser:
      // 0 - 选择: Single Pokemon other than the user
      moveRealTarget_ = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetEnemy : kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetNone:
      // 1 - 最近: No target
      moveRealTarget_ = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetEnemy : kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetOneOpposingPokemonSelectedAtRandom:
      // 2 - 随机: One opposing Pokemon selected at random
      moveRealTarget_ = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetEnemy : kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetAllOpposingPokemon:
      // 4 - 二体: All opposing Pokemon
      // Only apply move to different gender pokemon
//      if ([self.playerPokemon.gender intValue] ^ [self.enemyPokemon.gender intValue])
        moveRealTarget_ = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetEnemy : kMoveRealTargetPlayer;
//      else
//        moveRealTarget_ = kMoveRealTargetNone;
      break;
      
    case kMoveTargetAllPokemonOtherThanTheUser:
      // 8 - 全体: All Pokemon other than the user (All non-users)
      moveRealTarget_ = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetEnemy : kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetUser:
      // 10 - 自身: User
      moveRealTarget_ = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetPlayer : kMoveRealTargetEnemy;
      break;
      
    case kMoveTargetBothSides:
      // 20 - 全场: Both sides (e.g. Light Screen, Reflect, Heal Bell)
      moveRealTarget_ = kMoveRealTargetEnemy | kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetUserSide:
      // 40 - 己方: User's side
      moveRealTarget_ = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetPlayer : kMoveRealTargetEnemy;
      break;
      
    /*
    // Version Yellow not used yet
    case kMoveTargetOpposingPokemonSide:
      // 80: Opposing Pokemon's side
      break;
      
    case kMoveTargetUserPartner:
      // 100: User's partner
      break;
      
    case kMoveTargetPlayerChoiceOfUserOrUserPartner:
      // 200: Player's choice of user or user's partner (e.g. Acupressure)
      break;
      
    case kMoveTargetSinglePokemonOnOpponentSide:
      // 400: Single Pokemon on opponent's side (e.g. Me First)
      break;*/
    
    default:
      moveRealTarget_ = kMoveRealTargetEnemy;
      break;
  }
  
  // Move calculation result values
  // Delta values for user's & opposing pokemon
  __block PokemonStatus userPokemonStatusDelta                  = 0;
  __block NSInteger     userPokemonHPDelta                      = 0;
  __block NSInteger     userPokemonTransientAttackDelta         = 0;
  __block NSInteger     userPokemonTransientDefenseDelta        = 0;
  __block NSInteger     userPokemonTransientSpeAttackDelta      = 0;
  __block NSInteger     userPokemonTransientSpeDefenseDelta     = 0;
  __block NSInteger     userPokemonTransientSpeedDelta          = 0;
  __block NSInteger     userPokemonTransientAccuracyDelta       = 0;
  __block NSInteger     userPokemonTransientEvasionDelta        = 0;
  __block PokemonStatus opposingPokemonStatusDelta              = 0;
  __block NSInteger     opposingPokemonHPDelta                  = 0;
  __block NSInteger     opposingPokemonTransientAttackDelta     = 0;
  __block NSInteger     opposingPokemonTransientDefenseDelta    = 0;
  __block NSInteger     opposingPokemonTransientSpeAttackDelta  = 0;
  __block NSInteger     opposingPokemonTransientSpeDefenseDelta = 0;
  __block NSInteger     opposingPokemonTransientSpeedDelta      = 0;
  __block NSInteger     opposingPokemonTransientAccuracyDelta   = 0;
  __block NSInteger     opposingPokemonTransientEvasionDelta    = 0;
  
  // Player & enemy pokemon's HP
  __block NSInteger playerPokemonHP = [self.playerPokemon.hp intValue];
  __block NSInteger enemyPokemonHP  = [self.enemyPokemon.hp  intValue];
  
  // Some type of move effect need to be calculated depend on current status,
  // so, if values are calculated in |switch ([move.effectCode intValue])| directly,
  // there's no need to call |^updateValues| block anymore, so mark it.
  BOOL valuesHaveBeenCalculated = NO; 
  
  // Calculate the damage
  NSInteger moveDamage = [self _calculateDamageForMove:move];    // Move damage
  
  float          randomValue        = arc4random() % 1000 / 10; // Random value for calculating % chance
  NSInteger      stage              = 1;                        // Used in "Raises Attack UP 1 Stage"
  MoveRealTarget statusUpdateTarget = moveRealTarget_;          // Target for updating pokemon status
  
  // Calculation based on the move effect code
  switch ([move.effectCode intValue]) {
    case 0x00: // Normal Damage (e.g. Pound)
      opposingPokemonHPDelta -= moveDamage;
      break;
      
    case 0x01: // Puts Enemy to Sleep, no damage
      opposingPokemonStatusDelta |= kPokemonStatusSleep;
      break;
      
    case 0x02: // 29.8% Chance of Poison (e.g. Poison Sting)
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 29.8) opposingPokemonStatusDelta |= kPokemonStatusPoison;
      break;
      
    case 0x03: // Absorbs half of damage inflicted (e.g. Mega Drain)
      opposingPokemonHPDelta -= moveDamage;
      userPokemonHPDelta     += round(moveDamage / 2);
      
      // Update |statusUpdateTarget| to update both enemy & player pokemons' status
      statusUpdateTarget = kMoveRealTargetEnemy | kMoveRealTargetPlayer;
      break;
      
    case 0x04: // 9.8% Chance of Burn (e.g. Ember)
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 9.8) opposingPokemonStatusDelta |= kPokemonStatusBurn;
      break;
      
    case 0x05: // 9.8% Chance of Freeze (e.g. Ice Beam)
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 9.8) opposingPokemonStatusDelta |= kPokemonStatusFreeze;
      break;
      
    case 0x06: // 9.8% Chance of Paralyze (e.g. Thunderbolt)
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 9.8) opposingPokemonStatusDelta |= kPokemonStatusParalyze;
      break;
      
    case 0x07: // Opponent's defense is halved during attack, user faints (e.g. Explosion)
      if (moveRealTarget_ == kMoveRealTargetEnemy) {
        enemyPokemonTransientDefense_ /= 2;
        playerPokemonHP = 0;
      }
      else {
        playerPokemonTransientDefense_ /= 2;
        enemyPokemonHP = 0;
      }
      // Values have been calculated
      valuesHaveBeenCalculated = YES;
      break;
      
    case 0x08: // Absorbs half of damage inflicted, only works if opponent is sleeping (e.g. Dream Eater)
      if (moveRealTarget_ == kMoveRealTargetEnemy) {
        if (enemyPokemonStatus_ & kPokemonStatusSleep) {
          enemyPokemonHP  -= moveDamage;
          playerPokemonHP += moveDamage / 2;
        }
      }
      else {
        if (playerPokemonStatus_ & kPokemonStatusSleep) {
          playerPokemonHP -= moveDamage;
          enemyPokemonHP  += moveDamage / 2;
        }
      }
      // Values have been calculated
      valuesHaveBeenCalculated = YES;
      break;
      
    case 0x09: // User uses last attack used (e.g. Mirror Move)
      //
      // TODO:
      //   It needs last move opposing pokemon used,
      //   So, need an iVar
      //
      break;
      
    case 0x0A: // Raises Attack UP 1 Stage (e.g. Meditate)
      userPokemonTransientAttackDelta += stage;
      break;
      
    case 0x0B: // Raises Defense UP 1 Stage (e.g. Harden)
      userPokemonTransientDefenseDelta += stage;
      break;
      
    //case 0x0C: // Raises Speed UP 1 Stage (e.g. None)
      //userPokemonTransientSpeedDelta += stage;
      //break;
      
    case 0x0D: // Raises Special UP 1 Stage (e.g. Growth)
      userPokemonTransientSpeAttackDelta  += stage;
      userPokemonTransientSpeDefenseDelta += stage;
      break;
      
    //case 0x0E: // Raises Accuracy UP 1 Stage (e.g. None)
      //userPokemonTransientAccuracyDelta += stage;
      //break;
      
    case 0x0F: // Raises Evasion UP 1 Stage (e.g. Double Team)
      userPokemonTransientEvasionDelta += stage;
      break;
      
    case 0x10: // Gain money after battle (User's Level*2*Number of uses) (e.g. Pay Day)
      //
      // TODO:
      //   Money?
      //   So, need an iVar
      //
      break;
      
    case 0x11: // 99.6% of hitting the opponent (Ignores Stat changes, hits flying/digging opponents) (e.g. Swift)
      //
      // DOUBT:
      //   Target = 4
      //   Should it be the same as 0x00?
      //
      opposingPokemonHPDelta -= moveDamage;
      break;
      
    case 0x12: // Lowers Attack DOWN 1 Stage (Probability = Hit Chance)
      opposingPokemonTransientAttackDelta -= stage;
      break;
      
    case 0x13: // Lowers Defense DOWN 1 Stage (Probability = Hit Chance)
      opposingPokemonTransientDefenseDelta -= stage;
      break;
      
    case 0x14: // Lowers Speed DOWN 1 Stage (Probability = Hit Chance)
      opposingPokemonTransientSpeedDelta -= stage;
      break;
      
    //case 0x15: // - Lowers Special DOWN 1 Stage (Probability = Hit Chance)
      //opposingPokemonTransientSpeAttackDelta  -= stage;
      //opposingPokemonTransientSpeDefenseDelta -= stage;
      //break;
      
    case 0x16: // Lowers Accuracy DOWN 1 Stage (Probability = Hit Chance)
      opposingPokemonTransientAccuracyDelta -= stage;
      break;
      
    //case 0x17: // Lowers Evasion DOWN 1 Stage (Probability = Hit Chance)
      //opposingPokemonTransientEvasionDelta -= stage;
      //break;
      
    case 0x18: // Change user's type to match Opponent's (e.g. Conversion)
               // 将自身属性变为自身其中一个招式的属性?
      //
      // TODO:
      //   Not sure for this effect, the Pokemon is ３Ｄ龙.
      //
      break;
      
    case 0x19: // Removes all stat changes, returns opponent's status to Normal (e.g. Haze)
      [self _setTransientStatusPokemonForUser:kGameSystemProcessUserPlayer];
      [self _setTransientStatusPokemonForUser:kGameSystemProcessUserEnemy];
      // Values have been calculated
      valuesHaveBeenCalculated = YES;
      break;
      
    case 0x1A: // User doesn't attack for 2-3 turns, then returns double the damage taken (e.g. Bide)
      //
      // TODO:
      //   Need turn counter to remember the move effect
      //
      break;
      
    case 0x1B: // Attacks 2-3 times, afterwards user becomes Confused (e.g. Thrash)
      //
      // TODO:
      //   Need move apply times counter to count the attacks
      //   Also, determine the time number
      //   Currently, only once
      //
      opposingPokemonHPDelta -= moveDamage;
      opposingPokemonStatusDelta |= kPokemonStatusConfused;
      break;
      
    case 0x1C: // Ends battle (Probability = Hit Chance) (e.g. Teleport)
      //
      // TODO:
      //   Same action like run, but has its own probability
      //
      // Values have been calculated
      valuesHaveBeenCalculated = YES;
      break;
      
    case 0x1D: // Attacks 2-5 Times in one turn (e.g. Fury Swipes)
      //
      // TODO: (like 0x1B)
      //   Need move apply times counter to count the attacks
      //   Also, determine the time number
      //   Currently, only once
      //
      opposingPokemonHPDelta -= moveDamage;
      break;
      
    //case 0x1E: // Attacks 2-5 Turns (e.g. None)
      //break;
      
    case 0x1F: // 9.8% Chance of Flinch (e.g. Bite)
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 9.8) opposingPokemonStatusDelta |= kPokemonStatusFlinch;
      break;
      
    case 0x20: // Chance of putting opponent to Sleep for 1-7 Turns (Probability = Hit Chance) (e.g. Sleep Powder)
      // The probability here is |move.hitChance|
      opposingPokemonStatusDelta |= kPokemonStatusSleep;
      break;
      
    case 0x21: // 40% Chance of Poison (e.g. Smog)
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 40) opposingPokemonStatusDelta |= kPokemonStatusPoison;
      break;
      
    case 0x22: // 30.1% Chance of Burn (e.g. Fire Blast)
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 30.1) opposingPokemonStatusDelta |= kPokemonStatusBurn;
      break;
      
    //case 0x23: // 30.1% Chance of Freeze (e.g. None)
      //opposingPokemonHPDelta -= moveDamage;
      //if (randomValue <= 30.1) opposingPokemonStatusDelta |= kPokemonStatusFreeze;
      //break;
      
    case 0x24: // 30.1% Chance of Paralyze (e.g. Body Slam)
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 30.1) opposingPokemonStatusDelta |= kPokemonStatusParalyze;
      break;
      
    case 0x25: // 30.1% Chance of Flinch (e.g. Stomp)
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 30.1) opposingPokemonStatusDelta |= kPokemonStatusFlinch;
      break;
      
    case 0x26: // OHKO (One Hit Knock Out) (e.g. Fissure)
      if (moveRealTarget_ == kMoveRealTargetEnemy) enemyPokemonHP  = 0;
      else                                        playerPokemonHP = 0;
      // Values have been calculated
      valuesHaveBeenCalculated = YES;
      break;
      
    case 0x27: // Charges for one turn, attacks on the next (e.g. Razor Wind)
      //
      // TODO:
      //   Turn counter, move remember
      //
      break;
      
    case 0x28: // Deals set damage, leaves 1HP (e.g. Super Fang)
               // 敌HP减半，但不会减为0
      if (moveRealTarget_ == kMoveRealTargetEnemy) {
        enemyPokemonHP /= 2;
        if (enemyPokemonHP <= 0) enemyPokemonHP = 1;
      }
      else {
        playerPokemonHP /= 2;
        if (playerPokemonHP <= 0) playerPokemonHP = 1;
      }
      // Values have been calculated
      valuesHaveBeenCalculated = YES;
      break;
      
    case 0x29: // Deals set damage (Special equation depending on move?) (e.g. Seismic Toss, Dragon Rage, Psywave)
               // 给予对手40HP的固定伤害
      opposingPokemonHPDelta -= 40;
      break;
      
    case 0x2A: // Attack 2-5 times, prevents opponent from attacking (e.g. Wrap)
               // 2至5回合敌无法交换妖怪，每回合敌HP损失最大值的1/16
      //
      // TODO:
      //   It's a special move..
      //
      break;
      
    case 0x2B: // Charges for one turn, attacks on the next (Can't be hit during) (e.g. Fly)
      //
      // TODO:
      //   Like 0x27, but can't be hit during
      //
      break;
      
    case 0x2C: // Attacks 2 times (e.g. Double Kick)
      //
      // TODO:
      //   Attacks mutilpe times..
      //   Currently just once
      //
      opposingPokemonHPDelta -= moveDamage;
      break;
      
    case 0x2D: // If user misses, 1 damage to user (e.g. Jump Kick)
               // 攻击失误的话自身要受伤害的1/2
      if (randomValue <= [move.hitChance intValue])
        opposingPokemonHPDelta -= moveDamage;
      else userPokemonHPDelta -= moveDamage / 2;
      break;
      
    case 0x2E: // Evade effects that lower stats (e.g. Mist)
               // 5回合内，已方不会受别人能力下降的技能影响，交换精灵效果持续 (白雾)
      //
      // TODO:
      //   Special move..
      //
      break;
      
    case 0x2F: // No effect if user is faster than opponent.
               // If user is slower, Critical Hit ratio goes to 0/511
               // (In other words, completely broken) (e.g. Focus Energy)
               // 使用后攻击容易会心一击 (蓄气)
      //
      // TODO:
      //   Add iVar for probability of a critical hit?
      //
      break;
      
    case 0x30: // User receives Recoil damage equal to 1/4 the damage dealed (e.g. Take Down)
               // 全部技能PP用完时使用的技能，每次攻击将损失HP最大值的1/4，无视敌属性
      //
      // TODO:
      //   Special move..
      //
      break;
      
    case 0x31: // Chance of Confusion (Probability = Hit Chance) (e.g. Supersonic)
      opposingPokemonStatusDelta |= kPokemonStatusConfused;
      break;
      
    case 0x32: // Raises Attack UP 2 Stages (e.g. Swords Dance)
      userPokemonTransientAttackDelta += 2 * stage;
      break;
      
    case 0x33: // Raises Defense UP 2 Stages (e.g. Barrier)
      userPokemonTransientDefenseDelta += 2 * stage;
      break;
      
    case 0x34: // Raises Speed UP 2 Stages (e.g. Agility)
      userPokemonTransientSpeedDelta += 2 * stage;
      break;
      
    case 0x35: // Raises Special UP 2 Stages (e.g. Amnesia)
      userPokemonTransientSpeAttackDelta  += 2 * stage;
      userPokemonTransientSpeDefenseDelta += 2 * stage;
      break;
      
    //case 0x36: // Raises Accuracy UP 2 Stages (e.g. None)
      //userPokemonTransientAccuracyDelta += 2 * stage;
      //break;
      
    //case 0x37: // Raises Evasion UP 2 Stages (e.g. None)
      //userPokemonTransientEvasionDelta += 2 * stage;
      //break;
      
    case 0x38: // User Recovers HP (Excluding rest HP = Max HP/2) (Examples: Recover, Rest)
               // 自身回复最大HP的1/2 (自我再生)
      if (moveRealTarget_ == kMoveRealTargetEnemy) {
        NSInteger enemyPokemonHPMax =
          [[[self.enemyPokemon.maxStats componentsSeparatedByString:@","] objectAtIndex:0] intValue];
        enemyPokemonHP += enemyPokemonHPMax / 2;
        if (enemyPokemonHP > enemyPokemonHPMax) enemyPokemonHP = enemyPokemonHPMax;
      }
      else {
        NSInteger playerPokemonHPMax =
          [[[self.playerPokemon.maxStats componentsSeparatedByString:@","] objectAtIndex:0] intValue];
        playerPokemonHP += playerPokemonHPMax / 2;
        if (playerPokemonHP > playerPokemonHPMax) playerPokemonHP = playerPokemonHPMax;
      }
      // Values have been calculated
      valuesHaveBeenCalculated = YES;
      break;
      
    case 0x39: // Transform into opponent, inheriting all stats (e.g. Transform)
               // 战斗中暂时复制对手外观、No.、能力(HP除外)、招式、个体值、能力等级、特性、属性 (变身)
      //
      // TODO:
      //   Copy all.
      //   Use real value for attack, defense, speed, etc, not extra?
      //
      break;
      
    //case 0x3A: // Lowers Attack DOWN 2 Stages (Probability = Hit Chance)
      //opposingPokemonTransientAttackDelta -= 2 * stage;
      //break;
      
    case 0x3B: // Lowers Defense DOWN 2 Stages (Probability = Hit Chance)
      opposingPokemonTransientDefenseDelta -= 2 * stage;
      break;
      
    //case 0x3C: // Lowers Speed DOWN 2 Stages (Probability = Hit Chance)
      //opposingPokemonTransientSpeedDelta -= 2 * stage;
      //break;
      
    //case 0x3D: // Lowers Special DOWN 2 Stages (Probability = Hit Chance)
      //opposingPokemonTransientSpeAttackDelta  -= 2 * stage;
      //opposingPokemonTransientSpeDefenseDelta -= 2 * stage;
      //break;
      
    //case 0x3E: // Lowers Accuracy DOWN 2 Stages (Probability = Hit Chance)
      //opposingPokemonTransientAccuracyDelta -= 2 * stage;
      //break;
      
    //case 0x3F: // Lowers Evasion DOWN 2 Stages (Probability = Hit Chance)
      //opposingPokemonTransientEvasionDelta -= 2 * stage;
      //break;
      
    case 0x40: // Doubles Special when being attacked (e.g. Light Screen)
               // 5回合内，我方受到特殊攻击时伤害减半(也就特殊防御加倍？)，交换效果持续；双打时伤害为2/3 (光之壁 target-40)
      //
      // TODO:
      //   Special move..
      //
      break;
      
    case 0x41: // Doubles Defense when being attacked (e.g. Reflect)
               // 5回合内，我方受到物理攻击时伤害减半(也就普通防御加倍?)，交换效果持续；双打时伤害为2/3
      //
      // TODO:
      //   Special move..
      //
      break;
      
    case 0x42: // Chance to Poison (Probability = Hit Chance) (e.g. Poison Gas)
      opposingPokemonStatusDelta |= kPokemonStatusPoison;
      break;
      
    case 0x43: // Chance to Paralyze (Probability = Hit Chance) (e.g. Stun Spore)
      opposingPokemonStatusDelta |= kPokemonStatusParalyze;
      break;
      
    case 0x44: // 9.8% Chance of lowering Attack DOWN 1 Stage
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 9.8) opposingPokemonTransientAttackDelta -= stage;
      break;
      
    case 0x45: // 9.8% Chance of lowering Defence DOWN 1 Stage
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 9.8) opposingPokemonTransientDefenseDelta -= stage;
      break;
      
    case 0x46: // 9.8% Chance of lowering Speed DOWN 1 Stage
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 9.8) opposingPokemonTransientSpeedDelta -= stage;
      break;
      
    case 0x47: // 29.8% Chance of lowering Special DOWN 1 Stage
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 29.8) {
        opposingPokemonTransientSpeAttackDelta -= stage;
        opposingPokemonTransientDefenseDelta   -= stage;
      }
      break;
      
    //case 0x48: // 9.8%? Chance of lowering Accuracy DOWN 1 Stage
      //opposingPokemonHPDelta -= moveDamage;
      //if (randomValue <= 9.8) opposingPokemonTransientAccuracyDelta -= stage;
      //break;
      
    //case 0x49: // 9.8%? Chance of lowering Evasion DOWN 1 Stage
      //opposingPokemonHPDelta -= moveDamage;
      //if (randomValue <= 9.8) opposingPokemonTransientEvasionDelta -= stage;
      //break;
      
    //case 0x4A: // None
      //break;
      
    //case 0x4B: // None
      //break;
      
    case 0x4C: // 9.8% Chance of Confusion (e.g. Confusion)
      opposingPokemonHPDelta -= moveDamage;
      if (randomValue <= 9.8) opposingPokemonStatusDelta |= kPokemonStatusConfused;
      break;
      
    case 0x4D: // Attacks 2 times, 19.8% chance of Poison (e.g. Twineedle)
      //
      // TODO:
      //   Attack times...
      //
      if (randomValue <= 19.8) opposingPokemonStatusDelta |= kPokemonStatusPoison;
      break;
      
    //case 0x4E: // Game crashes after attack?!
      //break;
      
    case 0x4F: // Creates close of user, user HP decreases about 1/4 (e.g. Substitute)
               // 自身使用最大HP的1/4制造替身，替身会替自身抵受攻击，直至替身0HP(最大HP的1/4) (替身)
      //
      // TODO:
      //   Special move..
      //
      break;
      
    case 0x50: // User can't attack second turn if opponent doesn't faint (e.g. Hyper Beam)
               // 一回合攻击，次回合不能行动(攻击失误不计) (破坏死光)
      //
      // TODO:
      //   Special move..
      //
      break;
      
    case 0x51: // User's attack raises UP 1 stage each time user is hit, can't be cancelled (e.g. Rage)
               // 如果受到攻击，连续使用威力倍增(攻击失误或没有受到攻击效果取消) (愤怒)
      //
      // TODO:
      //   Special move..
      //
      break;
      
    case 0x52: // Move is replaced by chosen move of opponent's for the rest of the battle or until switched (e.g. Mimic)
               // 只在当次战斗中学会敌人最后使用的技能，PP为5 (模仿)
      //
      // TODO:
      //   Special move..
      //
      break;
      
    case 0x53: // Uses a random attack (e.g. Metronome)
               // 随机使出任意一个技能 (摇手指)
      //
      // TODO:
      //   Special move..
      //
      break;
      
    case 0x54: // Absorbs HP each turn (About 1/16 of enemy HP) (e.g. Leech Seed)
               // 每回合吸取对方最大HP的1/8 (1/16?)，对草系无效；巨大根茎可提升回复量。 (寄生种子)
      //
      // TODO:
      //   Special move..
      //
      break;
      
    case 0x55: // No effect (e.g. Splash)
               // 鲤鱼王（水溅跃）
      break;
      
    case 0x56: // Disables a random attack of the opponent for 2-5 turns (e.g. Disable)
               // 令对手最后使用的技能在2~5回合内不能使用 (束缚)
      //
      // TODO:
      //   Special move..
      //
      break;
      
    default:
      break;
  }
  
  // Block to set values
  void (^updateValues)(MoveRealTarget) = ^(MoveRealTarget target) {
    if (target & kMoveRealTargetEnemy) {
      if (opposingPokemonStatusDelta != 0) enemyPokemonStatus_ |= opposingPokemonStatusDelta;
      if (opposingPokemonHPDelta != 0)     enemyPokemonHP      += opposingPokemonHPDelta;
      if (opposingPokemonTransientAttackDelta != 0)
        enemyPokemonTransientAttack_ += opposingPokemonTransientAttackDelta;
      if (opposingPokemonTransientDefenseDelta != 0)
        enemyPokemonTransientDefense_ += opposingPokemonTransientDefenseDelta;
      if (opposingPokemonTransientSpeAttackDelta != 0)
        enemyPokemonTransientSpeAttack_ += opposingPokemonTransientSpeAttackDelta;
      if (opposingPokemonTransientSpeDefenseDelta != 0)
        enemyPokemonTransientSpeDefense_ += opposingPokemonTransientSpeDefenseDelta;
      if (opposingPokemonTransientSpeedDelta != 0)
        enemyPokemonTransientSpeed_ += opposingPokemonTransientSpeedDelta;
      if (opposingPokemonTransientAccuracyDelta != 0)
        enemyPokemonTransientAccuracy_ += opposingPokemonTransientAccuracyDelta;
      if (opposingPokemonTransientEvasionDelta != 0)
        enemyPokemonTransientEvasion_ += opposingPokemonTransientEvasionDelta;
      
      if (userPokemonStatusDelta != 0) playerPokemonStatus_ |= userPokemonStatusDelta;
      if (userPokemonHPDelta != 0)     playerPokemonHP      += userPokemonHPDelta;
      if (userPokemonTransientAttackDelta != 0)
        playerPokemonTransientAttack_ += userPokemonTransientAttackDelta;
      if (userPokemonTransientDefenseDelta != 0)
        playerPokemonTransientDefense_ += userPokemonTransientDefenseDelta;
      if (userPokemonTransientSpeAttackDelta != 0)
        playerPokemonTransientSpeAttack_ += userPokemonTransientSpeAttackDelta;
      if (userPokemonTransientSpeDefenseDelta != 0)
        playerPokemonTransientSpeDefense_ += userPokemonTransientSpeDefenseDelta;
      if (userPokemonTransientSpeedDelta != 0)
        playerPokemonTransientSpeed_ += userPokemonTransientSpeedDelta;
      if (userPokemonTransientAccuracyDelta != 0)
        playerPokemonTransientAccuracy_ += userPokemonTransientAccuracyDelta;
      if (userPokemonTransientEvasionDelta != 0)
        playerPokemonTransientEvasion_ += userPokemonTransientEvasionDelta;
    }
    else {
      if (opposingPokemonStatusDelta != 0) playerPokemonStatus_ |= opposingPokemonStatusDelta;
      if (opposingPokemonHPDelta != 0)     playerPokemonHP      += opposingPokemonHPDelta;
      if (opposingPokemonTransientAttackDelta != 0)
        playerPokemonTransientAttack_ += opposingPokemonTransientAttackDelta;
      if (opposingPokemonTransientDefenseDelta != 0)
        playerPokemonTransientDefense_ += opposingPokemonTransientDefenseDelta;
      if (opposingPokemonTransientSpeAttackDelta != 0)
        playerPokemonTransientSpeAttack_ += opposingPokemonTransientSpeAttackDelta;
      if (opposingPokemonTransientSpeDefenseDelta != 0)
        playerPokemonTransientSpeDefense_ += opposingPokemonTransientSpeDefenseDelta;
      if (opposingPokemonTransientSpeedDelta != 0)
        playerPokemonTransientSpeed_ += opposingPokemonTransientSpeedDelta;
      if (opposingPokemonTransientAccuracyDelta != 0)
        playerPokemonTransientAccuracy_ += opposingPokemonTransientAccuracyDelta;
      if (opposingPokemonTransientEvasionDelta != 0)
        playerPokemonTransientEvasion_ += opposingPokemonTransientEvasionDelta;
      
      if (userPokemonStatusDelta != 0) enemyPokemonStatus_ |= userPokemonStatusDelta;
      if (userPokemonHPDelta != 0)     enemyPokemonHP      += userPokemonHPDelta;
      if (userPokemonTransientAttackDelta != 0)
        enemyPokemonTransientAttack_ += userPokemonTransientAttackDelta;
      if (userPokemonTransientDefenseDelta != 0)
        enemyPokemonTransientDefense_ += userPokemonTransientDefenseDelta;
      if (userPokemonTransientSpeAttackDelta != 0)
        enemyPokemonTransientSpeAttack_ += userPokemonTransientSpeAttackDelta;
      if (userPokemonTransientSpeDefenseDelta != 0)
        enemyPokemonTransientSpeDefense_ += userPokemonTransientSpeDefenseDelta;
      if (userPokemonTransientSpeedDelta != 0)
        enemyPokemonTransientSpeed_ += userPokemonTransientSpeedDelta;
      if (userPokemonTransientAccuracyDelta != 0)
        enemyPokemonTransientAccuracy_ += userPokemonTransientAccuracyDelta;
      if (userPokemonTransientEvasionDelta != 0)
        enemyPokemonTransientEvasion_ += userPokemonTransientEvasionDelta;
    }
    // Fix HP value to make sure it is in range of [0, max]
    if (playerPokemonHP < 0) playerPokemonHP = 0;
    if (enemyPokemonHP  < 0) enemyPokemonHP  = 0;
    NSInteger playerPokemonHPMax = [[[self.playerPokemon maxStatsInArray] objectAtIndex:0] intValue];
    if (playerPokemonHP > playerPokemonHPMax) playerPokemonHP = playerPokemonHPMax;
    NSInteger enemyPokemonHPMax  = [[[self.enemyPokemon maxStatsInArray]  objectAtIndex:0] intValue];
    if (enemyPokemonHP > enemyPokemonHPMax) enemyPokemonHP = enemyPokemonHPMax;
  };
  
  // If |valueHasBeenCalculated == NO|, i.e. value need to be calculated next
  if (! valuesHaveBeenCalculated) {
    // Update values for player & enemy pokemon
    if (moveRealTarget_ & (kMoveRealTargetEnemy | kMoveRealTargetPlayer)) {
      NSLog(@"moveRealTarget_ & (kMoveRealTargetEnemy | kMoveRealTargetPlayer");
      if (user_ == kGameSystemProcessUserPlayer)      updateValues(kMoveRealTargetEnemy);
      else                                            updateValues(kMoveRealTargetPlayer);
    }
    else if (moveRealTarget_ & kMoveRealTargetEnemy)  updateValues(kMoveRealTargetEnemy);
    else if (moveRealTarget_ & kMoveRealTargetPlayer) updateValues(kMoveRealTargetPlayer);
    else NSLog(@"!!!moveRealTarget_ == kMoveRealTargetNone");
  }
  
  // Set HP back to |playerPokemon_| & |enemyPokemon_|
  self.playerPokemon.hp = [NSNumber numberWithInt:playerPokemonHP];
  self.enemyPokemon.hp  = [NSNumber numberWithInt:enemyPokemonHP];
#ifdef KY_SUPER_POKEMON_MODE_ON
  self.enemyPokemon.hp = [NSNumber numberWithInt:0];
#endif
  
  // !!!TODO
  //   Different Move has its own audio type!
  //
  // If Move affect on HP, play Move Basic Attack Audio
  if (userPokemonHPDelta < 0 || opposingPokemonHPDelta < 0)
    [self.audioPlayer playForAudioType:kAudioMoveBasicAttack afterDelay:.8f];
  
  // Post to |GameMenuViewController| to update pokemon status view
  NSDictionary * newUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithInt:statusUpdateTarget],   @"target",
                                [NSNumber numberWithInt:playerPokemonStatus_], @"playerPokemonStatus",
                                self.playerPokemon.hp,                         @"playerPokemonHP",
                                [NSNumber numberWithInt:enemyPokemonStatus_],  @"enemyPokemonStatus",
                                self.enemyPokemon.hp,                          @"enemyPokemonHP", nil];
  NSLog(@"MoveRealTarget:%@ - Notification Info:%@",
        moveRealTarget_ == kMoveRealTargetEnemy ? @"Enemy" : @"Player", newUserInfo);
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdatePokemonStatus object:self userInfo:newUserInfo];
  
  // Decrease PP value (only for Player, not include WildPokemon(enemy) now)
  [self _decreasePPValue];
  
  // Checking Pokemon FAINT or not
  [self performSelector:@selector(_checkPokemonFaintOrNot) withObject:nil afterDelay:1.5f];
}

// Calculate the move damage
//
///FORMULA on DAMAGE:
//   Damage = ((((2 * Level / 5 + 2) * AttackStat * AttackPower / DefenseStat) / 50) + 2) 
//            * STAB * Weakness/Resistance * RandomNumber / 100
//
//   |Level|:       pokemon's current level.
//   |AttackStat|:  pokemon's Attack/Special Attack stat, whichever one is being used at the moment.
//   |DefenseStat|: opponents Defense/SpecialDefense stat, depending on the attack the pokemon is using.
//   |AttackPower|: the power of the specific move you're using.
//   |STAB|:        the same type attack bonus. If you're using a move that coordinates with your own type,
//                  you get a 1.5 bonus here. Otherwise, this variable is equal to 1.
//   |Weakness/Resistance|: depends on if your move was super-effective or otherwise.
//                          This variable could be 0.25, 0.5, 1, 2, or 4 depending on how effective your attack was.
//   |RandomNumber|: simply a Random Number between 85 and 100.
//
///MOVE in/decrease stage:
//
//   Each of the moves like that will up your stat or decrease your stats depending on the move a number of levels, maximum is six. Say you used Howl and upped your Attack stat by 1 level. What does that translate to? Well depending how many levels you have, those moves will up either your Attack, Defense, Speed, Special Attack, or Special Defense stats by a certain percentage.
//
//   -6 levels: 25%
//   -5 levels: 29%
//   -4 levels: 33%
//   -3 levels: 40%
//   -2 levels: 50%
//   -1 level:  66%
//    0 levels: 100%
//    1 level:  150%
//    2 levels: 200%
//    3 levels: 250%
//    4 levels: 300%
//    5 levels: 350%
//    6 levels: 400%
//
// |Stage |Main Stats       |Accuracy         |Evasion
//    -6	StatValue * 0.25	Accuracy * 0.33   OppAcc * 3
//    -5	StatValue * 0.285	Accuracy * 0.375	OppAcc * 2.66
//    -4	StatValue * 0.33	Accuracy * 0.428	OppAcc * 2.33
//    -3	StatValue * 0.4   Accuracy * 0.5    OppAcc * 2
//    -2	StatValue * 0.5   Accuracy * 0.6    OppAcc * 1.66
//    -1	StatValue * 0.66	Accuracy * 0.75   OppAcc * 1.33
//    0   StatValue * 1     Accuracy * 1      OppAcc * 1
//    1   StatValue * 1.5   Accuracy * 1.33   OppAcc * 0.75
//    2   StatValue * 2     Accuracy * 1.66   OppAcc * 0.6
//    3   StatValue * 2.5   Accuracy * 2      OppAcc * 0.5
//    4   StatValue * 3     Accuracy * 2.33   OppAcc * 0.428
//    5   StatValue * 3.5   Accuracy * 2.66   OppAcc * 0.375
//    6   StatValue * 4     Accuracy * 3      OppAcc * 0.33
//
//  DETAIL REFERENCE: [Stat Modification][http://www.serebii.net/games/stats.shtml]
//
//
//  !!!TODO:
//     (1) effect on stat is not involved.
//     (2) PM's status is not involved.
//  REFERENCE: http://www.serebii.net/games/damage.shtml
//
- (NSInteger)_calculateDamageForMove:(Move *)move
{
  if ([move.baseDamage intValue] == 0)
    return 0;
  
  // Basic values
  double level;        // pokemon's current level
  double attackStat;   // pokemon's Attack/Special Attack stat, whichever one is being used at the moment
  double defenseStat;  // opponents Defense/SpecialDefense stat, depending on the attack the pokemon is using
  double attackPower;  // the power of the specific move you're using
  double stab;         // the same type attack bonus
  double status;       // depends on if your move was super-effective or otherwise (could be 0.25, 0.5, 1, 2, or 4)
  double randomNumber; // simply a Random Number between 85 and 100
  
  // Set values
  if (user_ == kGameSystemProcessUserPlayer) {
    stab = [self.playerPokemon.pokemon moveDamageEffectOnOpponentPokemon:self.enemyPokemon.pokemon];
    if (stab == 0)
      return 0;
    level       = [self.playerPokemon.level doubleValue];
    attackStat  = [[[self.playerPokemon maxStatsInArray] objectAtIndex:1] doubleValue];
    defenseStat = [[[self.enemyPokemon maxStatsInArray] objectAtIndex:2] doubleValue];
    status      = 1; // TODO!!!!
    /*switch (enemyPokemonStatus_) {
      case :
        break;
        
      default:
        break;
    }*/
  }
  else if (user_ == kGameSystemProcessUserEnemy) {
    stab = [self.enemyPokemon.pokemon moveDamageEffectOnOpponentPokemon:self.playerPokemon.pokemon];
    if (stab == 0)
      return 0;
    level       = [self.enemyPokemon.level doubleValue];
    attackStat  = [[[self.enemyPokemon maxStatsInArray] objectAtIndex:1] doubleValue];
    defenseStat = [[[self.playerPokemon maxStatsInArray] objectAtIndex:2] doubleValue];
    status      = 1; // TODO!!!
  }
  else return 0;
  attackPower = [move.baseDamage doubleValue];
  randomNumber = arc4random() % 16 + 85;
  
  ///FORMULA on DAMAGE:
  //   Damage = ((((2 * Level / 5 + 2) * AttackStat * AttackPower / DefenseStat) / 50) + 2) 
  //            * STAB * Weakness/Resistance * RandomNumber / 100
  NSInteger damage;
  damage = ((((2.f * level / 5.f + 2.f) * attackStat * attackPower / defenseStat) / 50.f) + 2.f) * stab * status * randomNumber / 100.f;
  NSLog(@"DAMAGE:%d", damage);
  NSLog(@"level:%f / attackStat:%f / defenseStat:%f / attackPower:%f / stab:%f / status:%f / randomNumber:%f",
        level, attackStat, defenseStat, attackPower, stab, status, randomNumber);
  return damage;
}

// Decrease PP value (|playerPokemonPPInOne_|) with |moveIndex_|
//
//   |PPInOne|: 000 000 000 000
//  Move Index:   4   3   2   1
//
// TODO:
//   WildPokemon's Move PP not included
//
- (void)_decreasePPValue
{
  // Only for Player now (not include WildPokemon (enemy))
  if (user_ != kGameSystemProcessUserPlayer || moveIndex_ < 1 || moveIndex_ > 4)
    return;
  playerPokemonPPInOne_ -= pow(1000, (moveIndex_ - 1));
  NSLog(@"Used Move_%d, New value of ppInOne:%d", moveIndex_, playerPokemonPPInOne_);
  
  //
  // !!!TODO:
  //   No need to save PP every time
  //
  [self.playerPokemon updateFourMovesWithPPInOne:playerPokemonPPInOne_];
}

// Calculate the EXP. points gained
//
// [[[GENERATION V]]]
// *** In Generation V, the experience calculation has changed drastically, taking a lot of the calculation from both your level, their level and the difference in the level. This allows for faster level ups when you're under the level of the Pokémon and smaller ones when you're over the level of the Pokémon. This equation is as follows:
//
//    floor(floor(√(A)*(A*A))*B/floor(√(C)*(C*C)))+1  (formula 1)
//
//    |A| is equal to the (OpponentLevel * 2) + 10
//    |B| is a more complicated variable and is where things start seeing changes. Normally, Value B is a simple (OpponentBaseExperience * OpponentLevel / 5). However, there are multiple additions and are calculated in order.
//    |C| is (OpponentLevel + UserLevel + 10)
//
//  * In trainer battles, value B is multiplied by 1.5
//
//  * If a Pokémon has <EXP. Share>, then B is halved.
//    Value |B| is then divided by the amount of team members who have been in battle against the Pokémon that has been defeated.
//
//  Once this is calculated, there are more means to boost the experience gained. These means are all different and are even stackable, allowing massive Experience gains
//
//    MEANS                                     |INCREASE
//    Pokémon is holding the Lucky Egg:          * 1.5
//    Pokémon is from a different game:          * 1.5
//    Pokémon is from a different language game: * 1.7
//    Exp. Point Power ↓↓↓:                      * 0.8
//    Exp. Point Power ↓↓:                       * 0.66
//    Exp. Point Power ↓:                        * 0.5
//    Exp. Point Power ↑:                        * 1.2
//    Exp. Point Power ↑↑:                       * 1.5
//    Exp. Point Power ↑↑↑:                      * 2
//    Exp. Point Power S:                        * 2
//    Exp. Point Power MAX:                      * 2
//
//
// [[[GENERATION V]]]
//  So now that you know about the different growth rates, let me explain how actual Experience is gained. There's an equation for how much Experience you gain of course, it may not be exact however since it's from Gold and Silver. Regardless, it's very similar.
//
//    Experience = ((Base Experience * Level) * Trainer * Wild) / 7  (formula 2)
//
//    |Base Experience|: a lot like they have Base Stats, e.g., Bulbasaur has a Base Experience of 64.
//    |Level|:           It's what level the pokemon you're fighting is at.
//    |Trainer|:         If your Trainer ID matches that of the Original Trainer of your own pokemon,
//                       then |Trainer| is going to equal 1. If it doesn't, it is 1.5 instead.
//                       This is how your pokemon gets 1.5 more Experience Points after you trade it to someone else.
//    |Wild|:            tells if the pokemon you're fighting is wild or not.
//                       If it is wild, then this variable is equal to 1.
//                       If you're fighting a trainers pokemon, then it equals 1.5.
//
//  * One more thing.
//    <Exp. Share> is an item that will always give half of the experience points gained in the battle to the pokemon with the item equipped, regardless of if it participated or not. This makes leveling up young pokemon easy.
//
- (NSInteger)_calculateExpGained
{
  //
  // NOTE: use (formula 2) now
  //
  double expGained;
  // Basic parameters
  //
  // !!!TODO:
  //    |trainer| & |wild| is not calculated now
  //
  //
  double baseExp = [self.playerPokemon.pokemon.baseEXP doubleValue]; // PM's base EXP
  double enemyPokemonLevel = [self.enemyPokemon.level doubleValue];
  double trainer = 1; // original trainer 1; if not, 1.5 (Pokemon Exchange)
  double wild = 1;    // wild PM, 1; fighting to a trainer's PM, 1.5
  
  // Caclute the result of EXP
  //   Experience = ((Base Experience * Level) * Trainer * Wild) / 7  (formula 2)
  expGained = (baseExp * enemyPokemonLevel * trainer * wild) / 7.f;
  return (NSInteger)round(expGained);
}

// Check Pokemon Faint or not
- (void)_checkPokemonFaintOrNot
{
  // Enemy Pokemon FAINT
  if (moveRealTarget_ == kMoveRealTargetEnemy && [self.enemyPokemon.hp intValue] == 0) {
    NSLog(@"// Enemy Pokemon FAINT......");
    [self _postMessageForProcessType:kGameSystemProcessTypeEnemyPokemonFaint
                     withMessageInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNEnemyPokemonFaint
                                                        object:self
                                                      userInfo:nil];
    // If the battle is between trainers
    // !!!TODO:
    //  Let enemy Trainer to choose new Pokemon
    if (isBattleBetweenTrainers_) {
    }
    // Else, is Wild Pokemon, END Game Battle with Player WIN event
    // Post notification to |GameMainViewController|
    else {
      NSLog(@"WildPokemon FAINT, END Game...");
      processType_ = kGameSystemProcessTypeBattleEnd;
      [self performSelector:@selector(_playerWin) withObject:nil afterDelay:2.f];
    }
  }
  // Player Pokemon FAINT
  else if (moveRealTarget_ == kMoveRealTargetPlayer && [self.playerPokemon.hp intValue] == 0) {
    NSLog(@"// Player Pokemon FAINT......");
    [self _postMessageForProcessType:kGameSystemProcessTypePlayerPokemonFaint
                     withMessageInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNPlayerPokemonFaint
                                                        object:self
                                                      userInfo:nil];
    // If there're still some Pokemons battle available,
    //   show view of |GameMenuSixPokemonsViewController| to choose Pokemon
    if ([[TrainerController sharedInstance] battleAvailablePokemonIndex]) {
      NSLog(@"sixPokemonsBattleAvailable... show view to choose new Pokemon");
      [self performSelector:@selector(_chooseNewPokemonToBattle) withObject:nil afterDelay:2.f];
    }
    // Else, END Game Battle with Player LOSE event
    // Post notification to |GameMainViewController|
    else {
      NSLog(@"All Pokemons owned by Player FAINT, END Game...");
      processType_ = kGameSystemProcessTypeBattleEnd;
      [self performSelector:@selector(_playerLose) withObject:nil afterDelay:2.f];
    }
  }
  
  // END Turn
  [self endTurn];
}

// When Player's Pokemon fainted, choose new PM to battle
- (void)_chooseNewPokemonToBattle
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNToggleSixPokemons
                                                      object:self
                                                    userInfo:nil];
}

// Use bag item
- (void)_useBagItem
{
  // Throw Pokeball
  if (targetType_ == kBagQueryTargetTypePokeball) {
    // Post Message to update |messageView_| in |GameMenuViewController|
    [self _postMessageForProcessType:kGameSystemProcessTypeUseBagItem withMessageInfo:nil];
    
    // Turn to Catching Wild Pokemon
    processType_ = kGameSystemProcessTypeCathingWildPokemon;
    delayTime_ = 0;
  }
  // Use Status Healers, HP/PP Restores, etc. for Pokemons
  else {
    // Post to |GameMenuViewController| to update pokemon status view
    NSDictionary * pokemonStatus = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kMoveRealTargetPlayer], @"target",
                                    self.playerPokemon.status,                      @"playerPokemonStatus",
                                    self.playerPokemon.hp,                          @"playerPokemonHP",
                                    self.enemyPokemon.status,                       @"enemyPokemonStatus",
                                    self.enemyPokemon.hp,                           @"enemyPokemonHP", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdatePokemonStatus
                                                        object:self
                                                      userInfo:pokemonStatus];
    
    
    // Post Message to update |messageView_| in |GameMenuViewController|
    TrainerTamedPokemon * pokemon = [[TrainerController sharedInstance] pokemonOfSixAtIndex:selectedPokemonIndex_];
    NSInteger pokemonID = [pokemon.sid intValue];
    pokemon = nil;
    NSDictionary * messageInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSNumber numberWithInt:pokemonID], @"pokemonID", nil];
    [self _postMessageForProcessType:kGameSystemProcessTypeUseBagItem withMessageInfo:messageInfo];
    
    [self endTurn];
  }
}

// Replace pokemon
- (void)_replacePokemon
{
#ifdef KY_TESTFLIGHT_ON
  [TestFlight passCheckpoint:@"CHECK_POINT: Replaced a PM"];
#endif
  // Post to |GameMenuViewController| to update pokemon status view
  NSDictionary * pokemonStatus = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSNumber numberWithInt:kMoveRealTargetPlayer], @"target",
                                  self.playerPokemon.status,                      @"playerPokemonStatus",
                                  self.playerPokemon.hp,                          @"playerPokemonHP",
                                  self.playerPokemon.exp,                         @"Exp",
                                  self.enemyPokemon.status,                       @"enemyPokemonStatus",
                                  self.enemyPokemon.hp,                           @"enemyPokemonHP", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdatePokemonStatus
                                                      object:self
                                                    userInfo:pokemonStatus];
  
  
  // Post Message to update |messageView_| in |GameMenuViewController|
  TrainerTamedPokemon * pokemon =
    [[TrainerController sharedInstance] pokemonOfSixAtIndex:selectedPokemonIndex_];
  NSInteger pokemonID = [pokemon.sid intValue];
  pokemon = nil;
  NSDictionary * messageInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithInt:pokemonID], @"pokemonID", nil];
  [self _postMessageForProcessType:kGameSystemProcessTypeReplacePokemon withMessageInfo:messageInfo];
  
  [self endTurn];
}

// Catching Wild Pokemon
- (void)_catchingWildPokemon
{
  NSLog(@"catching Wild Pokemon...");
  // Only 3 times for checking catching succeed or not,
  //   the end of third time means caught the Wild PM
  if (++catchingWildPokemonTimeCounter_ > 3) {
    [self _caughtWildPokemonSucceed:YES];
    return;
  }
  
  // Post notification to |GameMenuViewController| to run animation for checking Pokeball
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNPokeballChecking
                                                      object:self
                                                    userInfo:nil];
  
  // No mater caught Wild Pokemon succeed or not,
  //   if result come out, end checking turn.
  if ([self _hasDoneForCatchingWildPokemonResult])
    return;
  
  delayTime_ = 0;
}

// Return YES if caught Wild Pokemon succeed or failed.
//
//  There are many deciding factors to the capture of the Pokémon. These include that Pokémon's Maximum HP, Current HP, Status Ailment and it's Catch Rate. The Pokémon's Catch Rate is a number between 0 and 255, the higher the better. You can see the Catch Rates for the Pokémon in our Pokédex.
//
//  The formula for determining the capture of the Pokémon is as follows:
//
//    CatchValue = ((( 3 * Max HP - 2 * HP ) * (Catch Rate * Ball Modifier ) / (3 * Max HP) ) * Status Modifier
//
//  The Capture Value for that is then put through another equation to determine whether or not the Pokémon is to be captured.
//
//    Catch = 1048560 / √(√(16711680 / CatchValue)) = (220 - 24) / √(√((224 - 216) / CatchValue))
//
//  If |CatchValue| is 255, then capture is guaranteed. However, if not, then the second formula is taken into account. When you throw the Pokéball, and whenever the Pokéball shakes, a random number is generated and if the random number is greater than the value output through the above formula, then capture fails. If however, the random number is lower, then it will go to the next attempt and generate another random number. This is done for three shakes until the capture is complete.
//
//  Now the Maximum HP and Current HP of the Pokémon that you are about to catch are obviously not known by you, however that is what the colour coding is for and really the lower the hit points the better the chance
//
//
//  Status Ailments are a completely different amount however. Here is a small table stating the Values that each of the Status Ailments is given:
//
//    |STATUS    |FIGURE
//     Frozen:    2
//     Sleep:     2
//     Paralysis: 1.5
//     Burn:      1.5
//     Poison:    1.5
//     None:      1
//
//  Now this does have a major effect on the capture and could definately be the difference between capturing the Pokémon.
//
//
//  !!!TODO:
//     [[POKEBALL]] & [[CRITICAL CAPTURE]] is not involved.
//
//  REFERENCE: http://www.serebii.net/games/capture.shtml
//
//  [[POKEBALL]]
//  The final element of capturing Pokémon is the type of Pokéball that is used. Each of the Pokéballs either multiply or add to the figure before the final division of 256 is done in order to determine the final amount. Below are the Pokéballs and their effects and the amount they actually alter. The Pokéballs from Johto made from apricorns do not give boosts in the Ball Modifier, but rather the actual Capture Rate of the Pokémon, leading up to a maximum possible of 255. Click the Pokéball's icon or name to go to the ItemDex page for locations and more details
//
//
//  [[CRITICAL CAPTURE]]
//
//
//  !!!TODO:
//     |ballModifier| & |statusModifier| is not involved.
//
//
- (BOOL)_hasDoneForCatchingWildPokemonResult
{
  NSLog(@"has Done For Catching Wild Pokemon Result");
  // Formula effects
  // max & current HP values
  double maxHP = [[[self.enemyPokemon maxStatsInArray] objectAtIndex:0] doubleValue];
  double HP    = [self.enemyPokemon.hp doubleValue];
  // 0 <= |catchRate|(|rareness|) <= 255, the higher the number, the more likely a capture
  //   (0 means it cannot be caught by anything except a Master Ball).
  double catchRate      = [self.enemyPokemon.pokemon.rareness doubleValue];
  // effect of the type of Pokéball that is used
  double ballModifier   = 1;
  // effect of PM's current |status| (frozen:2, sleep:2, paralysis:1.5, burn:1.5, poison:1.5, none:1)
  double statusModifier = 1;
  
  // If CatchValue is 255, then capture is guaranteed.
  // However, if not, then the second formula is taken into account.
  // When you throw the Pokéball, and whenever the Pokéball shakes,
  //   a random number is generated and if the random number is greater than
  //   the value output through the above formula, then capture fails.
  // If however, the random number is lower, then it will go to the next attempt
  //   and generate another random number.
  // This is done for THREE shakes until the capture is complete.
  //
  BOOL succeed = NO;
  
  // FORMULA for |catchValue|
  //   CatchValue = ((( 3 * Max HP - 2 * HP ) * (Catch Rate * Ball Modifier)) / (3 * Max HP)) * Status Modifier
  double catchValue;
  catchValue = (((3 * maxHP - 2 * HP) * (catchRate * ballModifier)) / (3 * maxHP)) * statusModifier;
  NSLog(@"...catchValue:%f", catchValue);
  
  // if |catchValue| is 255, then capture is guaranteed, the bigger, the better
  if (round(catchValue) >= 255)
    succeed = YES;
  // if not, the second formula is taken into account
  else {
    // FORMULA for |catch|
    //   Catch = 1048560 / √(√(16711680 / CatchValue))
    double catch = 1048560 / sqrt(sqrt(16711680 / catchValue));
    NSLog(@"...catch:%f", catch);
    
    // if the random number is greater than |catchValue|, capture fails
    int randomNumber = arc4random();
    NSLog(@"...randomNumber:%d", randomNumber);
    if (randomNumber > catch)
      succeed = NO;
    // otherwise (the random number is lower), go to the next attempt
    //   and generate another random number.
    // if this case last to the 3rd time, the wild PM is caught
    else return NO;
  }
  
#ifdef KY_SUPER_POKEMON_MODE_ON
  // 100% catch Wild PM when in SUPER PM mode (DEBUG)
  succeed = YES;
#endif
  
  // if |catchValue >= 255|(SUCCEED) or |randomeNumber > catch|(FAILED)
  //   run this method to show the capture result
  [self _caughtWildPokemonSucceed:succeed];
  return YES;
}

// Caught Wild Pokemon succeed or not
- (void)_caughtWildPokemonSucceed:(BOOL)succeed
{
  NSLog(@"Caught Wild Pokemon %@!!!", succeed ? @"SUCCEED" : @"FAILED");
  catchingWildPokemonTimeCounter_ = 0;
  
  // If caught Wild Pokemon succeed, show Pokemon Info view
  if (succeed) {
    // Mark game has already END
    processType_ = kGameSystemProcessTypeBattleEnd;
    
    // Run Game Battle Event with Event:Caught WildPokemon
    [self runEventWithEventType:kGameBattleEventTypeCaughtWPM info:nil];
    // Play AUDIO
    [self.audioPlayer playForAudioType:kAudioBattlePMCaught afterDelay:.8];
    [self.audioPlayer playForAudioType:kAudioBattlePMCaughtSucceed afterDelay:1.8f];
  }
  else {
    // Post notification to |GameBattleLayer| & |GameMenuViewController| to get Pokemon out of Pokeball
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNPokeballLossWildPokemon object:self userInfo:nil];
    // Update message in |GameMenuViewController| to show Catching WildPokemon Failed
    [self _postMessageForProcessType:kGameSystemProcessTypeCathingWildPokemonFailed withMessageInfo:nil];
    // Play AUDIO
    [self.audioPlayer playForAudioType:kAudioBattlePMBrokeFree afterDelay:0];
  }
  delayTime_ = 0;
  [self endTurn];
}

// Run
- (BOOL)_isRunSucceed
{
  CGFloat runRate = 100.f;
  
  NSInteger playerPMLevel = [self.playerPokemon.level intValue];
  NSInteger enemyPMLevel  = [self.enemyPokemon.level  intValue];
  
  // If player Pokemon's level is lower than enemy Pokemon's level
  if (playerPMLevel < enemyPMLevel) {
    runRate -= (enemyPMLevel - playerPMLevel) * 2;
  }
  
  // If player Pokemon has some special status
  if (playerPokemonStatus_ != kPokemonStatusNormal)
    runRate -= 10.f;
  
  // Result of run
  if (arc4random() % 1000 / 10 > runRate)
    return NO;
  return YES;
}

// Post Message to |GameMenuViewController| to set message for game
- (void)_postMessageForProcessType:(GameSystemProcessType)processType
                  withMessageInfo:(NSDictionary *)messageInfo
{
  NSString * message = nil;
  
  switch (processType) {
    case kGameSystemProcessTypeFight: {
      NSInteger pokemonID = [[messageInfo valueForKey:@"pokemonID"] intValue];
      NSInteger moveID    = [[messageInfo valueForKey:@"moveID"] intValue];
      // Message: (<PokemonName> used <MoveName>, etc) to |messageView_| in |GameMenuViewController|
      message = [NSString stringWithFormat:@"%@ %@ %@",
                 KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", pokemonID]), nil),
                 NSLocalizedString(@"PMSMessage_used", nil),
                 KYResourceLocalizedString(([NSString stringWithFormat:@"PMSMove%.3d", moveID]), nil)];
      break;
    }
      
    case kGameSystemProcessTypeUseBagItem: {
      NSString * localizedNameHeader;
      if      (targetType_ & kBagQueryTargetTypeItem)       localizedNameHeader = @"PMSBagItem";
      else if (targetType_ & kBagQueryTargetTypeMedicine)   localizedNameHeader = @"PMSBagMedicine";
      else if (targetType_ & kBagQueryTargetTypePokeball)   localizedNameHeader = @"PMSBagPokeball";
      else if (targetType_ & kBagQueryTargetTypeTMHM)       localizedNameHeader = @"PMSBagTMHM";
      else if (targetType_ & kBagQueryTargetTypeBerry)      localizedNameHeader = @"PMSBagBerry";
      else if (targetType_ & kBagQueryTargetTypeMail)       localizedNameHeader = @"PMSBagMail";
      else if (targetType_ & kBagQueryTargetTypeBattleItem) localizedNameHeader = @"PMSBagBattleItem";
      else if (targetType_ & kBagQueryTargetTypeKeyItem)    localizedNameHeader = @"PMSBagKeyItem";
      else localizedNameHeader = @"";
      
      if (targetType_ & kBagQueryTargetTypePokeball) {
        // Message: (You throwed a <ItemName>!)
        message = [NSString stringWithFormat:@"%@ %@!",
                   NSLocalizedString(@"PMSMessageYouThrowedXXX", nil),
                   KYResourceLocalizedString(([NSString stringWithFormat:@"%@%.3d",
                                               localizedNameHeader, itemIndex_]), nil), nil];
      }
      else {
        NSInteger pokemonID = [[messageInfo valueForKey:@"pokemonID"] intValue];
        // Message: (You used <ItemName> to <PokemonName>)
        message = [NSString stringWithFormat:NSLocalizedString(@"PMSMessage:You used %@ to %@", nil),
                   KYResourceLocalizedString(([NSString stringWithFormat:@"%@%.3d",
                                               localizedNameHeader, itemIndex_]), nil),
                   KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", pokemonID]), nil)];
      }
      break;
    }
      
    case kGameSystemProcessTypeReplacePokemon: {
      NSInteger pokemonID = [[messageInfo valueForKey:@"pokemonID"] intValue];
      // Message: (You used <ItemName> to <PokemonName>)
      message = [NSString stringWithFormat:@"%@, %@!",
                 NSLocalizedString(@"PMSMessage_Go", nil),
                 KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", pokemonID]), nil), nil];
      break;
    }
      
    case kGameSystemProcessTypeCathingWildPokemonSucceed: {
      // Message: (Oh, you caught <WildPokemonName>)
      message = [NSString stringWithFormat:@"%@ %@!",
                 NSLocalizedString(@"PMSMessageCatchPokemonXXXSucceed", nil),
                 KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d",
                                     [self.enemyPokemon.sid intValue]]), nil), nil];
      break;
    }
      
    case kGameSystemProcessTypeCathingWildPokemonFailed: {
      // Message: (Oh, no! The <WildPokemonName> broke free!)
      message = [NSString stringWithFormat:@"%@ %@ %@!",
                 NSLocalizedString(@"PMSMessageCatchPokemonXXXFailed1", nil),
                 KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d",
                                             [self.enemyPokemon.sid intValue]]), nil),
                 NSLocalizedString(@"PMSMessageCatchPokemonXXXFailed3", nil), nil];
      break;
    }
      
    case kGameSystemProcessTypeEnemyPokemonFaint:
      // Message: (<WildPokemonName> faint!)
      message = [NSString stringWithFormat:@"%@ %@!",
                 KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d",
                                             [self.enemyPokemon.sid intValue]]), nil),
                 NSLocalizedString(@"PMSMessagePokemonFaint", nil), nil];
      break;
      
    case kGameSystemProcessTypePlayerPokemonFaint:
      // Message: (<PokemonName> faint!)
      message = [NSString stringWithFormat:@"%@ %@!",
                 KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d",
                                             [self.playerPokemon.sid intValue]]), nil),
                 NSLocalizedString(@"PMSMessagePokemonFaint", nil), nil];
      
      break;
      
    case kGameSystemProcessTypePlayerWin: {
      NSInteger expGained = [self _calculateExpGained];
      // Add gained EXP to Pokemon
      //   and post to |GameMenuViewController| to update EXP bar in Pokemon status view
      NSInteger levelsUp = [self.playerPokemon levelsUpWithGainedExp:expGained];
      NSInteger expMaxInBar = [self.playerPokemon.pokemon expToNextLevel:[self.playerPokemon.level intValue]];
      NSInteger expInBar    = expMaxInBar - [self.playerPokemon.toNextLevel intValue];
      NSDictionary * newUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kMoveRealTargetPlayer], @"target",
                                    [NSNumber numberWithInt:expInBar],              @"EXP", nil];
      NSLog(@"update Pokemon EXP - Notification Info:%@", newUserInfo);
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdatePokemonStatus
                                                          object:self
                                                        userInfo:newUserInfo];
      
      // Message: (You win! <PokemonName> gained <ExpValue> EXP. points.)
      message = [NSString stringWithFormat:@"%@  %@ %@ %d %@.",
                 NSLocalizedString(@"PMSMessagePlayerWin", nil),
                 KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d",
                                             [self.playerPokemon.sid intValue]]), nil),
                 NSLocalizedString(@"PMSMessagePokemonGainedXXXEXP1", nil),
                 expGained,
                 NSLocalizedString(@"PMSMessagePokemonGainedXXXEXP3", nil), nil];
      
      // If |levelsUp > 0|, run EVENT:Level UP to show view for Level Up Info
      if (levelsUp) {
        processType_ = kGameSystemProcessTypeBattleEnd;
        NSDictionary * info = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInt:levelsUp], @"levelsUp", nil];
        [self runEventWithEventType:kGameBattleEventTypeLevelUp info:info];
      }
      else [self runEventWithEventType:kGameBattleEventTypeWin info:nil];
//        [self _runFinalProcessForGameBattleEventType:kGameBattleEndEventTypeWin];
      break;
    }
      
    case kGameSystemProcessTypePlayerLose:
      // Message: (You Lose...)
      message = NSLocalizedString(@"PMSMessagePlayerLose", nil);
      break;
      
    case kGameSystemProcessTypeRun: {
      BOOL isRunSucceed = [[messageInfo valueForKey:@"isRunSucceed"] boolValue];
      if (isRunSucceed) message = NSLocalizedString(@"PMSMessageRunSucceed", nil);
      else              message = NSLocalizedString(@"PMSMessageRunFailed", nil);
      break;
    }
      
    case kGameSystemProcessTypeNone:
      break;
      
    default:
      break;
  }
  
  if (message == nil)
    return;
  
  // Post |message| to |messageView_| in |GameMenuViewController|
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             message,                        @"message",
                             [NSNumber numberWithInt:user_], @"user", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdateGameBattleMessage
                                                      object:self
                                                    userInfo:userInfo];
}

#pragma mark - Setting Methods

- (void)setSystemProcessOfFightWithUser:(GameSystemProcessUser)user
                              moveIndex:(NSInteger)moveIndex
{
  processType_ = kGameSystemProcessTypeFight;
  user_        = user;
  moveIndex_   = moveIndex;
}

- (void)setSystemProcessOfUseBagItemWithUser:(GameSystemProcessUser)user
                                  targetType:(BagQueryTargetType)targetType
                        selectedPokemonIndex:(NSInteger)selectedPokemonIndex
                                   itemIndex:(NSInteger)itemIndex
{
  processType_          = kGameSystemProcessTypeUseBagItem;
  user_                 = user;
  targetType_           = targetType;
  selectedPokemonIndex_ = selectedPokemonIndex;
  itemIndex_            = itemIndex;
}

- (void)setSystemProcessOfReplacePokemonWithUser:(GameSystemProcessUser)user
                            selectedPokemonIndex:(NSInteger)selectedPokemonIndex
{
  processType_          = kGameSystemProcessTypeReplacePokemon;
  selectedPokemonIndex_ = selectedPokemonIndex;
  user_                 = user;
}

- (void)setSystemProcessOfRunWithUser:(GameSystemProcessUser)user
{
  processType_ = kGameSystemProcessTypeRun;
  user_        = user;
}

#pragma mark - END Game Battle

// End battle with event
- (void)endBattleWithEventType:(GameBattleEndEventType)battleEndEventType
{
  // END Battle background audio
  [self.audioPlayer stopForAudioType:kAudioBattleStartVSWildPM];
  
  if (battleEndEventType & kGameBattleEndEventTypeWin) {
    // Stop battling audio & Run audio for VICTORY
    [self.audioPlayer stopForAudioType:kAudioBattlingVSWildPM];
    [self.audioPlayer playForAudioType:kAudioBattleVictoryVSWildPM afterDelay:0];
    // Update message in |GameMenuViewController| to show Player WIN
    [self _postMessageForProcessType:kGameSystemProcessTypePlayerWin withMessageInfo:nil];
  }
  else if (battleEndEventType & kGameBattleEndEventTypeLose) {
    // Update message in |GameMenuViewController| to show Player LOSE
    [self _postMessageForProcessType:kGameSystemProcessTypePlayerLose withMessageInfo:nil];
    [self runEventWithEventType:kGameBattleEventTypeWin info:nil];
  }
  else if (battleEndEventType & kGameBattleEndEventTypeRun) {
    BOOL isRunSucceed = [self _isRunSucceed];
    // Update message in |GameMenuViewController| to show run succeed or not
    NSDictionary * messageInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSNumber numberWithBool:isRunSucceed], @"isRunSucceed", nil];
    [self _postMessageForProcessType:kGameSystemProcessTypeRun withMessageInfo:messageInfo];
    
    // If run succeed, play AUDIO
    if (isRunSucceed)
      [self.audioPlayer playForAudioType:kAudioBattleRun afterDelay:.8f];
    
    // If run faild, do not END battle
    if (! isRunSucceed) {
      // Set Game System Process
      GameSystemProcess * gameSystemProcess = [GameSystemProcess sharedInstance];
      [gameSystemProcess setSystemProcessOfRunWithUser:kGameSystemProcessUserPlayer];
      [[GameStatusMachine sharedInstance] endStatus:kGameStatusPlayerTurn];
      [self endTurn];
      return;
    }
    [self _runFinalProcessForGameBattleEventType:battleEndEventType];
  }
  else if (battleEndEventType & kGameBattleEndEventTypeWildPokemonRun) {
    
  }
  else [self _runFinalProcessForGameBattleEventType:battleEndEventType];
}

// WIN
- (void)_playerWin
{
  [self endBattleWithEventType:kGameBattleEndEventTypeWin];
}

// LOSE
- (void)_playerLose
{
  [self endBattleWithEventType:kGameBattleEndEventTypeLose];
}

// confirm to level battle scene
//
// !!!TODO
//   might different type
//
- (void)_confirmToLevelBattleScene:(UITapGestureRecognizer *)recognizer
{
  [self _runFinalProcessForGameBattleEventType:kGameBattleEndEventTypeWin];
}

// end final battle process
- (void)_runFinalProcessForGameBattleEventType:(GameBattleEndEventType)battleEndEventType
{
  // Set system process type to |kGameSystemProcessTypeBattleEnd|
  processType_ = kGameSystemProcessTypeBattleEnd;
  
  // Notification to |GameMainViewController| to show view of |GameBattleEndViewController|
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [NSNumber numberWithInt:battleEndEventType], @"battleEndEventType", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNGameBattleEndWithEvent
                                                      object:self
                                                    userInfo:userInfo];
  
  // Save data for current battle Pokemon to Server
  [self.playerPokemon syncWithFlag:kDataModifyTamedPokemon | kDataModifyTamedPokemonBasic];
}

@end
