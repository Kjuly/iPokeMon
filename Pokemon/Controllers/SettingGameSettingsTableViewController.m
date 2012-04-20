//
//  AccountSettingTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingGameSettingsTableViewController.h"

#import "SettingTableViewCellStyleSwitch.h"
#import "SettingTableViewCellStyleSlider.h"
#import "SettingSectionHeaderView.h"

@interface SettingGameSettingsTableViewController ()

- (void)updateValueWithSlider:(UIControl *)button event:(UIEvent *)event;
- (void)updateValueWithTappedSwitchButton:(UIControl *)button event:(UIEvent *)event;

@end


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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
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
  return kSectionHeaderHeightOfSettingTableView;
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
    CellIdentifier = @"CellStyleTitle";
    SettingTableViewCellStyleSlider *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[SettingTableViewCellStyleSlider alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    switch (rowNum) {
      ///GENERAL - Location Service
      case kGameSettingsSectionVolumeMaster:
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingGeneralGameSettingsVolumeMaster", nil)
                         sliderValue:([userDefaults floatForKey:kUDKeyGameSettingsMaster] / 100.f)];
        break;
        
      ///GENERAL - Bandwidth Usage
      case kGameSettingsSectionVolumeMusic:
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingGeneralGameSettingsVolumeMusic", nil)
                         sliderValue:([userDefaults floatForKey:kUDKeyGameSettingsMusic] / 100.f)];
        break;
        
      ///GENERAL - Game Settings
      case kGameSettingsSectionVolumeSounds:
        [cell configureCellWithTitle:NSLocalizedString(@"PMSSettingGeneralGameSettingsVolumeSounds", nil)
                         sliderValue:([userDefaults floatForKey:kUDKeyGameSettingsSounds] / 100.f)];
        break;
        
      default:
        break;
    }
    [cell.slider addTarget:self
                    action:@selector(updateValueWithSlider:event:)
          forControlEvents:UIControlEventValueChanged];
    return cell;
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
                            switchOn:[userDefaults boolForKey:kUDKeyGameSettingsAnimations]];
        [cell.switchButton addTarget:self
                              action:@selector(updateValueWithTappedSwitchButton:event:)
                    forControlEvents:UIControlEventValueChanged];
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

#pragma mark - Private Methods

// Update value when Slider value changed
- (void)updateValueWithSlider:(UIControl *)button event:(UIEvent *)event {
  UISlider * slider = (UISlider *)button;
  UITableViewCell * cell = (UITableViewCell *)slider.superview;
  NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
  if (indexPath == nil)
    return;
  
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  // Update value for Location Service
  if (indexPath.section == kGameSettingsSectionVolume) {
    NSString * key;
    switch (indexPath.row) {
      case kGameSettingsSectionVolumeMaster:
        key = kUDKeyGameSettingsMaster;
        break;
        
      case kGameSettingsSectionVolumeMusic:
        key = kUDKeyGameSettingsMusic;
        break;
        
      case kGameSettingsSectionVolumeSounds:
        key = kUDKeyGameSettingsSounds;
        break;
        
      default:
        return;
        break;
    }
    // Save value to UserDefaults
    [userDefaults setInteger:round(slider.value * 100.f) forKey:key];
    [userDefaults synchronize];
  }
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
  if (indexPath.section == kGameSettingsSectionOthers) {
    if (indexPath.row == kGameSettingsSectionOthersAnimation) {
      // Save value to UserDefaults
      [userDefaults setBool:[switchButton isOn] forKey:kUDKeyGameSettingsAnimations];
      [userDefaults synchronize];
    }
  }
}

@end
