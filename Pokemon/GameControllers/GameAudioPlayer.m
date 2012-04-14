//
//  GameAudioPlayer.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/14/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameAudioPlayer.h"


@interface GameAudioPlayer () {
 @private
  AVAudioPlayer * audioPlayer_;
}

@property (nonatomic, retain) AVAudioPlayer * audioPlayer;

@end


@implementation GameAudioPlayer

@synthesize audioPlayer = audioPlayer_;

// Singleton
static GameAudioPlayer * gameAudioPlayer_ = nil;
+ (GameAudioPlayer *)sharedInstance {
  if (gameAudioPlayer_ != nil)
    return gameAudioPlayer_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gameAudioPlayer_ = [[GameAudioPlayer alloc] init];
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
    
  }
  return self;
}

@end
