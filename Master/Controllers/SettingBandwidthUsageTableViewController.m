//
//  AccountSettingTableViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/10/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SettingBandwidthUsageTableViewController.h"

#import "SettingTableViewCellStyleTitle.h"
#import "SettingSectionHeaderView.h"


@interface SettingBandwidthUsageTableViewController () {
 @private
  NSIndexPath * selectedCellIndexPath_;
}

@property (nonatomic, strong) NSIndexPath * selectedCellIndexPath;

@end


@implementation SettingBandwidthUsageTableViewController

@synthesize selectedCellIndexPath = selectedCellIndexPath_;

- (id)initWithStyle:(UITableViewStyle)style
{
  if (self = [super initWithStyle:style]) {
    [self setTitle:NSLocalizedString(@"Bandwidth Usage", nil)];
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

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return kNumberOfGeneralSectionBandwidthRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kCellHeightOfSettingTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString * cellIdentifier = @"CellStyleTitle";
  SettingTableViewCellStyleTitle *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[SettingTableViewCellStyleTitle alloc] initWithStyle:UITableViewCellStyleValue1
                                                  reuseIdentifier:cellIdentifier];
  }
  
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  NSInteger row = [indexPath row];
  NSString * localizedStringKey = [NSString stringWithFormat:@"PMSSettingGeneralBandWidthUsage%d", row];
  [cell configureCellWithTitle:NSLocalizedString(localizedStringKey, nil)
                         value:nil
                 accessoryType:UITableViewCellAccessoryNone];
  
  // Highlight the seleceted cell
  if (row == [userDefaults integerForKey:kUDKeyGeneralBandwidthUsage]) {
    [cell highlight];
    self.selectedCellIndexPath = indexPath;
  }
  
  return cell;
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
  if ([self.selectedCellIndexPath row] == [indexPath row])
    return;
  
  // Normalize original selected cell
  [((SettingTableViewCellStyleTitle *)[tableView cellForRowAtIndexPath:self.selectedCellIndexPath]) normalize];
  
  // Highlight current selected cell
  [((SettingTableViewCellStyleTitle *)[tableView cellForRowAtIndexPath:indexPath]) highlight];
  self.selectedCellIndexPath = indexPath;
  [tableView reloadData];
  
  // Save value to UserDefaults & post notification to |SettingTableViewController| to update value
  NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setInteger:[indexPath row] forKey:kUDKeyGeneralBandwidthUsage];
  [userDefaults synchronize];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUDGeneralBandwidthUsage
                                                      object:self
                                                    userInfo:nil];
}

@end
