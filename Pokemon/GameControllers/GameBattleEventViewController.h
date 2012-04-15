//
//  GameBattleEventViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 4/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  kGameBattleEventTypeNone          = 0,
  kGameBattleEventTypeNoPMAvailable = 1 << 0,
  kGameBattleEventTypeLevelUp       = 1 << 1,
  kGameBattleEventTypeEvolution     = 1 << 2,
  kGameBattleEventTypeCaughtWPM     = 1 << 3 // WPM: Wild PokeMon
}GameBattleEventType;

@interface GameBattleEventViewController : UIViewController

- (void)loadViewWithEventType:(GameBattleEventType)eventType
                         info:(NSDictionary *)info
                     animated:(BOOL)animated
                   afterDelay:(NSTimeInterval)delay;

@end
