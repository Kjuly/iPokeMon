//
//  GameSystemProcess.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameSystemProcess.h"

#import "GlobalNotificationConstants.h"
#import "GameStatusMachine.h"
#import "TrainerTamedPokemon+DataController.h"
#import "WildPokemon+DataController.h"
#import "Move.h"


// System Process Type
typedef enum {
  kGameSystemProcessTypeNone           = 0,
  kGameSystemProcessTypeFight          = 1,
  kGameSystemProcessTypeUseBagItem     = 2,
  kGameSystemProcessTypeReplacePokemon = 3,
  kGameSystemProcessTypeRun            = 4
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
  // Pokemon transient status
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
  
  GameSystemProcessType processType_; // What action process the system to deal with
  GameSystemProcessUser user_; // Action (use move, bag item, etc) user
  NSInteger moveIndex_;        // If the action is using move, it's used
  
  BOOL      complete_;
  NSInteger delayTime_; // Delay time for every turn
}

- (void)setTransientStatusPokemonForUser:(GameSystemProcessUser)user;
- (void)fight;
- (void)calculateEffectForMove:(Move *)move;
- (NSInteger)calculateDamageForMove:(Move *)move;
//- (void)MoveTargetSinglePokemonOtherThanTheUser;
//- (void)MoveTargetNone;
//- (void)MoveTargetOneOpposingPokemonSelectedAtRandom;
//- (void)MoveTargetAllOpposingPokemon;
//- (void)MoveTargetAllPokemonOtherThanTheUser;
//- (void)MoveTargetUser;
//- (void)MoveTargetBothSides;
//- (void)MoveTargetUserSide;
//- (void)MoveTargetOpposingPokemonSide;
//- (void)MoveTargetUserPartner;
//- (void)MoveTargetPlayerChoiceOfUserOrUserPartner;
//- (void)MoveTargetSinglePokemonOnOpponentSide;
- (void)useBagItem;
- (void)replacePokemon;
- (void)run;
- (void)postMessageForProcessType:(GameSystemProcessType)processType withMessageInfo:(NSDictionary *)messageInfo;

@end


@implementation GameSystemProcess

@synthesize playerPokemon = playerPokemon_;
@synthesize enemyPokemon  = enemyPokemon_;

static GameSystemProcess * gameSystemProcess = nil;

+ (GameSystemProcess *)sharedInstance {
  if (gameSystemProcess != nil)
    return gameSystemProcess;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gameSystemProcess = [[GameSystemProcess alloc] init];
  });
  return gameSystemProcess;
}

- (void)dealloc
{
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
    [self reset];
    
    processType_ = kGameSystemProcessTypeNone;
    user_        = kGameSystemProcessUserNone;
    moveIndex_   = 0;
  }
  return self;
}

- (void)prepareForNewScene
{
  // Reset HP for enemy pokemon
  NSArray * stats = self.enemyPokemon.maxStats;
  NSInteger currHP = [[stats objectAtIndex:0] intValue];
  self.enemyPokemon.currHP = [NSNumber numberWithInt:currHP];
  stats = nil;
}

- (void)update:(ccTime)dt
{
  delayTime_ += 100 * dt;
  if (complete_) {
    if (delayTime_ < 200) return;
    [[GameStatusMachine sharedInstance] endStatus:kGameStatusSystemProcess];
    [self reset];
  }
  else {
    switch (processType_) {
      case kGameSystemProcessTypeFight:
        [self fight];
        break;
      case kGameSystemProcessTypeUseBagItem:
        [self useBagItem];
        break;
      case kGameSystemProcessTypeReplacePokemon:
        [self replacePokemon];
        break;
      case kGameSystemProcessTypeRun:
        [self run];
        break;
      default:
        break;
    }
  }
}

- (void)endTurn {
  complete_ = YES;
}

- (void)reset {
  complete_  = NO;
  delayTime_ = 0;
  
  [self setTransientStatusPokemonForUser:kGameSystemProcessUserPlayer];
  [self setTransientStatusPokemonForUser:kGameSystemProcessUserEnemy];
}

#pragma mark - Private Methods

