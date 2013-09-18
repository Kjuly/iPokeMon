//
//  GameAudioPlayer.m
//  iPokeMon
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
  ResourceManager     * resourceManager_;
  LoadingManager      * loadingManager_;
}

@property (nonatomic, copy)   NSMutableDictionary * audioPlayers;
@property (nonatomic, strong) ResourceManager     * resourceManager;
@property (nonatomic, strong) LoadingManager      * loadingManager;

- (void)_addAudioPlayerForAudioType:(PMAudioType)audioType withAction:(PMAudioAction)audioAction;
- (NSString *)_resourceNameForAudioType:(PMAudioType)audioType;
- (BOOL)_isMusicForAudioType:(PMAudioType)audioType;

@end


@implementation PMAudioPlayer

@synthesize audioPlayers    = audioPlayers_;
@synthesize resourceManager = resourceManager_;
@synthesize loadingManager  = loadingManager_;

// Singleton
static PMAudioPlayer * gameAudioPlayer_ = nil;
+ (PMAudioPlayer *)sharedInstance
{
  if (gameAudioPlayer_ != nil)
    return gameAudioPlayer_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gameAudioPlayer_ = [[PMAudioPlayer alloc] init];
  });
  return gameAudioPlayer_;
}


- (id)init
{
  if (self = [super init]) {
    audioPlayers_        = [[NSMutableDictionary alloc] init];
    self.resourceManager = [ResourceManager sharedInstance];
    self.loadingManager  = [LoadingManager sharedInstance];
  }
  return self;
}

#pragma mark - Public Methods
#pragma mark - Audio Player Manager

// get ready to play the sound. happens automatically on play
- (void)prepareToPlayForAudioType:(PMAudioType)audioType
{
  NSString * audioResourceName = [self _resourceNameForAudioType:audioType];
  AVAudioPlayer * audioPlayer = [self.audioPlayers objectForKey:audioResourceName];
  if (audioPlayer != nil) {
    [audioPlayer prepareToPlay];
    return;
  }
  
  // If not resource bundle exists, no need to load audio
  if (! self.resourceManager.bundle)
    return;
  // If the Audio Player for type not exist, add new for this type
  [self _addAudioPlayerForAudioType:audioType withAction:kAudioActionPrepareToPlay];
  [[self.audioPlayers objectForKey:audioResourceName] prepareToPlay];
}

// Play
- (void)playForAudioType:(PMAudioType)audioType
              afterDelay:(NSTimeInterval)delay
{
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  NSInteger masterVolume = [userDefaults integerForKey:kUDKeyGameSettingsMaster];
  // If ZERO master volume, do not play any audio
  if (masterVolume == 0)
    return;
  // If ZERO music volume, do not play music
  NSInteger musicVolume = [userDefaults integerForKey:kUDKeyGameSettingsMusic];
  if (musicVolume == 0)
    if ([self _isMusicForAudioType:audioType]) return;
  // If ZERO sounds volume, do not play sounds (not music)
  NSInteger soundsVolume = [userDefaults integerForKey:kUDKeyGameSettingsSounds];
  if (soundsVolume == 0)
    if (! [self _isMusicForAudioType:audioType]) return;
  
  // Play AUDIO
  NSString * audioResourceName = [self _resourceNameForAudioType:audioType];
  AVAudioPlayer * audioPlayer = [self.audioPlayers objectForKey:audioResourceName];
  if (audioPlayer != nil) {
    // Set volume
    float volume = masterVolume / 100.f;
    if ([self _isMusicForAudioType:audioType]) volume *= musicVolume / 100.f;
    else                                       volume *= soundsVolume / 100.f;
    [audioPlayer setVolume:volume];
    
    // play audio
    if (delay) [audioPlayer playAtTime:(audioPlayer.deviceCurrentTime + delay)];
    else       [audioPlayer play];
    audioPlayer = nil;
    return;
  }
  audioPlayer = nil;
  // If the Audio Player for type not exist, add new for this type
  [self _addAudioPlayerForAudioType:audioType withAction:kAudioActionPlay];
}

