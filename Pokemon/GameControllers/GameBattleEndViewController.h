//
//  GameBattleEndViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 4/8/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  kGameBattleEndEventTypePlayerWin = 0,
  kGameBattleEndEventTypePlayerLose,
  kGameBattleEndEventTypeCaughtWildPokemon
}GameBattleEndEventType;

@interface GameBattleEndViewController : UIViewController

- (void)loadViewWithEventType:(GameBattleEndEventType)eventType animated:(BOOL)animated;

@end
