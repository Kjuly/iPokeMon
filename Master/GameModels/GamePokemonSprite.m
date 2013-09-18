//
//  GamePokemonSprite.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "GamePokemonSprite.h"

@implementation GamePokemonSprite

@synthesize status = status_;

- (id)initWithCGImage:(CGImageRef)image
                  key:(NSString *)key
{
  if (self = [super initWithCGImage:image key:key]) {
    status_ = kGamePokemonStatusNormal;
  }
  return self;
}

- (void)update:(ccTime)dt
{
  switch (self.status) {
    case kGamePokemonStatusNormal:
      break;
      
    case kGamePokemonStatusFaint:
      break;
      
    default:
      break;
  }
}

- (void)setStatus:(GamePokemonStatus)status
{
  if (self.status == status) return;
  self.status = status;
  
  // Update sprite image here
  switch (self.status) {
    case kGamePokemonStatusNormal:
      break;
      
    case kGamePokemonStatusFaint:
      break;
      
    default:
      break;
  }
}

@end
