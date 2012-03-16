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

// Pokemon Status
typedef enum {
  kPokemonStatusNormal    = 0,
  kPokemonStatusBurn      = 1 << 0,
  kPokemonStatusConfused  = 1 << 1,
  kPokemonStatusFlinch    = 1 << 2,
  kPokemonStatusFreeze    = 1 << 3,
  kPokemonStatusParalyze  = 1 << 4,
  kPokemonStatusPoison    = 1 << 5,
  kPokemonStatusSleep     = 1 << 6
}PokemonStatus;

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

// Move Real Target
typedef enum {
  kMoveRealTargetNone   = 0,
  kMoveRealTargetEnemy  = 1 << 0,
  kMoveRealTargetPlayer = 1 << 1,
}MoveRealTarget;


@interface GameSystemProcess () {
@private
  // Pokemon transient status
  PokemonStatus playerPokemonStatus_;
  NSInteger     playerPokemonTransientExtraAttack_;
  NSInteger     playerPokemonTransientExtraDefense_;
  NSInteger     playerPokemonTransientExtraSpeAttack_;
  NSInteger     playerPokemonTransientExtraSpeDefense_;
  NSInteger     playerPokemonTransientExtraSpeed_;
  NSInteger     playerPokemonTransientExtraAccuracy_;
  NSInteger     playerPokemonTransientExtraEvasion_;
  PokemonStatus enemyPokemonStatus_;
  NSInteger     enemyPokemonTransientExtraAttack_;
  NSInteger     enemyPokemonTransientExtraDefense_;
  NSInteger     enemyPokemonTransientExtraSpeAttack_;
  NSInteger     enemyPokemonTransientExtraSpeDefense_;
  NSInteger     enemyPokemonTransientExtraSpeed_;
  NSInteger     enemyPokemonTransientExtraAccuracy_;
  NSInteger     enemyPokemonTransientExtraEvasion_;
  
  GameSystemProcessType processType_; // What action process the system to deal with
  GameSystemProcessUser user_; // Action (use move, bag item, etc) user
  NSInteger moveIndex_;        // If the action is using move, it's used
  
  BOOL      complete_;
  NSInteger delayTime_; // Delay time for every turn
}

- (void)fight;
- (void)calculateEffectForMove:(Move *)move;
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

#pragma mark - Private Methods

- (void)reset {
  complete_  = NO;
  delayTime_ = 0;
  
  // Set transient status for pokemons
  playerPokemonStatus_                   = kPokemonStatusNormal;
  playerPokemonTransientExtraAttack_     = 0;
  playerPokemonTransientExtraDefense_    = 0;
  playerPokemonTransientExtraSpeAttack_  = 0;
  playerPokemonTransientExtraSpeDefense_ = 0;
  playerPokemonTransientExtraSpeed_      = 0;
  playerPokemonTransientExtraAccuracy_   = 0;
  playerPokemonTransientExtraEvasion_    = 0;
  enemyPokemonStatus_                    = kPokemonStatusNormal;
  enemyPokemonTransientExtraAttack_      = 0;
  enemyPokemonTransientExtraDefense_     = 0;
  enemyPokemonTransientExtraSpeAttack_   = 0;
  enemyPokemonTransientExtraSpeDefense_  = 0;
  enemyPokemonTransientExtraSpeed_       = 0;
  enemyPokemonTransientExtraAccuracy_    = 0;
  enemyPokemonTransientExtraEvasion_     = 0;
}

