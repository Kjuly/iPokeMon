//
//  GamePlayer.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/8/12.
//  Copyright 2012 Kjuly. All rights reserved.
//

#import "cocos2d.h"

@interface GamePlayerProcess : CCNode

- (void)update:(ccTime)dt;
- (void)reset;
- (void)endTurn;

@end
