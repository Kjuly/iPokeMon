//
//  GameMenuMoveViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GlobalConstants.h"

@interface GameMenuAbstractChildViewController : UIViewController {
  UIView * tableAreaView_;
}

@property (nonatomic, retain) UIView * tableAreaView;

- (void)loadViewWithAnimationFromLeft:(BOOL)fromLeft;
- (void)unloadViewWithAnimationToLeft:(BOOL)toLeft;
- (void)swipeView:(UISwipeGestureRecognizer *)recognizer;

@end
