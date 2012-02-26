//
//  GameMainViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameMenuViewController;

@interface GameMainViewController : UIViewController
{
  GameMenuViewController * gameMenuViewController_;
}

@property (nonatomic, retain) GameMenuViewController * gameMenuViewController;

@end
