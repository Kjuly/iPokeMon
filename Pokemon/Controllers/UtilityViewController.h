//
//  UtilityViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilityViewController : UIViewController
{
  UIButton * buttonLocateMe_;
  UIButton * buttonShowWorld_;
  UIButton * buttonDiscover_;
  UIButton * buttonSetAccount_;
}

@property (nonatomic, retain) UIButton * buttonLocateMe;
@property (nonatomic, retain) UIButton * buttonShowWorld;
@property (nonatomic, retain) UIButton * buttonDiscover;
@property (nonatomic, retain) UIButton * buttonSetAccount;

@end
