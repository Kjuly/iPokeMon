//
//  GameBattleLayer.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameMoveEffect;

@interface GameBattleLayer : CCLayerColor {
  GameMoveEffect  * gameMoveEffect_;
}

@property (nonatomic, retain) GameMoveEffect  * gameMoveEffect;

+ (CCScene *)scene;

@end
