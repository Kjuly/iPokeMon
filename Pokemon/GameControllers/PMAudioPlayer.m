//
//  GameAudioPlayer.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/14/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PMAudioPlayer.h"

#import "LoadingManager.h"

typedef enum {
  kAudioActionPrepareToPlay = 0,
  kAudioActionPlay,
  kAudioActionPause,
  kAudioActionStop
}PMAudioAction;

@interface PMAudioPlayer () {
 @private
  NSMutableDictionary * audioPlayers_;
  LoadingManager      * loadingManager_;
}

@property (nonatomic, copy)   NSMutableDictionary * audioPlayers;
@property (nonatomic, retain) LoadingManager      * loadingManager;

- (void)_addAudioPlayerForAudioType:(PMAudioType)audioType withAction:(PMAudioAction)audioAction;
- (NSString *)_resourceNameForAudioType:(PMAudioType)audioType;

@end


@implementation PMAudioPlayer

@synthesize audioPlayers   = audioPlayers_;
@synthesize loadingManager = loadingManager_;

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
  [audioPlayers_ release];
  self.audioPlayers = nil;
  
  [super dealloc];
}

- (id)init {
  if (self = [super init]) {
    audioPlayers_ = [[NSMutableDictionary alloc] init];
    self.loadingManager = [LoadingManager sharedInstance];
  }
  return self;
}

#pragma mark - Public Methods
#pragma mark - Audio Player Manager

// get ready to play the sound. happens automatically on play
- (void)prepareToPlayForAudioType:(PMAudioType)audioType {
  NSString * audioResourceName = [self _resourceNameForAudioType:audioType];
  AVAudioPlayer * audioPlayer = [self.audioPlayers objectForKey:audioResourceName];
  if (audioPlayer != nil) {
    [audioPlayer prepareToPlay];
    return;
  }
  
  // If the Audio Player for type not exist, add new for this type
  [self _addAudioPlayerForAudioType:audioType withAction:kAudioActionPrepareToPlay];
  [[self.audioPlayers objectForKey:audioResourceName] prepareToPlay];
}

// Play
- (void)playForAudioType:(PMAudioType)audioType afterDelay:(NSTimeInterval)delay {
  NSString * audioResourceName = [self _resourceNameForAudioType:audioType];
  AVAudioPlayer * audioPlayer = [self.audioPlayers objectForKey:audioResourceName];
  if (audioPlayer != nil) {
    if (delay == 0) [audioPlayer play];
    else            [audioPlayer playAtTime:(audioPlayer.deviceCurrentTime + delay)];
    return;
  }
  
  // If the Audio Player for type not exist, add new for this type
  [self _addAudioPlayerForAudioType:audioType withAction:kAudioActionPlay];
}

// resume to play
- (void)resumeForAudioType:(PMAudioType)audioType {
  NSString * audioResourceName = [self _resourceNameForAudioType:audioType];
  AVAudioPlayer * audioPlayer = [self.audioPlayers objectForKey:audioResourceName];
  if (audioPlayer != nil) {
    [audioPlayer play];
    return;
  }
  
  // If the Audio Player for type not exist, add new for this type
  [self _addAudioPlayerForAudioType:audioType withAction:kAudioActionPlay];
}

// pauses playback, but remains ready to play
- (void)pauseForAudioType:(PMAudioType)audioType {
  NSString * audioResourceName = [self _resourceNameForAudioType:audioType];
  AVAudioPlayer * audioPlayer = [self.audioPlayers objectForKey:audioResourceName];
  if (audioPlayer != nil) {
    [audioPlayer pause];
    return;
  }
  
  // If the Audio Player for type not exist, add new for this type
  [self _addAudioPlayerForAudioType:audioType withAction:kAudioActionPause];
}

 // stops playback. no longer ready to play
- (void)stopForAudioType:(PMAudioType)audioType {
  NSString * audioResourceName = [self _resourceNameForAudioType:audioType];
  AVAudioPlayer * audioPlayer = [self.audioPlayers objectForKey:audioResourceName];
  if (audioPlayer != nil) {
    [audioPlayer stop];
    return;
  }
  
  // If the Audio Player for type not exist, add new for this type
  [self _addAudioPlayerForAudioType:audioType withAction:kAudioActionStop];
}

#pragma mark - Preloads

// preload App basic audios (|kAudioGame...|)
- (void)preloadForAppBasic {
  for (PMAudioType audioType = kAudioNone + 1; audioType < kAudioGameEND; ++audioType)
    if ([self.audioPlayers objectForKey:[self _resourceNameForAudioType:audioType]] == nil)
      [self _addAudioPlayerForAudioType:audioType
                             withAction:kAudioActionPrepareToPlay];
}

// preload game basic audios (|kAudioBattle...|)
- (void)preloadForBattleBasic {
  for (PMAudioType audioType = kAudioGameEND + 1; audioType < kAudioBattleEND; ++audioType)
    if ([self.audioPlayers objectForKey:[self _resourceNameForAudioType:audioType]] == nil)
      [self _addAudioPlayerForAudioType:audioType
                             withAction:kAudioActionPrepareToPlay];
}

// Preload resources for battle VS. Wild Pokemon
- (void)preloadForBattleVSWildPokemon {
  for (PMAudioType audioType = kAudioBattleEND + 1; audioType < kAudioBattleVSWildPmEND; ++audioType)
    if ([self.audioPlayers objectForKey:[self _resourceNameForAudioType:audioType]] == nil)
      [self _addAudioPlayerForAudioType:audioType
                             withAction:kAudioActionPrepareToPlay];
  [self preloadForBattleBasic];
}

