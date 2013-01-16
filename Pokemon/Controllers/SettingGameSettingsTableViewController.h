//
//  AccountSettingTableViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  kGameSettingsSectionVolume = 0,
  kGameSettingsSectionOthers,
  kNumberOfGameSettingsSection
}GameSettingsSection;

typedef enum {
  kGameSettingsSectionVolumeMaster = 0,
  kGameSettingsSectionVolumeMusic,
  kGameSettingsSectionVolumeSounds,
  kNumberOfGameSettingsSectionVolumeRows
}GameSettingsSectionVolumeRow;

typedef enum {
  kGameSettingsSectionOthersAnimation = 0,
  kNumberOfGameSettingsSectionOthersRows
}GameSettingsSectionOthersRow;

@interface SettingGameSettingsTableViewController : UITableViewController

@end
