//
//  AccountSettingTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingGameSettingsTableViewController.h"

#import "SettingTableViewCellStyleTitle.h"
#import "SettingTableViewCellStyleSwitch.h"
#import "SettingSectionHeaderView.h"

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

@implementation SettingGameSettingsTableViewController

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
  return kNumberOfGameSettingsSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case kGameSettingsSectionVolume:
      return kNumberOfGameSettingsSectionVolumeRows;
      break;
      
    case kGameSettingsSectionOthers:
      return kNumberOfGameSettingsSectionOthersRows;
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
    NSLocalizedString(([NSString stringWithFormat:@"PMSSettingGeneralGameSettingsSection%d", section + 1]), nil)];
  return [sectionHeaderView autorelease];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString * CellIdentifier;
  
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  NSInteger sectionNum = indexPath.section;
  NSInteger rowNum     = indexPath.row;
  //////VOLUME//////
  if (sectionNum == kGameSettingsSectionVolume) {
    switch (rowNum) {
      ///GENERAL - Location Service
      case kGameSettingsSectionVolumeMaster: {
        CellIdentifier = @"CellStyleTitle";
        SettingTableViewCellStyleTitle *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingGeneralGameSettingsVolumeSounds", nil)
                               value:nil
                       accessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        return cell;
        break;
      }
        
      ///GENERAL - Bandwidth Usage
      case kGameSettingsSectionVolumeMusic: {
        CellIdentifier = @"CellStyleTitle";
        SettingTableViewCellStyleTitle *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingGeneralGameSettingsVolumeMusic", nil)
                               value:nil
                       accessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        return cell;
        break;
      }
        
      ///GENERAL - Game Settings
      case kGameSettingsSectionVolumeSounds: {
        CellIdentifier = @"CellStyleTitle";
        SettingTableViewCellStyleTitle *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingGeneralGameSettingsVolumeSounds", nil)
                               value:nil
                       accessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        return cell;
        break;
      }
        
      default:
        break;
    }
  }
  //////ANIMATIONS//////
  else if (sectionNum == kGameSettingsSectionOthers) {
    switch (rowNum) {
      ///ABOUT - Version
      case kGameSettingsSectionOthersAnimation: {
        CellIdentifier = @"CellStyleSwitch";
        SettingTableViewCellStyleSwitch *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
          cell = [[[SettingTableViewCellStyleSwitch alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingGeneralGameSettingsOthersAnimations", nil)
                            switchOn:[userDefaults boolForKey:kUDKeyGeneralLocationServices]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
