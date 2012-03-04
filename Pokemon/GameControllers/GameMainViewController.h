//
//  GameMainViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GameMenuViewController.h"

@class GameMenuViewController;

@interface GameMainViewController : UIViewController <GameMenuViewControllerDelegate>
{
  GameMenuViewController * gameMenuViewController_;
}

@property (nonatomic, retain) GameMenuViewController * gameMenuViewController;

@end
