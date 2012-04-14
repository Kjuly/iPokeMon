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
    audioPlayer_ = [[AVAudioPlayer alloc] init];
  }
  return self;
}

@end
