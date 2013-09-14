//
//  PokemonMoveDetailView.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PokemonMoveView;
@class PokemonInfoLabelView;

@interface PokemonMoveDetailView : UIView {
  PokemonMoveView      * moveBaseView_;
  UIButton             * backButton_;
  PokemonInfoLabelView * categoryLabelView_;
  PokemonInfoLabelView * powerLabelView_;
  PokemonInfoLabelView * accuracyLabelView_;
  UITextView           * infoTextView_;
}

@property (nonatomic, strong) PokemonMoveView      * moveBaseView;
@property (nonatomic, strong) UIButton             * backButton;
@property (nonatomic, strong) PokemonInfoLabelView * categoryLabelView;
@property (nonatomic, strong) PokemonInfoLabelView * powerLabelView;
@property (nonatomic, strong) PokemonInfoLabelView * accuracyLabelView;
@property (nonatomic, strong) UITextView           * infoTextView;

@end
