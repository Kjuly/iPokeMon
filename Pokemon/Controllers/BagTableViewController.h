//
//  BagTableViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomTableViewController.h"

@interface BagTableViewController : CustomTableViewController
{
  NSArray * bagItems_;
}

@property (nonatomic, copy) NSArray * bagItems;

@end
