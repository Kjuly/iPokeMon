//
//  BagItemTableViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BagItemTableViewHiddenCell.h"

@interface BagItemTableViewController : UITableViewController <BagItemTableViewHiddenCellDelegate>
{
  NSMutableArray     * items_;
  NSInteger            itemNumberSequence_;
  BagQueryTargetType   targetType_;
  BOOL                 isDuringBattle_;
}

@property (nonatomic, copy)   NSMutableArray     * items;
@property (nonatomic, assign) NSInteger            itemNumberSequence;
@property (nonatomic, assign) BagQueryTargetType   targetType;
@property (nonatomic, assign) BOOL                 isDuringBattle;

- (id)initWithBagItem:(BagQueryTargetType)targetType;
- (void)setBagItem:(BagQueryTargetType)targetType;

@end
