//
//  AccountSettingTableViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingTableViewController.h"

#import "CustomNavigationBar.h"
#import "LoadingManager.h"
#import "SettingTableViewCellStyleTitle.h"
#import "SettingTableViewCellStyleSwitch.h"
#import "SettingTableViewCellStyleCenterTitle.h"
#import "SettingSectionHeaderView.h"
#import "OAuthManager.h"
#import "SettingBandwidthUsageTableViewController.h"
#import "SettingGameSettingsTableViewController.h"
#import "AppInfoViewController.h"
#import "ResourceTableViewController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@interface SettingTableViewController () {
 @private
  NSArray * developerEmails_;
}

@property (nonatomic, copy) NSArray * developerEmails;

- (void)_updateValueSettings:(NSNotification *)notification;
- (void)_updateValueWithTappedSwitchButton:(UIControl *)button event:(UIEvent *)event;
- (void)openLogoutConfirmView;

@end


@implementation SettingTableViewController

@synthesize managedObjectContext;
@synthesize developerEmails = developerEmails_;

- (void)dealloc {
  self.managedObjectContext = nil;
  self.developerEmails      = nil;
  // Remove notification observer
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNUDGeneralBandwidthUsage object:nil];
  [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
  if (self = [super initWithStyle:style]) {
    [self setTitle:NSLocalizedString(@"Setting", nil)];
    // These developer emails are for receiving users' feedback,
    //   they are in CC section of the mail compose view.
    // You can participate in this project development
    //   and send your mail address to Kjuly (dev@kjuly.com)
    self.developerEmails = @[@"dev@kjuly.com"];
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
                                           selector:@selector(_updateValueSettings:)
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
      
    case kSectionMore:
      return kNumberOfSectionMoreRows;
      break;
      
    default:
      return 1;
      break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == kSectionMore)
    if (indexPath.row == kSectionMoreRowLogout)
      return kCellHeightOfSettingTableViewCenterTitleStyle;
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
  static NSString * cellIdentifier;
  
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  NSInteger sectionNum = indexPath.section;
  NSInteger rowNum     = indexPath.row;
  //////GENERAL//////
  if (sectionNum == kSectionGeneral) {
    switch (rowNum) {
      ///GENERAL - Location Service
      case kSectionGeneralLocationServices: {
        cellIdentifier = @"CellStyleSwitch";
        SettingTableViewCellStyleSwitch * cell =
          [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
          cell = [[[SettingTableViewCellStyleSwitch alloc] initWithStyle:UITableViewCellStyleValue1
                                                         reuseIdentifier:cellIdentifier] autorelease];
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingGeneralLocationServices", nil)
                            switchOn:[userDefaults boolForKey:kUDKeyGeneralLocationServices]];
        [cell.switchButton addTarget:self
                              action:@selector(_updateValueWithTappedSwitchButton:event:)
                    forControlEvents:UIControlEventValueChanged];
        return cell;
        break;
      }
        
      ///GENERAL - Bandwidth Usage
      case kSectionGeneralBandwidthUsage: {
        cellIdentifier = @"CellStyleTitle";
        SettingTableViewCellStyleTitle * cell =
          [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
          cell = [[[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1
                                                        reuseIdentifier:cellIdentifier] autorelease];
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
        cellIdentifier = @"CellStyleTitle";
        SettingTableViewCellStyleTitle * cell =
          [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
          cell = [[[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1
                                                        reuseIdentifier:cellIdentifier] autorelease];
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
        cellIdentifier = @"CellStyleTitle";
        SettingTableViewCellStyleTitle * cell =
          [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
          cell = [[[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1
                                                        reuseIdentifier:cellIdentifier] autorelease];
        [cell configureCellWithTitle:kKYAppBundleLocalizedName
                               value:[@"v" stringByAppendingString:[userDefaults stringForKey:kUDKeyAboutVersion]]
                       accessoryType:UITableViewCellAccessoryNone];
        return cell;
        break;
      }
        
      default:
        break;
    }
  }
  //////MORE//////
  else if (sectionNum == kSectionMore) {
    switch (rowNum) {
      case kSectionMoreRowFeedback: {
        cellIdentifier = @"CellStyleFeedback";
        SettingTableViewCellStyleTitle * cell =
          [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
          cell = [[[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1
                                                        reuseIdentifier:cellIdentifier] autorelease];
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingMoreFeedback", nil)
                               value:nil
                       accessoryType:UITableViewCellAccessoryNone];
        return cell;
        break;
      }
        
      case kSectionMoreRowLoadResource: {
        cellIdentifier = @"CellStyleLoadResource";
        SettingTableViewCellStyleTitle * cell =
          [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
          cell = [[[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1
                                                        reuseIdentifier:cellIdentifier] autorelease];
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingMoreLoadResource", nil)
                               value:nil
                       accessoryType:UITableViewCellAccessoryNone];
        return cell;
        break;
      }
        
      case kSectionMoreRowLogout: {
        cellIdentifier = @"CellStyleLogout";
        SettingTableViewCellStyleCenterTitle * cell =
          [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
          cell = [[[SettingTableViewCellStyleCenterTitle alloc] initWithStyle:UITableViewCellStyleDefault
                                                              reuseIdentifier:cellIdentifier] autorelease];
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingMoreLogout", nil)];
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

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
  // ABOUT Section
  else if (section == kSectionAbout) {
    // Version
    if (row == kSectionAboutRowVersion) {
      AppInfoViewController * appInfoViewController = [[AppInfoViewController alloc] init];
      [self.navigationController pushViewController:appInfoViewController animated:YES];
      [appInfoViewController release];
    }
  }
  else if (section == kSectionMore) {
    // Feedback
    if (row == kSectionMoreRowFeedback) {
      if (! [MFMailComposeViewController canSendMail]) {
        [[LoadingManager sharedInstance] showMessage:NSLocalizedString(@"PMSCannotSendMail", nil)
                                                type:kProgressMessageTypeWarn
                                        withDuration:2.f];
        return;
      }
      
      UIDevice * device = [UIDevice currentDevice];
      NSString * appInfo = [NSString stringWithFormat:@"- - - - - - - - - - - - - - - - - - - - - - - - - - - >8\n Version: %@\n Build Date: %@\n Locale: %@\n Device: %@\n OS: %@ %@",
                            [[NSUserDefaults standardUserDefaults] stringForKey:kUDKeyAboutVersion],
                            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildDate"],
                            [[NSLocale currentLocale] localeIdentifier],
                            device.model,
                            device.systemName, device.systemVersion];
      
      MFMailComposeViewController * mailComposer = [[MFMailComposeViewController alloc] init];
      mailComposer.mailComposeDelegate = self;
      [mailComposer setModalPresentationStyle:UIModalPresentationFormSheet];
      [mailComposer setSubject:@"iPokeMon Feedback"];
      [mailComposer setToRecipients:[NSArray arrayWithObject:@"dev@kjuly.com"]];
      [mailComposer setCcRecipients:self.developerEmails];
      [mailComposer setMessageBody:[NSString stringWithFormat:@"\n\n\n\n\n%@", appInfo] isHTML:NO];
      [mailComposer.navigationBar setBarStyle:UIBarStyleBlack];
      [self presentModalViewController:mailComposer animated:YES];
      [mailComposer release];
    }
    // Load Resource
    else if (row == kSectionMoreRowLoadResource) {
      ResourceTableViewController * resourceTableViewController;
      resourceTableViewController = [ResourceTableViewController alloc];
      [resourceTableViewController initWithStyle:UITableViewStylePlain];
      resourceTableViewController.managedObjectContext = self.managedObjectContext;
      [self.navigationController pushViewController:resourceTableViewController animated:YES];
      [resourceTableViewController release];
    }
    // Logout
    else if (row == kSectionMoreRowLogout)
      [self openLogoutConfirmView];
  }
}
   
#pragma mark - Private Methods

// Update value when value for Settings changed
- (void)_updateValueSettings:(NSNotification *)notification {
  [self.tableView reloadData];
}

// Update value when Switch button changed value
- (void)_updateValueWithTappedSwitchButton:(UIControl *)button event:(UIEvent *)event {
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

#pragma mark - MFMailComposeViewController Delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
  LoadingManager * loadingManager = [LoadingManager sharedInstance];
  if (result == MFMailComposeResultSent)
    [loadingManager showMessage:NSLocalizedString(@"PMSMailSent", nil)
                           type:kProgressMessageTypeSucceed
                   withDuration:2.f];
  loadingManager = nil;
  [self dismissModalViewControllerAnimated:YES];
}

@end
