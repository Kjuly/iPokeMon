//
//  AccountSettingTableViewController.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  kSectionGeneral = 0,
  kSectionAbout,
  kNumberOfSections
}Section;

typedef enum {
  kSectionGeneralLocationServices = 0,
  kSectionGeneralBandWidthUsage,
  kSectionGeneralGameSettings,
  kNumberOfSectionGeneralRows
}SectionGeneralRow;

typedef enum {
  kSectionAboutRowVersion = 0,
  kNumberOfSectionAboutRows
}SectionAboutRow;

@interface SettingTableViewController : UITableViewController

@end
