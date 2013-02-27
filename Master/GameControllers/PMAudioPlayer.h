//
//  GameAudioPlayer.h
//  iPokeMon
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
  kAudioGameUseMedicine,        // Use Medicine (Status Healer, HP/PP Restore)
  kAudioGamePMRecovery,         // All Pokemon's HP/PP/Status Recovery
  kAudioGamePMEvolution,        // Pokemon Evolution
  kAudioGamePMEvolutionDone,    // Pokemon Evolution done
  kAudioGameEND,                // === END mark - Game (App) Basic
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
  kAudioBattlingVSWildPM,       // - VS.WPM: Batting
  kAudioBattleVictoryVSWildPM,  // - VS.WPM: Player WIN in battle VS. Wild Pokemon
  kAudioBattleVSWildPmEND       // === END mark - Battle VS. Wild Pokemon
}PMAudioType;


@interface PMAudioPlayer : NSObject <AVAudioPlayerDelegate>

+ (PMAudioPlayer *)sharedInstance;

- (void)prepareToPlayForAudioType:(PMAudioType)audioType; // get ready to play the sound. happens automatically on play
- (void)playForAudioType:(PMAudioType)audioType afterDelay:(NSTimeInterval)delay; // play after delay
- (void)resumeForAudioType:(PMAudioType)audioType;        // resume to play
- (void)pauseForAudioType:(PMAudioType)audioType;         // pauses playback, but remains ready to play
- (void)stopForAudioType:(PMAudioType)audioType;          // stops playback. no longer ready to play

// Preload
- (void)preloadForAppBasic;            // preload App basic audios    (|kAudioGame...|)
- (void)preloadForBattleBasic;         // preload battle basic audios (|kAudioBattle...|)
- (void)preloadForBattleVSWildPokemon; // preload resources for battle VS. Wild Pokemon
//- (void)preloadForBattleVSTrainer;     // preload resources for battle VS. Trainer
//- (void)preloadForBattleVSGymLeader;   // preload resources for battle VS. Gym Leader

// Unload
- (void)cleanForBattleVSWildPokemon;   // unload resources particular for battle VS. Wild Pokemon
- (void)cleanForBattle;                // unload resources for Battle (include Battle Basic) when NO BATTLE
- (void)cleanAll;                      // unload all resources (include App Basic) when AUDIO NOT ALLOWED

@end
