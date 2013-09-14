//
//  BagItemTableViewHiddenCell.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BagItemTableViewHiddenCellDelegate;

@interface BagItemTableViewHiddenCell : UITableViewCell {
  id <BagItemTableViewHiddenCellDelegate> __weak delegate_;
  UIButton * use_;
  UIButton * give_;
  UIButton * toss_;
  UIButton * info_;
  UIButton * cancel_;
}

@property (nonatomic, weak) id <BagItemTableViewHiddenCellDelegate> delegate;
@property (nonatomic, strong) UIButton * use;
@property (nonatomic, strong) UIButton * give;
@property (nonatomic, strong) UIButton * toss;
@property (nonatomic, strong) UIButton * info;
@property (nonatomic, strong) UIButton * cancel;

- (void)addQuantity:(NSInteger)quantity withOffsetX:(CGFloat)offsetX;
- (void)updateQuantity:(NSInteger)quantity;

@end


// Delegate
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
