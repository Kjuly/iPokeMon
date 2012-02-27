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

@interface GameBattleLayer : CCLayerColor {
  GameWildPokemon    * gameWildPoekmon_;
  GameTrainerPokemon * gameTrainerPokemon_;
}

@property (nonatomic, retain) GameWildPokemon    * gameWildPokemon;
@property (nonatomic, retain) GameTrainerPokemon * gameTrainerPokemon;

+ (CCScene *)scene;

@end