// Set transient status for pokemons
// Pokemons stats:
//   0. HP
//   1. Attack
//   2. Defense
//   3. Speed
//   4. Special Attack
//   5. Special Defense
// 
- (void)setTransientStatusPokemonForUser:(GameSystemProcessUser)user {
  NSArray * stats;
  if (user == kGameSystemProcessUserPlayer) {
    stats = self.playerPokemon.maxStats;
  }
  else if (user == kGameSystemProcessUserEnemy) {
    stats = self.enemyPokemon.maxStats;
  }
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
- (void)fight
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
  else { NSLog(@"!!! Exception: The Move has no user"); }
  
  // Calculate the effect of move
  [self calculateEffectForMove:move];
  
  // Post Message to update |messageView_| in |GameMenuViewController|
  NSDictionary * messageInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithInt:pokemonID], @"pokemonID",
                                move.sid,                           @"moveID", nil];
  [self postMessageForProcessType:kGameSystemProcessTypeFight withMessageInfo:messageInfo];
  [messageInfo release];
  
  move = nil;
  [self endTurn];
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
- (void)calculateEffectForMove:(Move *)move
{
  // Real move target
  //  1vs1: 00-无, 01-对方, 10-自身, 11-双方
  //  2vs2: ...
  MoveRealTarget moveRealTarget; // Real move target
  
  switch ([move.target intValue]) {
    case kMoveTargetSinglePokemonOtherThanTheUser:
      // 0 - 选择: Single Pokemon other than the user
      moveRealTarget = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetEnemy : kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetNone:
      // 1 - 最近: No target
      moveRealTarget = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetEnemy : kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetOneOpposingPokemonSelectedAtRandom:
      // 2 - 随机: One opposing Pokemon selected at random
      moveRealTarget = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetEnemy : kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetAllOpposingPokemon:
      // 4 - 二体: All opposing Pokemon
      // Only apply move to different gender pokemon
      if ([self.playerPokemon.gender intValue] ^ [self.enemyPokemon.gender intValue])
        moveRealTarget = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetEnemy : kMoveRealTargetPlayer;
      else
        moveRealTarget = kMoveRealTargetNone;
      break;
      
    case kMoveTargetAllPokemonOtherThanTheUser:
      // 8 - 全体: All Pokemon other than the user (All non-users)
      moveRealTarget = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetEnemy : kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetUser:
      // 10 - 自身: User
      moveRealTarget = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetPlayer : kMoveRealTargetEnemy;
      break;
      
    case kMoveTargetBothSides:
      // 20 - 全场: Both sides (e.g. Light Screen, Reflect, Heal Bell)
      moveRealTarget = kMoveRealTargetEnemy | kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetUserSide:
      // 40 - 己方: User's side
      moveRealTarget = (user_ == kGameSystemProcessUserPlayer) ? kMoveRealTargetPlayer : kMoveRealTargetEnemy;
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
      moveRealTarget = kMoveRealTargetEnemy;
      break;
  }
  
  // Move calculation result values
  // Delta values for user's & opposing pokemon
  __block PokemonStatus userPokemonStatusDelta                       = 0;
  __block NSInteger     userPokemonHPDelta                           = 0;
  __block NSInteger     userPokemonTransientAttackDelta         = 0;
  __block NSInteger     userPokemonTransientDefenseDelta        = 0;
  __block NSInteger     userPokemonTransientSpeAttackDelta      = 0;
  __block NSInteger     userPokemonTransientSpeDefenseDelta     = 0;
  __block NSInteger     userPokemonTransientSpeedDelta          = 0;
  __block NSInteger     userPokemonTransientAccuracyDelta       = 0;
  __block NSInteger     userPokemonTransientEvasionDelta        = 0;
  __block PokemonStatus opposingPokemonStatusDelta                   = 0;
  __block NSInteger     opposingPokemonHPDelta                       = 0;
  __block NSInteger     opposingPokemonTransientAttackDelta     = 0;
  __block NSInteger     opposingPokemonTransientDefenseDelta    = 0;
  __block NSInteger     opposingPokemonTransientSpeAttackDelta  = 0;
  __block NSInteger     opposingPokemonTransientSpeDefenseDelta = 0;
  __block NSInteger     opposingPokemonTransientSpeedDelta      = 0;
  __block NSInteger     opposingPokemonTransientAccuracyDelta   = 0;
  __block NSInteger     opposingPokemonTransientEvasionDelta    = 0;
  
  // Player & enemy pokemon's HP
  __block NSInteger playerPokemonHP = [self.playerPokemon.currHP intValue];
  __block NSInteger enemyPokemonHP  = [self.enemyPokemon.currHP  intValue];
  
  // Some type of move effect need to be calculated depend on current status,
  // so, if values are calculated in |switch ([move.effectCode intValue])| directly,
  // there's no need to call |^updateValues| block anymore, so mark it.
  BOOL valuesHaveBeenCalculated = NO; 
  
  // Calculate the damage
  NSInteger moveDamage = [self calculateDamageForMove:move];        // Move damage
  
  float          randomValue        = arc4random() % 1000 / 10;     // Random value for calculating % chance
  NSInteger      stage              = 1;                            // Used in "Raises Attack UP 1 Stage"
  MoveRealTarget statusUpdateTarget = moveRealTarget;               // Target for updating pokemon status
  
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
      if (moveRealTarget == kMoveRealTargetEnemy) {
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
      if (moveRealTarget == kMoveRealTargetEnemy) {
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
      [self setTransientStatusPokemonForUser:kGameSystemProcessUserPlayer];
      [self setTransientStatusPokemonForUser:kGameSystemProcessUserEnemy];
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
      if (moveRealTarget == kMoveRealTargetEnemy) enemyPokemonHP  = 0;
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
      if (moveRealTarget == kMoveRealTargetEnemy) {
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
      if (moveRealTarget == kMoveRealTargetEnemy) {
        NSInteger enemyPokemonHPMax = [[self.enemyPokemon.maxStats objectAtIndex:0] intValue];
        enemyPokemonHP += enemyPokemonHPMax / 2;
        if (enemyPokemonHP > enemyPokemonHPMax) enemyPokemonHP = enemyPokemonHPMax;
      }
      else {
        NSInteger playerPokemonHPMax = [[self.playerPokemon.maxStats objectAtIndex:0] intValue];
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
    if (target == kMoveRealTargetEnemy) {
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
    NSInteger playerPokemonHPMax = [[self.playerPokemon.maxStats objectAtIndex:0] intValue];
    if (playerPokemonHP > playerPokemonHPMax) playerPokemonHP = playerPokemonHPMax;
    NSInteger enemyPokemonHPMax = [[self.enemyPokemon.maxStats objectAtIndex:0] intValue];
    if (enemyPokemonHP > enemyPokemonHPMax) enemyPokemonHP = enemyPokemonHPMax;
  };
  
  // If |valueHasBeenCalculated == NO|, i.e. value need to be calculated next
  if (! valuesHaveBeenCalculated) {
    // Update values for player & enemy pokemon
    if (moveRealTarget & (kMoveRealTargetEnemy | kMoveRealTargetPlayer)) {
      if (user_ == kGameSystemProcessUserPlayer)     updateValues(kMoveRealTargetEnemy);
      else                                           updateValues(kMoveRealTargetPlayer);
    }
    else if (moveRealTarget & kMoveRealTargetEnemy)  updateValues(kMoveRealTargetEnemy);
    else if (moveRealTarget & kMoveRealTargetPlayer) updateValues(kMoveRealTargetPlayer);
  }
  
  // Set HP back to |playerPokemon_| & |enemyPokemon_|
  self.playerPokemon.currHP = [NSNumber numberWithInt:playerPokemonHP];
  self.enemyPokemon.currHP  = [NSNumber numberWithInt:enemyPokemonHP];
  
  // Post to |GameMenuViewController| to update pokemon status view
  NSDictionary * newUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSNumber numberWithInt:statusUpdateTarget],   @"target",
                                [NSNumber numberWithInt:playerPokemonStatus_], @"playerPokemonStatus",
                                self.playerPokemon.currHP,                     @"playerPokemonHP",
                                [NSNumber numberWithInt:enemyPokemonStatus_],  @"enemyPokemonStatus",
                                self.enemyPokemon.currHP,                      @"enemyPokemonHP", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdatePokemonStatus object:self userInfo:newUserInfo];
  [newUserInfo release];
}

// Calculate the move damage
- (NSInteger)calculateDamageForMove:(Move *)move
{
  if ([move.baseDamage intValue] == 0)
    return 0;
  
  NSInteger damage
  = round(
          [move.baseDamage intValue] // Base damage
          * (abs([self.playerPokemon.level intValue] - [self.enemyPokemon.level intValue]) + 1) // Delta level + 1
          );
  
  return damage;
}

// Use bag item
- (void)useBagItem
{
}

// Replace pokemon
- (void)replacePokemon
{
}

// Run
- (void)run
{
}

// Post Message to |GameMenuViewController| to set message for game
- (void)postMessageForProcessType:(GameSystemProcessType)processType withMessageInfo:(NSDictionary *)messageInfo
{
  switch (processType) {
    case kGameSystemProcessTypeFight: {
      NSInteger pokemonID = [[messageInfo valueForKey:@"pokemonID"] intValue];
      NSInteger moveID    = [[messageInfo valueForKey:@"moveID"] intValue];
      // Post message: (<PokemonName> used <MoveName>, etc) to |messageView_| in |GameMenuViewController|
      NSString * message = [NSString stringWithFormat:@"%@ %@ %@",
                            NSLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", pokemonID]), nil),
                            NSLocalizedString(@"PMS_used", nil),
                            NSLocalizedString(([NSString stringWithFormat:@"PMSMove%.3d", moveID]), nil)];
      NSDictionary * messageInfo = [NSDictionary dictionaryWithObject:message forKey:@"message"];
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdateGameBattleMessage
                                                          object:self
                                                        userInfo:messageInfo];
      break;
    }
      
    case kGameSystemProcessTypeUseBagItem:
      break;
      
    case kGameSystemProcessTypeReplacePokemon:
      break;
      
    case kGameSystemProcessTypeRun:
      break;
      
    case kGameSystemProcessTypeNone:
      break;
      
    default:
      break;
  }
}

#pragma mark - Setting Methods

- (void)setSystemProcessOfFightWithUser:(GameSystemProcessUser)user moveIndex:(NSInteger)moveIndex
{
  processType_ = kGameSystemProcessTypeFight;
  user_        = user;
  moveIndex_   = moveIndex;
}

- (void)setSystemProcessOfUseBagItemWithUser:(GameSystemProcessUser)user
{
  processType_ = kGameSystemProcessTypeUseBagItem;
  user_        = user;
}

- (void)setSystemProcessOfReplacePokemonWithUser:(GameSystemProcessUser)user
{
  processType_ = kGameSystemProcessTypeReplacePokemon;
  user_        = user;
}

- (void)setSystemProcessOfRunWithUser:(GameSystemProcessUser)user
{
  processType_ = kGameSystemProcessTypeRun;
  user_        = user;
}

@end
