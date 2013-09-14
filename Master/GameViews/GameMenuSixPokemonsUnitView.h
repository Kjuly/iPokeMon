//
//  GameMenuSixPokemonsUnitView.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameMenuSixPokemonsUnitViewDelegate;

@interface GameMenuSixPokemonsUnitView : UIView {
  id <GameMenuSixPokemonsUnitViewDelegate> __weak delegate_;
}

@property (nonatomic, weak) id <GameMenuSixPokemonsUnitViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame image:(UIImage *)image tag:(NSInteger)tag;
- (void)cancelUnitAnimated:(BOOL)animated;
- (void)setAsNormal;
- (void)setAsCurrentBattleOne:(BOOL)isCurrentBattleOne;
- (void)setAsFainted:(BOOL)isFainted;

@end


// Delegate

@protocol GameMenuSixPokemonsUnitViewDelegate <NSObject>

- (void)checkUnit:(id)sender;
- (void)resetUnit;
- (void)confirm:(id)sender;
- (void)openInfoView:(id)sender;

@end
