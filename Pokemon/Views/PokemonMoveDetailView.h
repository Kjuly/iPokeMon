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

@property (nonatomic, retain) PokemonMoveView      * moveBaseView;
@property (nonatomic, retain) UIButton             * backButton;
@property (nonatomic, retain) PokemonInfoLabelView * categoryLabelView;
@property (nonatomic, retain) PokemonInfoLabelView * powerLabelView;
@property (nonatomic, retain) PokemonInfoLabelView * accuracyLabelView;
@property (nonatomic, retain) UITextView           * infoTextView;

@end
