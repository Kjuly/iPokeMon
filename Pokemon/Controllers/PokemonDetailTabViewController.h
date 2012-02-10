//
//  PokemonDetailTabViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTabBar.h"

@interface PokemonDetailTabViewController : UIViewController <CustomTabBarDelegate>
{
  CustomTabBar * tabBar_;
  NSArray * tabBarItems_;
}

@property (nonatomic, retain) CustomTabBar * tabBar;
@property (nonatomic, copy) NSArray * tabBarItems;

- (id)initWithPokemonID:(NSInteger)pokemonID;

@end
