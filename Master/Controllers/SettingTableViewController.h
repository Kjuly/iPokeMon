//
//  AccountSettingTableViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

typedef enum {
  kSectionGeneral = 0,
  kSectionAbout,
  kSectionMore,
  kNumberOfSections
}Section;

typedef enum {
  kSectionGeneralLocationServices = 0,
  kSectionGeneralBandwidthUsage,
  kSectionGeneralGameSettings,
  kNumberOfSectionGeneralRows
}SectionGeneralRow;

typedef enum {
  kSectionAboutRowVersion = 0,
  kNumberOfSectionAboutRows
}SectionAboutRow;

typedef enum {
  kSectionMoreRowFeedback = 0,
  kSectionMoreRowLoadResource,
  kSectionMoreRowLogout,
  kNumberOfSectionMoreRows
}SectionMoreRow;

@interface SettingTableViewController : UITableViewController
  <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (retain, nonatomic) NSManagedObjectContext * managedObjectContext;

@end