// Unload resources particular for battle VS. Wild Pokemon when this type battle END
- (void)cleanForBattleVSWildPokemon {
  for (PMAudioType audioType = kAudioBattleEND + 1; audioType < kAudioBattleVSWildPmEND; ++audioType)
    if ([self.audioPlayers objectForKey:[self _resourceNameForAudioType:audioType]] != nil)
      [self.audioPlayers removeObjectForKey:[self _resourceNameForAudioType:audioType]];
}

// unload resources for Battle (include Battle Basic) when NO BATTLE
- (void)cleanForBattle {
  for (PMAudioType audioType = kAudioGameEND + 1; audioType < kAudioBattleVSWildPmEND; ++audioType)
    if ([self.audioPlayers objectForKey:[self _resourceNameForAudioType:audioType]] != nil)
      [self.audioPlayers removeObjectForKey:[self _resourceNameForAudioType:audioType]];
}

// unload all resources (include App Basic) when AUDIO NOT ALLOWED
- (void)cleanAll {
  [self.audioPlayers removeAllObjects];
}

#pragma mark - Private Methods

// Add a new audio player to |audioPlayers_|
- (void)_addAudioPlayerForAudioType:(PMAudioType)audioType
                         withAction:(PMAudioAction)audioAction {
  // Add resource unit to loading queue
//  [self.loadingManager addResourceToLoadingQueue];
  [self.loadingManager showOverView];
  
  // Load audio resource
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSLog(@"!!!AudioPlayer for AudioType::|%@| not exists, adding new......",
          [self _resourceNameForAudioType:audioType]);
    NSString * audioResourceName = [self _resourceNameForAudioType:audioType];
    
    NSError * error;
    AVAudioPlayer * audioPlayer = [AVAudioPlayer alloc];
    [audioPlayer initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:audioResourceName withExtension:@"mp3"]
                                 error:&error];
    [audioPlayer setDelegate:self];
    // Set LOOP for special AUDIO
    if (audioType == kAudioBattlingVSWildPM) {
      [audioPlayer setNumberOfLoops:-1];
    }
    
    if (error) NSLog(@"!!!Error: %@", [error localizedDescription]);
    else {
      [self.audioPlayers setObject:audioPlayer forKey:audioResourceName];
      if      (audioAction == kAudioActionPlay)          [audioPlayer play];
      else if (audioAction == kAudioActionPrepareToPlay) [audioPlayer prepareToPlay];
    }
    [audioPlayer release];
    audioPlayer = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      // Pop resource unit from loading queue
//      [self.loadingManager popResourceFromLoadingQueue];
      [self.loadingManager hideOverView];
    });
  });
}

// Audio resource name for the audio type
- (NSString *)_resourceNameForAudioType:(PMAudioType)audioType {
  NSString * resourceName;
  
  switch (audioType) {
    ///
    // Game (APP)
    case kAudioGameERROR:
      break;
      
    case kAudioGameGuide: // Newbie Guide
      resourceName = @"AudioGameGuide";
      break;
      
    case kAudioGameUseMedicine: // Use Medicine (Status Healer, HP/PP Restore)
      resourceName = @"AudioBattleUseMedicine";
      break;
      
    case kAudioGamePMRecovery: // All Pokemon's HP/PP/Status Recovery
      resourceName = @"AudioGamePMRecovery";
      break;
      
    case kAudioGamePMEvolution: // Pokemon Evolution
      resourceName = @"AudioGamePMEvolution";
      break;
      
    case kAudioGamePMEvolutionDone: // Pokemon Evolution done
      resourceName = @"AudioGamePMEvolutionDone"; // Not added!!!
      break;
      
    ///
    // Battle
    case kAudioBattlePMLevelUp: // Pokemon Level Up
      resourceName = @"AudioBattlePMLevelUp";
      break;
      
    case kAudioBattleThrowPokeball: // Throw Pokeball (Replace Pokemon / Try to catch Wild Pokemon)
      resourceName = @"AudioBattleThrowPokeball";
      break;
      
    case kAudioBattlePMCaughtChecking: // When Caughting Wild Pokemon, do checking caught or not
      resourceName = @"AudioBattlePMCaughtChecking";
      break;
      
    case kAudioBattlePMCaught: // Checking done with Wild Pokemon Caught
      resourceName = @"AudioBattlePMCaught";
      break;
      
    case kAudioBattlePMCaughtSucceed: // Wild Pokemon Caught succeed
      resourceName = @"AudioBattlePMCaughtSucceed";
      break;
      
    case kAudioBattlePMBrokeFree: // Wild Pokemon broke free from Pokeball
      resourceName = @"AudioBattlePMBrokeFree";
      break;
      
    case kAudioBattleRun: // Player RUN in battle VS. Wild Pokemon
      resourceName = @"AudioBattleRun";
      break;
      
    case kAudioMoveBasicAttack: // MOVE: basic attack
      resourceName = @"AudioMoveBasicAttack";
      break;
      
    ////
    // - VS.WPM (Wild PokeMon)
    case kAudioBattleStartVSWildPM:   // - VS.WPM:Battle start with Wild Pokemon
      resourceName = @"AudioBattleStartVSWildPM";
      break;
      
    case kAudioBattlingVSWildPM:      // - VS.WPM: Batting
      resourceName = @"AudioBattlingVSWildPM";
      break;
      
    case kAudioBattleVictoryVSWildPM: // - VS.WPM:Player WIN in battle VS. Wild Pokemon
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
  NSLog(@"...Playing Audio Finished...");
}

// Audio playing ERROR
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
  NSLog(@"!!!ERROR::Playing Audio Decode Error Occurred");
}

@end
