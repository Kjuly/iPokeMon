//
//  BagItemTableViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BagItemTableViewController : UITableViewController
{
  NSMutableArray * items_;
}

@property (nonatomic, copy) NSMutableArray * items;

- (id)initWithBagItem:(NSInteger)ItemTypeID;

@end
