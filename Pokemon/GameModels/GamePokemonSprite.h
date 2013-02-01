//
//  GamePokemonSprite.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


typedef enum {
  kGamePokemonStatusNormal = 0,
  kGamePokemonStatusFaint  = 1
}GamePokemonStatus;


@interface GamePokemonSprite : CCSprite {
  GamePokemonStatus status_;
}

@property (nonatomic, assign) GamePokemonStatus status;

- (void)update:(ccTime)dt;

//- (id)setSpriteWithCGImage:(CGImageRef)image key:(NSString *)key;
- (void)setStatus:(GamePokemonStatus)status;

@end