// resume to play
- (void)resumeForAudioType:(PMAudioType)audioType
{
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
- (void)pauseForAudioType:(PMAudioType)audioType
{
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
- (void)stopForAudioType:(PMAudioType)audioType
{
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
- (void)preloadForAppBasic
{
  if (! self.resourceManager.bundle)
    return;
  
  // If ZERO master or sounds volume, do not need to load related audioes
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  if ([userDefaults integerForKey:kUDKeyGameSettingsMaster] == 0 ||
      [userDefaults integerForKey:kUDKeyGameSettingsSounds] == 0)
    return;
  // Load Audioes
  for (PMAudioType audioType = kAudioNone + 1; audioType < kAudioGameEND; ++audioType)
    if ([self.audioPlayers objectForKey:[self _resourceNameForAudioType:audioType]] == nil)
      [self _addAudioPlayerForAudioType:audioType
                             withAction:kAudioActionPrepareToPlay];
}

// preload game basic audios (|kAudioBattle...|)
- (void)preloadForBattleBasic
{
  if (! self.resourceManager.bundle)
    return;
  
  // If ZERO master or sounds volume, do not need to load related audioes
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  if ([userDefaults integerForKey:kUDKeyGameSettingsMaster] == 0 ||
      [userDefaults integerForKey:kUDKeyGameSettingsSounds] == 0)
    return;
  // Load Audioes
  for (PMAudioType audioType = kAudioGameEND + 1; audioType < kAudioBattleEND; ++audioType)
    if ([self.audioPlayers objectForKey:[self _resourceNameForAudioType:audioType]] == nil)
      [self _addAudioPlayerForAudioType:audioType
                             withAction:kAudioActionPrepareToPlay];
}

// Preload resources for battle VS. Wild Pokemon
- (void)preloadForBattleVSWildPokemon
{
  if (! self.resourceManager.bundle)
    return;
  
  // Load battle basic audioes
  [self preloadForBattleBasic];
  
  // If ZERO master or music volume, do not need to load related audioes
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  if ([userDefaults integerForKey:kUDKeyGameSettingsMaster] == 0 ||
      [userDefaults integerForKey:kUDKeyGameSettingsMusic] == 0)
    return;
  // Load Audioes
  for (PMAudioType audioType = kAudioBattleEND + 1; audioType < kAudioBattleVSWildPmEND; ++audioType)
    if ([self.audioPlayers objectForKey:[self _resourceNameForAudioType:audioType]] == nil)
      [self _addAudioPlayerForAudioType:audioType
                             withAction:kAudioActionPrepareToPlay];
}

// Unload resources particular for battle VS. Wild Pokemon when this type battle END
- (void)cleanForBattleVSWildPokemon
{
  for (PMAudioType audioType = kAudioBattleEND + 1; audioType < kAudioBattleVSWildPmEND; ++audioType)
    if ([self.audioPlayers objectForKey:[self _resourceNameForAudioType:audioType]] != nil)
      [self.audioPlayers removeObjectForKey:[self _resourceNameForAudioType:audioType]];
}

// unload resources for Battle (include Battle Basic) when NO BATTLE
- (void)cleanForBattle
{
  for (PMAudioType audioType = kAudioGameEND + 1; audioType < kAudioBattleVSWildPmEND; ++audioType)
    if ([self.audioPlayers objectForKey:[self _resourceNameForAudioType:audioType]] != nil)
      [self.audioPlayers removeObjectForKey:[self _resourceNameForAudioType:audioType]];
}

// unload all resources (include App Basic) when AUDIO NOT ALLOWED
- (void)cleanAll
{
  [self.audioPlayers removeAllObjects];
}

#pragma mark - Private Methods

// Add a new audio player to |audioPlayers_|
- (void)_addAudioPlayerForAudioType:(PMAudioType)audioType
                         withAction:(PMAudioAction)audioAction
{
  NSString * audioResourceName = [self _resourceNameForAudioType:audioType];
  NSURL * url = [self.resourceManager.bundle URLForResource:audioResourceName
                                              withExtension:@"mp3"
                                               subdirectory:kBundleDirectoryOfSound];
  if (! url) return;
  
  // Add resource unit to loading queue
//  [self.loadingManager addResourceToLoadingQueue];
  [self.loadingManager showOverView];
  
  // Load audio resource
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSLog(@"AudioPlayer for AudioType::|%@| not exists, adding new......",
          [self _resourceNameForAudioType:audioType]);
    
    NSError * error = nil;
    AVAudioPlayer * audioPlayer = [AVAudioPlayer alloc];
    (void)[audioPlayer initWithContentsOfURL:url error:&error];
    [audioPlayer setDelegate:self];
    // Set LOOP for special AUDIO
    if (audioType == kAudioBattlingVSWildPM)
      [audioPlayer setNumberOfLoops:-1];
    
    if (error) NSLog(@"!!!Error: %@", [error debugDescription]);
    else {
      [self.audioPlayers setObject:audioPlayer forKey:audioResourceName];
      if      (audioAction == kAudioActionPlay)          [audioPlayer play];
      else if (audioAction == kAudioActionPrepareToPlay) [audioPlayer prepareToPlay];
    }
    audioPlayer = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      // Pop resource unit from loading queue
//      [self.loadingManager popResourceFromLoadingQueue];
      [self.loadingManager hideOverView];
    });
  });
}

// Audio resource name for the audio type
- (NSString *)_resourceNameForAudioType:(PMAudioType)audioType
{
  NSString * resourceName = nil;
  
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

// If the audio type is music, return YES, else (sounds), return NO
- (BOOL)_isMusicForAudioType:(PMAudioType)audioType
{
  if (audioType == kAudioGameGuide ||
      audioType == kAudioGamePMEvolution ||
      audioType == kAudioBattlePMCaughtSucceed ||
      audioType == kAudioBattleStartVSWildPM ||
      audioType == kAudioBattlingVSWildPM ||
      audioType == kAudioBattleVictoryVSWildPM)
    return YES;
  return NO;
}

#pragma mark - AVAudioPlayer Delegate

// Audio finished playing
//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
//  NSLog(@"...Playing Audio Finished...");
//  [player stop];
//}

// Audio playing ERROR
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player
                                 error:(NSError *)error
{
  NSLog(@"!!!ERROR::Playing Audio Decode Error Occurred");
}

@end
