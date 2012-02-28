//
//  UtilityBallMenuViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractCenterMenuViewController : UIViewController
{
  UIView   * ballMenu_;
  UIButton * buttonClose_;
}

@property (nonatomic, retain) UIView   * ballMenu;
@property (nonatomic, retain) UIButton * buttonClose;

- (id)initWithButtonCount:(NSInteger)buttonCount;
- (void)runButtonActions:(id)sender;
- (void)closeView:(id)sender;

@end
