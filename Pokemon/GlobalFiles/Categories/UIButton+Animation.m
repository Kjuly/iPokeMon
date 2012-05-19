//
//  UIButton+Animation.m
//  Mew
//
//  Created by Kaijie Yu on 5/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "UIButton+Animation.h"

@implementation UIButton (Animation)

// transition to image
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

// default
- (void)transitionToImage:(UIImage *)image
                  options:(UIViewAnimationOptions)options {
  [self transitionToImage:image
                 forState:UIControlStateNormal
                 duration:.3f
                  options:options
               completion:nil];
}

@end
