//
//  GameBattleLayer.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Pokemon;

@interface GameBattleLayer : CCLayerColor {
  Pokemon  * pokemonData_;
}

@property (nonatomic, retain) Pokemon  * pokemonData;

+ (CCScene *)scene;

@end
