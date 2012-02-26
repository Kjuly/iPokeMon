//
//  GameMenuViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameMenuViewController : UIViewController
{
  UIButton * buttonFight_;
  UIButton * buttonBag_;
  UIButton * buttonRun_;
}

@property (nonatomic, retain) UIButton * buttonFight;
@property (nonatomic, retain) UIButton * buttonBag;
@property (nonatomic, retain) UIButton * buttonRun;

@end
