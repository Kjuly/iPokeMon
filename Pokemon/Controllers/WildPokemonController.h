//
//  WildPokemonController.h
//  Pokemon
//
//  Created by Kaijie Yu on 4/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WildPokemonController : NSObject

+ (WildPokemonController *)sharedInstance;

- (void)updateForCurrentRegion;
- (NSInteger)appearedPokemonUID;

@end
