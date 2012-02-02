//
//  PoketchTabBar.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PoketchTabBarDelegate

- (UIImage *)iconFor:(NSUInteger)itemIndex;
- (UIImage *)backgroundImage;
- (UIImage *)backgroundImageForSelectedItem;
- (UIImage *)selectedItemImage;
- (UIImage *)tabBarArrowImage;

@optional
- (void)touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex;

@end


@interface PoketchTabBar : UIView
{
  NSObject <PoketchTabBarDelegate> * delegate_;
  NSMutableArray * buttons_;
}

@property (nonatomic, retain) NSMutableArray * buttons;

- (id)initWithItemCount:(NSUInteger)itemCount
                   size:(CGSize)itemSize
                    tag:(NSInteger)objectTag
               delegate:(NSObject <PoketchTabBarDelegate> *)tabBarDelegate;
- (void)selectItemAtIndex:(NSInteger)index;
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration;

@end
