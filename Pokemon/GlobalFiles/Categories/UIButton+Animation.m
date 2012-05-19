//
//  UIButton+Animation.m
//  Mew
//
//  Created by Kaijie Yu on 5/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "UIButton+Animation.h"

@implementation UIButton (Animation)

- (void)transitionToImage:(UIImage *)image
                 forState:(UIControlState)state
                 duration:(NSTimeInterval)duration
                  options:(UIViewAnimationOptions)options
               completion:(void (^)(BOOL))completion {
  [UIView transitionWithView:self
                    duration:duration
                     options:options
                  animations:^{
                    [self setImage:image forState:state];
                  }
                  completion:completion];
}

@end
