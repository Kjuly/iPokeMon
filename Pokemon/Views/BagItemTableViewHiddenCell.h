//
//  BagItemTableViewHiddenCell.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BagItemTableViewHiddenCellDelegate

 @required
- (void)useItem:(id)sender;
- (void)showInfo:(id)sender;
- (void)cancelHiddenCell:(id)sender;

 @optional
- (void)giveItem:(id)sender;
- (void)tossItem:(id)sender;
- (void)changeItemQuantity:(id)sender;

@end


@interface BagItemTableViewHiddenCell : UITableViewCell
{
  id <BagItemTableViewHiddenCellDelegate> delegate_;
  UIButton * use_;
  UIButton * give_;
  UIButton * toss_;
  UIButton * info_;
  UIButton * cancel_;
}

@property (nonatomic, assign) id <BagItemTableViewHiddenCellDelegate> delegate;
@property (nonatomic, retain) UIButton * use;
@property (nonatomic, retain) UIButton * give;
@property (nonatomic, retain) UIButton * toss;
@property (nonatomic, retain) UIButton * info;
@property (nonatomic, retain) UIButton * cancel;

- (void)addQuantity:(NSInteger)quantity withOffsetX:(CGFloat)offsetX;
- (void)updateQuantity:(NSInteger)quantity;

@end
