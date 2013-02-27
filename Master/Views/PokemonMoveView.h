//
//  PokemonMoveView.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PokemonMoveViewDelegate;

@interface PokemonMoveView : UIView

// localization job is done in this method
- (void)configureMoveUnitWithName:(NSString *)name
                             type:(NSString *)type
                               pp:(NSString *)pp
                         delegate:(id <PokemonMoveViewDelegate>)delegate
                              tag:(NSInteger)tag
                              odd:(BOOL)odd;
- (void)setButtonEnabled:(BOOL)enabled;

@end


// Delegate
@protocol PokemonMoveViewDelegate <NSObject>

- (void)loadMoveDetailView:(id)sender;

@end
