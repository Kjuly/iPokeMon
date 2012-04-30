//
//  BagTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "StoreTableViewController.h"

#import "BagTableViewCell.h"
#import "BagMedicineTableViewController.h"
#import "BagItemTableViewController.h"
#import "PurchaseTableViewController.h"


@implementation StoreTableViewController

- (void)dealloc {
  [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
  if (self = [super initWithStyle:style]) {
    [self setTitle:NSLocalizedString(@"PMSStore", nil)];
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
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kCellHeightOfBagTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  BagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[BagTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  NSInteger index = [indexPath row] + 1;
  if (index == 6) {
    [cell configureCellWithTitle:NSLocalizedString(@"PMSStoreCurrencyTransactions", nil)
                            icon:[UIImage imageNamed:[NSString stringWithFormat:kPMINIconCurrencyTransactions, index]]
                   accessoryType:UITableViewCellAccessoryNone];
  }
  else {
    [cell configureCellWithTitle:NSLocalizedString(([NSString stringWithFormat:@"Bag%d", index]), nil)
                            icon:[UIImage imageNamed:[NSString stringWithFormat:kPMINIconBagTableViewCell, index]]
                   accessoryType:UITableViewCellAccessoryNone];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
  // currency transactions
  if (row == 5) {
    PurchaseTableViewController * purchaseTableViewController;
    purchaseTableViewController = [[PurchaseTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:purchaseTableViewController animated:YES];
    [purchaseTableViewController release];
  }
  else if (row != 1) { // Not Bag Medicine, as it has three sub types
    BagItemTableViewController * bagItemTableViewController = [BagItemTableViewController alloc];
    [bagItemTableViewController initWithBagItem:(1 << row)];
    [bagItemTableViewController setTitle:NSLocalizedString(([NSString stringWithFormat:@"Bag%d", row + 1]), nil)];
    [self.navigationController pushViewController:bagItemTableViewController animated:YES];
    [bagItemTableViewController release];
  } else {
    BagMedicineTableViewController * bagMedicineTableViewController = [BagMedicineTableViewController alloc];
    [bagMedicineTableViewController initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:bagMedicineTableViewController animated:YES];
    [bagMedicineTableViewController release];
  }
}

@end
