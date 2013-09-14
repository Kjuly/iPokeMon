//
//  GameBattleLayer.h
//  iPokeMon
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

@property (nonatomic, strong) GameMoveEffect  * gameMoveEffect;

+ (CCScene *)scene;

@end
