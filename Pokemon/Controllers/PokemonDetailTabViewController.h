//
//  PokemonDetailTabViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PoketchTabBar.h"

@interface PokemonDetailTabViewController : UIViewController <PoketchTabBarDelegate>
{
  PoketchTabBar * tabBar_;
  NSArray * tabBarItems_;
}

@property (nonatomic, retain) PoketchTabBar * tabBar;
@property (nonatomic, copy) NSArray * tabBarItems;

- (id)initWithPokemonID:(NSInteger)pokemonID;

@end
