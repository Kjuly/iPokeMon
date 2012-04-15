//
//  GameAudioPlayer.h
//  Pokemon
//
//  Created by Kaijie Yu on 4/14/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

typedef enum {
  kAudioNone = 0,
  kAudioGameERROR,              // ERROR
  kAudioGameGuide,              // Newbie Guide
  kAudioGamePMRecovery,         // All Pokemon's HP/PP/Status Recovery
  kAudioGamePMEvolution,        // Pokemon Evolution
  kAudioGamePMEvolutionDone,    // Pokemon Evolution done
  kAudioGameEND,                // === END mark - Game (App) Basic
  kAudioBattleUseMedicine,      // Use Medicine (Status Healer, HP/PP Restore)
  kAudioBattlePMLevelUp,        // Pokemon Level Up
  kAudioBattleThrowPokeball,    // Throw Pokeball (Replace Pokemon / Try to catch Wild Pokemon)
  kAudioBattlePMCaughtChecking, // When Caughting Wild Pokemon, do checking caught or not
  kAudioBattlePMCaught,         // Checking done with Wild Pokemon Caught
  kAudioBattlePMCaughtSucceed,  // Wild Pokemon Caught succeed
  kAudioBattlePMBrokeFree,      // Wild Pokemon broke free from Pokeball
  kAudioBattleRun,              // Player RUN in battle VS. Wild Pokemon
  kAudioMoveBasicAttack,        // MOVE: basic attack
  kAudioBattleEND,              // === END mark - Battle Basic
  kAudioBattleStartVSWildPM,    // - VS.WPM: Battle start with Wild Pokemon
  kAudioBattleVictoryVSWildPM,  // - VS.WPM: Player WIN in battle VS. Wild Pokemon
  kAudioBattleVSWildPmEND       // === END mark - Battle VS. Wild Pokemon
}PMAudioType;

@interface PMAudioPlayer : NSObject <AVAudioPlayerDelegate>

+ (PMAudioPlayer *)sharedInstance;

- (void)prepareToPlayForAudioType:(PMAudioType)audioType; // get ready to play the sound. happens automatically on play
- (void)playForAudioType:(PMAudioType)audioType;          // play
- (void)resumeForAudioType:(PMAudioType)audioType;        // resume to play
- (void)pauseForAudioType:(PMAudioType)audioType;         // pauses playback, but remains ready to play
- (void)stopForAudioType:(PMAudioType)audioType;          // stops playback. no longer ready to play

- (void)preloadForAppBasic;            // preload App basic audios    (|kAudioGame...|)
- (void)preloadForBattleBasic;         // preload battle basic audios (|kAudioBattle...|)
- (void)preloadForBattleVSWildPokemon; // preload resources for battle VS. Wild Pokemon
//- (void)preloadForBattleVSTrainer;     // preload resources for battle VS. Trainer
//- (void)preloadForBattleVSGymLeader;   // preload resources for battle VS. Gym Leader
- (void)endBattle;

@end
