//
//  BagTableViewCell.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  kMEWGameBattleLogTypeNormal = 0,
  kMEWGameBattleLogTypeAskingForUserAction = 1,
  kMEWGameBattleLogTypePlayerPMAttack      = 2,
  kMEWGameBattleLogTypeEnemyPMAttack       = 3
}MEWGameBattleLogType;

@interface GameBattleLogTableViewCell : UITableViewCell

- (void)configureCellWithType:(MEWGameBattleLogType)type
                          log:(NSString *)log
                  description:(NSString *)description
                          odd:(BOOL)odd;

@end
