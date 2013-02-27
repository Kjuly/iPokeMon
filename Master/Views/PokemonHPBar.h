//
//  PokemonHPBar.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PokemonHPBar : UIView

- (id)initWithFrame:(CGRect)frame HP:(NSInteger)hp HPMax:(NSInteger)hpMax;
- (NSInteger)hp;
- (NSInteger)hpMax;
- (void)updateHPBarWithHP:(NSInteger)hp;
- (void)updateHpBarWithHPMax:(NSInteger)hpMax;
- (void)updateHPBarWithHP:(NSInteger)hp HPMax:(NSInteger)hpMax;

@end
