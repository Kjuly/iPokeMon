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

//- (void)prepareToPlayWithAudioType:(PMAudioType)audioType; // get ready to play the sound. happens automatically on play
- (void)playWithAudioType:(PMAudioType)audioType; // play
- (void)resume;        // resume to play
- (void)pause;         // pauses playback, but remains ready to play
- (void)stop;          // stops playback. no longer ready to play

@end
