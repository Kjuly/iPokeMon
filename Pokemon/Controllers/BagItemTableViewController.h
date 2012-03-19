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
  NSMutableArray * items_;
  NSInteger itemNumberSequence_;
}

@property (nonatomic, copy) NSMutableArray * items;
@property (nonatomic, assign) NSInteger itemNumberSequence;

- (id)initWithBagItem:(NSInteger)itemTypeID;

@end
