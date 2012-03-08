//
//  GamePlayer.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GamePlayer.h"

#import "GameStatusMachine.h"


@interface GamePlayer () {
 @private
  BOOL complete_;
}

@property (nonatomic, assign) BOOL complete;

@end


@implementation GamePlayer

@synthesize complete = complete_;

static GamePlayer * gamePlayer = nil;

+ (GamePlayer *)sharedInstance
{
  if (gamePlayer != nil)
    return gamePlayer;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    gamePlayer = [[GamePlayer alloc] init];
  });
  
  return gamePlayer;
}

- (void)dealloc
{
  [super dealloc];
}

- (id)init
{
  if (self = [super init]) {
    complete_ = NO;
  }
  return self;
}

- (void)update:(ccTime)dt
{
  if (self.complete) {
//    [[GameStatusMachine sharedInstance] endTurn:self];
    self.complete = NO;
  }
}

- (void)endTurn {
  self.complete = YES;
}

@end
