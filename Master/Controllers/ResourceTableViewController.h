//
//  ResourceTableViewController.h
//  iPokeMon
//
//  Created by Kjuly on 1/25/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface ResourceTableViewController : UITableViewController <
  MBProgressHUDDelegate
>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@end
