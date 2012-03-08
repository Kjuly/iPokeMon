//
//  GameMenuViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameMenuViewControllerDelegate

- (void)unloadBattleScene;

@end


@interface GameMenuViewController : UIViewController
{
  id <GameMenuViewControllerDelegate> delegate_;  
  UIButton * buttonFight_;
  UIButton * buttonBag_;
  UIButton * buttonRun_;
}

@property (nonatomic, assign) id <GameMenuViewControllerDelegate> delegate;
@property (nonatomic, retain) UIButton * buttonFight;
@property (nonatomic, retain) UIButton * buttonBag;
@property (nonatomic, retain) UIButton * buttonRun;

- (void)resetForNewScene;

@end
