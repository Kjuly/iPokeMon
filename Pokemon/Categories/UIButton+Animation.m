//
//  UIButton+Animation.m
//  iPokeMon
//
//  Created by Kaijie Yu on 5/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "UIButton+Animation.h"

@implementation UIButton (Animation)

// trainsition total button with image changed
- (void)transitionTotalToImage:(UIImage *)image
                      forState:(UIControlState)state
                      duration:(NSTimeInterval)duration
                       options:(UIViewAnimationOptions)options
                    completion:(void (^)(BOOL finished))completion {
  [UIView transitionWithView:self
                    duration:duration
                     options:options
                  animations:^{
                    [self setImage:image forState:state];
                  }
                  completion:completion];
}

// trainsition button's image & background image
- (void)transitionToImage:(UIImage *)image
      withBackgroundImage:(UIImage *)backgroundImage
                 forState:(UIControlState)state
                 duration:(NSTimeInterval)duration
                  options:(UIViewAnimationOptions)options
               completion:(void (^)(BOOL finished))completion {
  [UIView transitionWithView:self
                    duration:duration
                     options:options
                  animations:^{
                    [self setImage:image forState:state];
                    [self setBackgroundImage:backgroundImage forState:state];
                  }
                  completion:completion];
}

// trainsition button's image only
- (void)transitionToImage:(UIImage *)image
                 forState:(UIControlState)state
                 duration:(NSTimeInterval)duration
                  options:(UIViewAnimationOptions)options
               completion:(void (^)(BOOL))completion {
  [UIView transitionWithView:self.imageView
                    duration:duration
                     options:options
                  animations:^{
                    [self setImage:image forState:state];
                  }
                  completion:completion];
}

// trainsition button's background image only
- (void)transitionToBackgroundImage:(UIImage *)backgroundImage
                           forState:(UIControlState)state
                           duration:(NSTimeInterval)duration
                            options:(UIViewAnimationOptions)options
                         completion:(void (^)(BOOL finished))completion {
  [UIView transitionWithView:self
                    duration:duration
                     options:options
                  animations:^{
                    [self setBackgroundImage:backgroundImage forState:state];
                  }
                  completion:completion];
}

// default setting methods for above
// trainsition total button with image changed
- (void)transitionTotalToImage:(UIImage *)image
                       options:(UIViewAnimationOptions)options {
  [self transitionTotalToImage:image
                      forState:UIControlStateNormal
                      duration:.3f
                       options:options
                    completion:nil];
}

// trainsition button's image & background image
- (void)transitionToImage:(UIImage *)image
      withBackgroundImage:(UIImage *)backgroundImage
                  options:(UIViewAnimationOptions)options {
  [self transitionToImage:image
      withBackgroundImage:backgroundImage
                 forState:UIControlStateNormal
                 duration:.3f
                  options:options
               completion:nil];
}

// trainsition button's image only
- (void)transitionToImage:(UIImage *)image
                  options:(UIViewAnimationOptions)options {
  [self transitionToImage:image
                 forState:UIControlStateNormal
                 duration:.3f
                  options:options
               completion:nil];
}

// trainsition button's background image only
- (void)transitionToBackgroundImage:(UIImage *)backgroundImage
                            options:(UIViewAnimationOptions)options {
  [self transitionToBackgroundImage:backgroundImage
                           forState:UIControlStateNormal
                           duration:.3f
                            options:options
                         completion:nil];
}

@end
