//
//  GameMenuMoveViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuAbstractChildViewController.h"

#import "GameMenuMoveUnitView.h"

@interface GameMenuMoveViewController : GameMenuAbstractChildViewController <
  GameMenuMoveUnitViewDelegate
>

- (void)updateFourMoves;

@end
