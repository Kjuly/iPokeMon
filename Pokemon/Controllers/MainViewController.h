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

@interface MainViewController : UIViewController
{
  MapViewController * mapViewController_;
  UtilityViewController * utilityViewController_;
}

@property (nonatomic, retain) MapViewController * mapViewController;
@property (nonatomic, retain) UtilityViewController * utilityViewController;

@end
