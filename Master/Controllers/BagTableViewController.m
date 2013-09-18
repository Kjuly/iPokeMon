//
//  BagTableViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagTableViewController.h"

#import "BagTableViewCell.h"
#import "BagMedicineTableViewController.h"
#import "BagItemTableViewController.h"


@implementation BagTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
  if (self = [super initWithStyle:style]) {
    [self setTitle:NSLocalizedString(@"Bag", nil)];
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
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidUnload
{
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
  return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kCellHeightOfBagTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  BagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[BagTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell...
  NSInteger index = [indexPath row] + 1;
  [cell configureCellWithTitle:NSLocalizedString(([NSString stringWithFormat:@"Bag%d", index]), nil)
                          icon:[UIImage imageNamed:[NSString stringWithFormat:kPMINIconBagTableViewCell, index]]
                 accessoryType:UITableViewCellAccessoryNone];
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
  NSInteger row = [indexPath row];
  if (row != 1) { // Not Bag Medicine, as it has three sub types
    BagItemTableViewController * bagItemTableViewController = [BagItemTableViewController alloc];
    (void)[bagItemTableViewController initWithBagItem:(1 << row)];
    [bagItemTableViewController setTitle:NSLocalizedString(([NSString stringWithFormat:@"Bag%d", row + 1]), nil)];
    [self.navigationController pushViewController:bagItemTableViewController animated:YES];
  } else {
    BagMedicineTableViewController * bagMedicineTableViewController = [BagMedicineTableViewController alloc];
    (void)[bagMedicineTableViewController initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:bagMedicineTableViewController animated:YES];
  }
}

@end
