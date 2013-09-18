//
//  PokemonDetailTabViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonDetailTabViewController.h"

#import "Pokemon+DataController.h"
#import "PokemonInfoViewController.h"
#import "PokemonAreaViewController.h"
#import "PokemonSizeViewController.h"


@interface PokemonDetailTabViewController () {
 @private
  NSInteger pokemonSID_;
  BOOL      withTopbar_;
}

@end


@implementation PokemonDetailTabViewController

- (id)initWithPokemonSID:(NSInteger)pokemonSID
              withTopbar:(BOOL)withTopbar
{
  pokemonSID_ = pokemonSID;
  withTopbar_ = withTopbar;
  NSString * title = [NSString stringWithFormat:@"%@ %@",
                      KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", pokemonSID]), nil),
                      NSLocalizedString(@"Info", nil)];
  self = [super initWithTitle:title
                   tabBarSize:CGSizeMake(kTabBarWdith, kTabBarHeight)
        tabBarBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTabBarBackground]]
                     itemSize:CGSizeMake(kTabBarItemSize, kTabBarItemSize)
                        arrow:[UIImage imageNamed:kPMINTabBarArrow]];
  return self;
}

#pragma mark - Override

// Override |KYArcTabViewController|'s |-setup|
- (void)setup
{
  // Set View Frame
  CGFloat marginTop = withTopbar_ ? kTopBarHeight + kKYStatusBarHeight : kKYStatusBarHeight;
  self.viewFrame = CGRectMake(0.f, 0.f, kViewWidth, kViewHeight - marginTop);
  
  Pokemon * pokemon = [Pokemon queryPokemonDataWithSID:pokemonSID_];
  
  // Add child view controllers to each tab
  PokemonInfoViewController * pokemonInfoViewController;
  PokemonAreaViewController * pokemonAreaViewController;
  PokemonSizeViewController * pokemonSizeViewController;
  pokemonInfoViewController = [[PokemonInfoViewController alloc] initWithPokemon:pokemon];
  pokemonAreaViewController = [[PokemonAreaViewController alloc] initWithPokemonSID:pokemonSID_];
  pokemonSizeViewController = [[PokemonSizeViewController alloc] initWithPokemon:pokemon];
  
  // Set child views' Frame
  CGRect childViewFrame = CGRectMake(0.f, 0.f, kViewWidth, kViewHeight);
  [pokemonInfoViewController.view setFrame:childViewFrame];
  [pokemonAreaViewController.view setFrame:childViewFrame];
  [pokemonSizeViewController.view setFrame:childViewFrame];
  
  // Add child views as tab bar items
  self.tabBarItems = @[@{@"image"          : kPMINTabBarItemPMDetailInfo,
                         @"viewController" : pokemonInfoViewController},
                       @{@"image"          : kPMINTabBarItemPMDetailArea,
                         @"viewController" : pokemonAreaViewController},
                       @{@"image"          : kPMINTabBarItemPMDetailSize,
                         @"viewController" : pokemonSizeViewController}];
  
  // Release child view controllers
}

@end
