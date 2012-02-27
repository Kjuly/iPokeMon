//
//  GameAbstractPokemon.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameAbstractPokemon : CCNode {
  CCSprite * pokemonSprite_;
  int        hp_;
  int        hpMax_;
}

@property (nonatomic, retain) CCSprite * pokemonSprite;
@property (nonatomic, assign) int        hp;
@property (nonatomic, assign) int        hpMax;

@end