// Fight
- (void)fight
{
  if (user_ == kGameSystemProcessUserNone || moveIndex_ == 0) {
     NSLog(@"!!! Exception: The Move has no user or the |moveIndex| is 0");
    return;
  }
  
  NSString * moveTarget;
  NSInteger pokemonHP;
  Move * move;
  
  //
  // Case the move user is Player
  //
  if (user_ == kGameSystemProcessUserPlayer) {
    move = [self.playerPokemon moveWithIndex:moveIndex_];
    
    // Calculate the effect of move
    [self calculateEffectForMove:move];
    
    // Post Message
    NSDictionary * messageInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  self.playerPokemon.sid, @"pokemonID",
                                  move.sid,               @"moveID", nil];
    [self postMessageForProcessType:kGameSystemProcessTypeFight withMessageInfo:messageInfo];
    [messageInfo release];
    
    // Apply move
    moveTarget = @"WildPokemon";
    pokemonHP = [self.enemyPokemon.currHP intValue];
    NSLog(@"EnemyPokemon HP: %d", pokemonHP);
    pokemonHP -= [move.baseDamage intValue];
    pokemonHP = pokemonHP > 0 ? pokemonHP : 0;
    self.enemyPokemon.currHP = [NSNumber numberWithInt:pokemonHP];
    NSLog(@"EnemyPokemon HP: %d", pokemonHP);
  }
  //
  // Case the move user is Enemy
  //
  else if (user_ == kGameSystemProcessUserEnemy) {
    move = [self.enemyPokemon moveWithIndex:moveIndex_];
    
    // Post Message
    NSDictionary * messageInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  self.enemyPokemon.sid, @"pokemonID",
                                  move.sid,              @"moveID", nil];
    [self postMessageForProcessType:kGameSystemProcessTypeFight withMessageInfo:messageInfo];
    [messageInfo release];
    
    // Apply move
    moveTarget = @"MyPokemon";
    pokemonHP = [self.playerPokemon.currHP intValue];
    NSLog(@"PlayerPokemon HP: %d", pokemonHP);
    pokemonHP -= [move.baseDamage intValue];
    pokemonHP = pokemonHP > 0 ? pokemonHP : 0;
    self.playerPokemon.currHP = [NSNumber numberWithInt:pokemonHP];
    NSLog(@"PlayerPokemon HP: %d", pokemonHP);
  }
  else { NSLog(@"!!! Exception: The Move has no user"); }
  
  // Post to |GameMenuViewController| to update pokemon status view
  NSDictionary * newUserInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                moveTarget, @"target", [NSNumber numberWithInt:pokemonHP], @"HP", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUpdatePokemonStatus object:self userInfo:newUserInfo];
  [newUserInfo release];
  
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
  MoveRealTarget moveRealTarget;
  switch ([move.target intValue]) {
    case kMoveTargetSinglePokemonOtherThanTheUser:
      // 0 - 选择: Single Pokemon other than the user
      moveRealTarget = kMoveRealTargetEnemy;
      break;
      
    case kMoveTargetNone:
      // 1 - 最近: No target
      moveRealTarget = kMoveRealTargetEnemy;
      break;
      
    case kMoveTargetOneOpposingPokemonSelectedAtRandom:
      // 2 - 随机: One opposing Pokemon selected at random
      moveRealTarget = kMoveRealTargetEnemy;
      break;
      
    case kMoveTargetAllOpposingPokemon:
      // 4 - 二体: All opposing Pokemon
      // Only apply move to different gender pokemon
      if ([self.playerPokemon.gender intValue] ^ [self.enemyPokemon.gender intValue])
        moveRealTarget = kMoveRealTargetEnemy;
      else
        moveRealTarget = kMoveRealTargetNone;
      break;
      
    case kMoveTargetAllPokemonOtherThanTheUser:
      // 8 - 全体: All Pokemon other than the user (All non-users)
      moveRealTarget = kMoveRealTargetEnemy;
      break;
      
    case kMoveTargetUser:
      // 10 - 自身: User
      moveRealTarget = kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetBothSides:
      // 20 - 全场: Both sides (e.g. Light Screen, Reflect, Heal Bell)
      moveRealTarget = kMoveRealTargetEnemy | kMoveRealTargetPlayer;
      break;
      
    case kMoveTargetUserSide:
      // 40 - 己方: User's side
      moveRealTarget = kMoveRealTargetPlayer;
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
