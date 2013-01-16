//
//  UnifiedStyleLabelView.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PokemonInfoLabelView : UIView {
  UILabel * name_;
  UILabel * value_;
}

@property (nonatomic, retain) UILabel * name;
@property (nonatomic, retain) UILabel * value;

- (id)initWithFrame:(CGRect)frame hasValueLabel:(BOOL)hasValueLabel;
- (void)adjustNameLabelWidthWith:(CGFloat)deltaWidth;

@end
