//
//  PoketchTabBar.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTabBarDelegate

- (UIImage *)iconFor:(NSUInteger)itemIndex;

@optional
- (void)touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex withPreviousItemIndex:(NSUInteger)previousItemIndex;

@end


@interface CustomTabBar : UIView
{
  NSObject <CustomTabBarDelegate> * delegate_;
  NSMutableArray * buttons_;
}

@property (nonatomic, retain) NSMutableArray * buttons;

- (id)initWithItemCount:(NSUInteger)itemCount
                   size:(CGSize)itemSize
                    tag:(NSInteger)objectTag
               delegate:(NSObject <CustomTabBarDelegate> *)tabBarDelegate;
- (void)selectItemAtIndex:(NSInteger)index;
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration;

@end
