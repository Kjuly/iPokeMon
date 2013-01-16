//
//  GameBattleLogTableViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 5/20/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameBattleLogTableViewCell.h"

@interface GameBattleLogTableViewController : UITableViewController

- (void)pushLog:(NSString *)log
    description:(NSString *)description
        forType:(MEWGameBattleLogType)type;

@end
