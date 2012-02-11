//
//  PokemonAreaViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PokemonAreaViewController : UIViewController
{
  MKMapView * mapView_;
}

@property (nonatomic, retain) MKMapView * mapView;

- (id)initWithPokemonID:(NSInteger)pokemonID;

@end
