//
//  GameAudioPlayer.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/14/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PMAudioPlayer.h"


@interface PMAudioPlayer () {
 @private
  AVAudioPlayer * audioPlayer_;
}

@property (nonatomic, retain) AVAudioPlayer * audioPlayer;

- (NSString *)resourceNameForAuditType:(PMAudioType)audioType;

@end


@implementation PMAudioPlayer

@synthesize audioPlayer = audioPlayer_;

// Singleton
static PMAudioPlayer * gameAudioPlayer_ = nil;
+ (PMAudioPlayer *)sharedInstance {
  if (gameAudioPlayer_ != nil)
    return gameAudioPlayer_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gameAudioPlayer_ = [[PMAudioPlayer alloc] init];
  });
  return gameAudioPlayer_;
}

- (void)dealloc
{
  [audioPlayer_ release];
  audioPlayer_ = nil;
  
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
//    audioPlayer_ = [[AVAudioPlayer alloc] init];
  }
  return self;
}

#pragma mark - Public Methods

/*/ get ready to play the sound. happens automatically on play
- (void)prepareToPlayWithAudioType:(PMAudioType)audioType {
  
}*/

// Play
- (void)playWithAudioType:(PMAudioType)audioType {
  NSString * path = [[NSBundle mainBundle] pathForResource:[self resourceNameForAuditType:audioType]
                                                    ofType:@"mp3"];
  NSLog(@"Audio Path:%@", path);
  
  NSError * error;
  AVAudioPlayer * audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
  self.audioPlayer = audioPlayer;
  [audioPlayer release];
  self.audioPlayer.delegate = self;
  
  if (error) NSLog(@"!!!Error: %@", [error localizedDescription]);
  else [self.audioPlayer play];
}

// resume to play
- (void)resume {
  [audioPlayer_ play];
}

// pauses playback, but remains ready to play
- (void)pause {
  [audioPlayer_ pause];
}

 // stops playback. no longer ready to play
- (void)stop {
  [audioPlayer_ stop];
}

#pragma mark - Private Methods

- (NSString *)resourceNameForAuditType:(PMAudioType)audioType {
  NSString * resourceName;
  switch (audioType) {
    case kAudioGameGuide:
      resourceName = @"AudioGameGuide";
      break;
      
    case kAudioGamePMRecovery:
      resourceName = @"AudioGamePMRecovery";
      break;
      
    case kAudioGamePMEvolution:
      resourceName = @"AudioGamePMEvolution";
      break;
      
    case kAudioBattleStartVSWildPM:
      resourceName = @"AudioBattleStartVSWildPM";
      break;
      
    case kAudioBattleVictoryVSWildPM:
      resourceName = @"AudioBattleVictoryVSWildPM";
      break;
      
    default:
      break;
  }
  return resourceName;
}

#pragma mark - AVAudioPlayer Delegate

// Audio finished playing
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
  NSLog(@"Playing Audio Finished");
}

// Audio playing ERROR
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
  NSLog(@"Playing Audio Decode Error Occurred");
}

@end
