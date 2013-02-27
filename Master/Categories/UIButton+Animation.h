//
//  UIButton+Animation.h
//  iPokeMon
//
//  Created by Kaijie Yu on 5/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Animation)

// trainsition total button with image changed
- (void)transitionTotalToImage:(UIImage *)image
                      forState:(UIControlState)state
                      duration:(NSTimeInterval)duration
                       options:(UIViewAnimationOptions)options
                    completion:(void (^)(BOOL finished))completion;

// trainsition button's image & background image
- (void)transitionToImage:(UIImage *)image
      withBackgroundImage:(UIImage *)backgroundImage
                 forState:(UIControlState)state
                 duration:(NSTimeInterval)duration
                  options:(UIViewAnimationOptions)options
               completion:(void (^)(BOOL finished))completion;

// trainsition button's image only
- (void)transitionToImage:(UIImage *)image
                 forState:(UIControlState)state
                 duration:(NSTimeInterval)duration
                  options:(UIViewAnimationOptions)options
               completion:(void (^)(BOOL finished))completion;

// trainsition button's background image only
- (void)transitionToBackgroundImage:(UIImage *)backgroundImage
                           forState:(UIControlState)state
                           duration:(NSTimeInterval)duration
                            options:(UIViewAnimationOptions)options
                         completion:(void (^)(BOOL finished))completion;

// default setting methods for above
- (void)transitionTotalToImage:(UIImage *)image
                       options:(UIViewAnimationOptions)options;

- (void)transitionToImage:(UIImage *)image
      withBackgroundImage:(UIImage *)backgroundImage
                  options:(UIViewAnimationOptions)options;

- (void)transitionToImage:(UIImage *)image
                  options:(UIViewAnimationOptions)options;

- (void)transitionToBackgroundImage:(UIImage *)backgroundImage
                            options:(UIViewAnimationOptions)options;

@end
