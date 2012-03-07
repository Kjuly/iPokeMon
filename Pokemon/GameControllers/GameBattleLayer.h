//
//  GameBattleLayer.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameWildPokemon;
@class GameMyPokemon;
@class GameMoveEffect;

@interface GameBattleLayer : CCLayerColor {
  GameWildPokemon * gameWildPoekmon_;
  GameMyPokemon   * gameMyPokemon_;
  GameMoveEffect  * gameMoveEffect_;
}

@property (nonatomic, retain) GameWildPokemon * gameWildPokemon;
@property (nonatomic, retain) GameMyPokemon   * gameMyPokemon;
@property (nonatomic, retain) GameMoveEffect  * gameMoveEffect;

+ (CCScene *)scene;

@end
