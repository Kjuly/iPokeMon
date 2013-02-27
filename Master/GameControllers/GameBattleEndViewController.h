//
//  GameBattleEndViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 4/8/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
  kGameBattleEndEventTypeNone               = 0,
  kGameBattleEndEventTypeWin                = 1 << 0,
  kGameBattleEndEventTypeLose               = 1 << 1,
  kGameBattleEndEventTypeLevelUp            = 1 << 2,
  kGameBattleEndEventTypeCaughtWildPokemon  = 1 << 3,
  kGameBattleEndEventTypeRun                = 1 << 4,
  kGameBattleEndEventTypeWildPokemonRun     = 1 << 5
}GameBattleEndEventType;


@interface GameBattleEndViewController : UIViewController

- (void)loadViewWithEventType:(GameBattleEndEventType)eventType
                     animated:(BOOL)animated
                   afterDelay:(NSTimeInterval)delay;

@end
