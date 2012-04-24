//
//  UtilityBallMenuViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbstractCenterMenuViewController : UIViewController {
  UIView * centerMenu_;
  BOOL      isOpening_;
  BOOL isInProcessing_;
}

@property (nonatomic, retain) UIView * centerMenu;
@property (nonatomic, assign) BOOL     isOpening;
@property (nonatomic, assign) BOOL     isInProcessing;

- (id)initWithButtonCount:(NSInteger)buttonCount;
- (void)runButtonActions:(id)sender;
- (void)pushViewController:(id)viewController;
- (void)checkDeviceSystemFor:(id)viewController;
- (void)openCenterMenuView;
- (void)changeCenterMainButtonStatusToMove:(CenterMainButtonStatus)centerMainButtonStatus;

@end
