//
//  BagItemTableViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BagItemTableViewHiddenCell.h"

@interface BagItemTableViewController : UITableViewController <
  BagItemTableViewHiddenCellDelegate
> {
  NSMutableArray   * items_;
  BOOL               isDuringBattle_;
  BagQueryTargetType targetType_;
  NSInteger          selectedCellIndex_; // For querying data
  NSInteger          selectedPokemonIndex_;
}

@property (nonatomic, copy)   NSMutableArray   * items;
@property (nonatomic, assign) BOOL               isDuringBattle;
@property (nonatomic, assign) BagQueryTargetType targetType;
@property (nonatomic, assign) NSInteger          selectedCellIndex;
@property (nonatomic, assign) NSInteger          selectedPokemonIndex;

- (id)initWithBagItem:(BagQueryTargetType)targetType;
- (void)setBagItem:(BagQueryTargetType)targetType;
- (void)reset;

@end
