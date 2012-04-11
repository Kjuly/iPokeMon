//
//  GameBattleEventViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 4/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  kGameBattleEventTypeNone      = 0,
  kGameBattleEventTypeLevelUp   = 1 << 0,
  kGameBattleEventTypeEvolution = 1 << 1,
  kGameBattleEventTypeCaughtWPM = 1 << 2 // WPM: Wild PokeMon
}GameBattleEventType;

@interface GameBattleEventViewController : UIViewController

- (void)loadViewWithEventType:(GameBattleEventType)eventType
                     animated:(BOOL)animated
                   afterDelay:(NSTimeInterval)delay;

@end
