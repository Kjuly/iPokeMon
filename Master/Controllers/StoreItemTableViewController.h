//
//  BagItemTableViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BagItemTableViewHiddenCell.h"

@interface StoreItemTableViewController : UITableViewController <
  BagItemTableViewHiddenCellDelegate
>

- (id)initWithBagItem:(BagQueryTargetType)targetType;
- (void)setBagItem:(BagQueryTargetType)targetType;

@end
