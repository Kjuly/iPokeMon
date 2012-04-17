//
//  AccountSettingTableViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  kGeneralSectionBandwidthOffline = 0,
  kGeneralSectionBandwidthMinimal,
  kGeneralSectionBandwidthStandard,
  kNumberOfGeneralSectionBandwidthRows
}GeneralSectionBandwidthRow;

@interface SettingBandwidthUsageTableViewController : UITableViewController

@end
