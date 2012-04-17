//
//  AccountSettingTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingTableViewController.h"

#import "SettingTableViewCellStyleTitle.h"
#import "SettingTableViewCellStyleSwitch.h"
#import "SettingSectionHeaderView.h"
#import "SettingBandwidthUsageTableViewController.h"
#import "SettingGameSettingsTableViewController.h"

/*
 // Settings.bundle
 extern NSString * const kUDKeyGeneralLocationServices; // enable location tracking (bool)
 extern NSString * const kUDKeyGeneralBandWidthUsage;   // bandwidth useage (number:0,1,2)
 // Game settings
 extern NSString * const kUDKeyGeneralGameSettings;
 extern NSString * const kUDKeyGameSettingsMasterTitle;
 extern NSString * const kUDKeyGameSettingsMaster;      // master volume (slider [0,100])
 extern NSString * const kUDKeyGameSettingsMusicTitle;
 extern NSString * const kUDKeyGameSettingsMusic;       // music volume (slider [0,100])
 extern NSString * const kUDKeyGameSettingsSoundsTitle;
 extern NSString * const kUDKeyGameSettingsSounds;      // sounds volume (slider [0,100])
 extern NSString * const kUDKeyGameSettingsAnimations;  // enable animations (switch)
 // About
 extern NSString * const kUDKeyAboutVersion;            // version for App
 */

@implementation SettingTableViewController

- (void)dealloc
{
  [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewBackgroundBlack.png"]]];
//    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case kSectionGeneral:
      return kNumberOfSectionGeneralRows;
      break;
      
    case kSectionAbout:
      return kNumberOfSectionAboutRows;
      break;
      
    default:
      return 1;
      break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kCellHeightOfSettingTableView;
}

// Section Header Height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 32.f;
}

// Section Header View Style
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  CGRect const sectionHeaderViewFrame = CGRectMake(0.f, 0.f, kViewWidth, kSectionHeaderHeightOfSettingTableView);
  SettingSectionHeaderView * sectionHeaderView = [[SettingSectionHeaderView alloc] initWithFrame:sectionHeaderViewFrame];
  [sectionHeaderView.title setText:
    NSLocalizedString(([NSString stringWithFormat:@"PMSSettingSection%d", section + 1]), nil)];
  return [sectionHeaderView autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString * CellIdentifier;
  
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  NSInteger sectionNum = indexPath.section;
  NSInteger rowNum     = indexPath.row;
  //////GENERAL//////
  if (sectionNum == kSectionGeneral) {
    switch (rowNum) {
      ///GENERAL - Location Service
      case kSectionGeneralLocationServices: {
        CellIdentifier = @"CellStyleSwitch";
        SettingTableViewCellStyleSwitch *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[[SettingTableViewCellStyleSwitch alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingGeneralLocationServices", nil)
                            switchOn:[userDefaults boolForKey:kUDKeyGeneralLocationServices]];
        return cell;
        break;
      }
        
      ///GENERAL - Bandwidth Usage
      case kSectionGeneralBandwidthUsage: {
        CellIdentifier = @"CellStyleTitle";
        SettingTableViewCellStyleTitle *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        NSString * bandwidthUsageName =
          NSLocalizedString(([NSString stringWithFormat:@"PMSSettingGeneralBandWidthUsage%d",
                              [userDefaults integerForKey:kUDKeyGeneralBandwidthUsage]]), nil);
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingGeneralBandWidthUsage", nil)
                               value:bandwidthUsageName
                       accessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        return cell;
        break;
      }
        
      ///GENERAL - Game Settings
      case kSectionGeneralGameSettings: {
        CellIdentifier = @"CellStyleTitle";
        SettingTableViewCellStyleTitle *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingGeneralGameSettings", nil)
                               value:nil
                       accessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        return cell;
        break;
      }
        
      default:
        break;
    }
  }
  //////ABOUT//////
  else if (sectionNum == kSectionAbout) {
    switch (rowNum) {
      ///ABOUT - Version
      case kSectionAboutRowVersion: {
        static NSString *CellIdentifier = @"CellStyleTitle";
        SettingTableViewCellStyleTitle *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:CellIdentifier] autorelease];
        }
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingAboutVersion", nil)
                               value:[NSString stringWithFormat:@"%.2f", [userDefaults floatForKey:kUDKeyAboutVersion]]
                       accessoryType:UITableViewCellAccessoryNone];
        return cell;
        break;
      }
        
      default:
        break;
    }
  }
  
  return nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }   
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
  }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the item to be re-orderable.
  return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger section = [indexPath section];
  NSInteger row     = [indexPath row];
  
  // GENERAL Section
  if (section == kSectionGeneral) {
    if (row == kSectionGeneralBandwidthUsage) {
      SettingBandwidthUsageTableViewController * settingBandwidthUsageTableViewController;
      settingBandwidthUsageTableViewController = [SettingBandwidthUsageTableViewController alloc];
      [settingBandwidthUsageTableViewController initWithStyle:UITableViewStylePlain];
      [self.navigationController pushViewController:settingBandwidthUsageTableViewController animated:YES];
      [settingBandwidthUsageTableViewController release];
    }
    // Game Settings
    else if (row == kSectionGeneralGameSettings) {
      SettingGameSettingsTableViewController * settingGameSettingsTableViewController;
      settingGameSettingsTableViewController = [SettingGameSettingsTableViewController alloc];
      [settingGameSettingsTableViewController initWithStyle:UITableViewStylePlain];
      [self.navigationController pushViewController:settingGameSettingsTableViewController animated:YES];
      [settingGameSettingsTableViewController release];
    }
  }
}

@end
