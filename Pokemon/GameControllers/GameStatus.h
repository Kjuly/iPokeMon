//
//  GameStatus.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/28/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameStatus : NSObject

+ (GameStatus *)sharedInstance;

- (BOOL)isTrainerTurn;
- (BOOL)isWildPokemonTurn;
- (void)trainerTurnEnd;
- (void)wildPokemonTurnEnd;

@end
