//
//  PokemonHPBar.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PokemonHPBar : UIView

- (id)initWithFrame:(CGRect)frame HP:(NSInteger)hp HPMax:(NSInteger)hpMax;
- (void)updateHPBarWithHP:(NSInteger)hp;

@end
