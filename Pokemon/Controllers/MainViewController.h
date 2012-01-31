//
//  MainViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;
@class UtilityViewController;
@class PoketchViewController;

@interface MainViewController : UIViewController
{
  MapViewController * mapViewController_;
  UtilityViewController * utilityViewController_;
  PoketchViewController * poketchViewController_;
}

@property (nonatomic, retain) MapViewController * mapViewController;
@property (nonatomic, retain) UtilityViewController * utilityViewController;
@property (nonatomic, retain) PoketchViewController * poketchViewController;

@end
