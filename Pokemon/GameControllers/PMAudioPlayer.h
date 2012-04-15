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
  kAudioGameGuide = 0,
  kAudioGamePMRecovery,
  kAudioGamePMEvolution,
  kAudioBattleStartVSWildPM,
  kAudioBattleVictoryVSWildPM,
}PMAudioType;

@interface PMAudioPlayer : NSObject <AVAudioPlayerDelegate>

+ (PMAudioPlayer *)sharedInstance;

- (void)prepareToPlayForAudioType:(PMAudioType)audioType; // get ready to play the sound. happens automatically on play
- (void)playForAudioType:(PMAudioType)audioType;          // play
- (void)resumeForAudioType:(PMAudioType)audioType;        // resume to play
- (void)pauseForAudioType:(PMAudioType)audioType;         // pauses playback, but remains ready to play
- (void)stopForAudioType:(PMAudioType)audioType;          // stops playback. no longer ready to play

- (void)preloadForBattleVSWildPokemon; // preload resources for battle VS. Wild Pokemon
//- (void)preloadForBattleVSTrainer;     // preload resources for battle VS. Trainer
//- (void)preloadForBattleVSGymLeader;   // preload resources for battle VS. Gym Leader
- (void)endBattle;

@end
