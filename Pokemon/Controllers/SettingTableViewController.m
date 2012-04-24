//
//  AccountSettingTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingTableViewController.h"

#import "GlobalNotificationConstants.h"
#import "CustomNavigationBar.h"
#import "SettingTableViewCellStyleTitle.h"
#import "SettingTableViewCellStyleSwitch.h"
#import "SettingTableViewCellStyleCenterTitle.h"
#import "SettingSectionHeaderView.h"
#import "OAuthManager.h"
#import "SettingBandwidthUsageTableViewController.h"
#import "SettingGameSettingsTableViewController.h"


@interface SettingTableViewController ()

- (void)updateValueSettings:(NSNotification *)notification;
- (void)updateValueWithTappedSwitchButton:(UIControl *)button event:(UIEvent *)event;
- (void)openLogoutConfirmView;

@end


@implementation SettingTableViewController

- (void)dealloc {
  // Remove notification observer
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNUDGeneralBandwidthUsage object:nil];
  [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
  if (self = [super initWithStyle:style]) {
    [self setTitle:NSLocalizedString(@"Setting", nil)];
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
  NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
  
  // Add observer for notification from |SettingBandwidthUsageTableViewController| when value changed
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(updateValueSettings:)
                                               name:kPMNUDGeneralBandwidthUsage
                                             object:nil];
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
  if (indexPath.section == kSectionAbout)
    if (indexPath.row == kSectionAboutRowLogout)
      return kCellHeightOfSettingTableViewLogout;
  return kCellHeightOfSettingTableView;
}

// Section Header Height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return kSectionHeaderHeightOfSettingTableView;
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
        [cell.switchButton addTarget:self
                              action:@selector(updateValueWithTappedSwitchButton:event:)
                    forControlEvents:UIControlEventValueChanged];
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
        [cell configureCellWithTitle:NSLocalizedString(@"Bandwidth Usage", nil)
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
        
      case kSectionAboutRowLogout: {
        static NSString *CellIdentifier = @"CellStyleLogout";
        SettingTableViewCellStyleCenterTitle *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[[SettingTableViewCellStyleCenterTitle alloc] initWithStyle:UITableViewCellStyleDefault
                                                              reuseIdentifier:CellIdentifier] autorelease];
        }
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingLogout", nil)];
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
  else if (section == kSectionAbout) {
    if (row == kSectionAboutRowLogout)
      [self openLogoutConfirmView];
  }
}
   
#pragma mark - Private Methods

// Update value when value for Settings changed
- (void)updateValueSettings:(NSNotification *)notification {
  [self.tableView reloadData];
}

// Update value when Switch button changed value
- (void)updateValueWithTappedSwitchButton:(UIControl *)button event:(UIEvent *)event {
  UISwitch * switchButton = (UISwitch *)button;
  UITableViewCell * cell = (UITableViewCell *)switchButton.superview;
  NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
  if (indexPath == nil)
    return;
  
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  // Update value for Location Service
  if (indexPath.section == kSectionGeneral) {
    if (indexPath.row == kSectionGeneralLocationServices) {
      // Save value to UserDefaults
      [userDefaults setBool:[switchButton isOn] forKey:kUDKeyGeneralLocationServices];
      [userDefaults synchronize];
      // Post notification to toggle Location Service
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUDGeneralLocationServices object:self userInfo:nil];
    }
  }
}

// Open Logut confirm view
- (void)openLogoutConfirmView {
  UIAlertView * logoutConfirmView = [UIAlertView alloc];
  [logoutConfirmView initWithTitle:nil
                           message:NSLocalizedString(@"PMSSettingLogoutConfirmText", nil)
                          delegate:self
                 cancelButtonTitle:NSLocalizedString(@"PMSYes", nil)
                 otherButtonTitles:NSLocalizedString(@"PMSNo", nil), nil];
  [logoutConfirmView show];
  [logoutConfirmView release];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 0) {
    [(CustomNavigationBar *)self.navigationController.navigationBar backToRoot:nil];
    [[OAuthManager sharedInstance] performSelector:@selector(logout) withObject:nil afterDelay:.3f];
  }
}

@end
