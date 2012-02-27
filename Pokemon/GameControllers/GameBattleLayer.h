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
@class TrainerTamedPokemon;

@interface GameBattleLayer : CCLayerColor {
  Pokemon             * wildPokemon_;
  TrainerTamedPokemon * trainerPokemon_;
}

@property (nonatomic, retain) Pokemon             * wildPokemon;
@property (nonatomic, retain) TrainerTamedPokemon * trainerPokemon;

+ (CCScene *)scene;

@end
