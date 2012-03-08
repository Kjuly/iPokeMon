//
//  GameEnemy.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GameEnemy.h"

#import "GameStatusMachine.h"


@interface GameEnemy () {
 @private
  BOOL complete_;
}
@end

@implementation GameEnemy

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
  if (complete_) {
//    [[GameStatusMachine sharedInstance] endTurn:self];
    complete_ = NO;
  }
}

- (void)endTurn {
  complete_ = YES;
}

@end
