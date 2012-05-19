//
//  UIButton+Animation.h
//  Mew
//
//  Created by Kaijie Yu on 5/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Animation)

- (void)transitionToImage:(UIImage *)image
                 forState:(UIControlState)state
                 duration:(NSTimeInterval)duration
                  options:(UIViewAnimationOptions)options
               completion:(void (^)(BOOL finished))completion;

- (void)transitionToImage:(UIImage *)image
                  options:(UIViewAnimationOptions)options;

@end
