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
@class GameTrainerPokemon;
@class GameMoveEffect;

@interface GameBattleLayer : CCLayerColor {
  GameWildPokemon    * gameWildPoekmon_;
  GameTrainerPokemon * gameTrainerPokemon_;
  GameMoveEffect     * gameMoveEffect_;
}

@property (nonatomic, retain) GameWildPokemon    * gameWildPokemon;
@property (nonatomic, retain) GameTrainerPokemon * gameTrainerPokemon;
@property (nonatomic, retain) GameMoveEffect     * gameMoveEffect;

+ (CCScene *)scene;
- (void)generateNewSceneWithWildPokemonID:(NSInteger)wildPokemonID;

@end
