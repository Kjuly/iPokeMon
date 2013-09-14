//
//  GameMenuMoveViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameMenuAbstractChildViewController : UIViewController {
  UIView * tableAreaView_;
}

@property (nonatomic, strong) UIView * tableAreaView;

- (void)loadViewWithAnimationFromLeft:(BOOL)fromLeft animated:(BOOL)animated;
- (void)unloadViewWithAnimationToLeft:(BOOL)toLeft animated:(BOOL)animated;
- (void)swipeView:(UISwipeGestureRecognizer *)recognizer;

@end
