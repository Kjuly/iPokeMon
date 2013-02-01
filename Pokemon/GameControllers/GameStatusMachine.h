//
//  GameStatus.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/28/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
  kGameStatusInitialization = 0,
  kGameStatusSystemProcess  = 1,
  kGameStatusPlayerTurn     = 2,
  kGameStatusEnemyTurn      = 3
}GameStatus;


@interface GameStatusMachine : NSObject

+ (GameStatusMachine *)sharedInstance;

- (GameStatus)status;
- (void)startNewTurn;
- (void)resetStatus;
- (void)endStatus:(GameStatus)status;

@end
