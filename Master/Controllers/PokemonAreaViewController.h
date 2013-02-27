//
//  PokemonAreaViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface PokemonAreaViewController : UIViewController <MKMapViewDelegate>

- (id)initWithPokemonSID:(NSInteger)pokemonSID;

@end
