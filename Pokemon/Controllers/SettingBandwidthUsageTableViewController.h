//
//  AccountSettingTableViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  kGeneralSectionBandwidthMinimal = 0,
  kGeneralSectionBandwidthStandard,
  kNumberOfGeneralSectionBandwidthRows
}GeneralSectionBandwidthRow;

@interface SettingBandwidthUsageTableViewController : UITableViewController

@end
