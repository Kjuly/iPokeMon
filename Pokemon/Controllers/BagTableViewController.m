//
//  BagTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagTableViewController.h"

#import "BagTableViewCell.h"
#import "BagItemTableViewController.h"

@implementation BagTableViewController

@synthesize bagItems = bagItems_;

- (void)dealloc
{
  [bagItems_ release];
  
  [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
  
  bagItems_ = [[NSArray alloc] initWithObjects:
               [NSDictionary dictionaryWithObjectsAndKeys:@"Items",       @"item", @"BagItemIcon_Items",       @"image", nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"Medicine",    @"item", @"BagItemIcon_Medicine",    @"image", nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"Pokeballs",   @"item", @"BagItemIcon_Pokeballs",   @"image", nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"TMs & HMs",   @"item", @"BagItemIcon_TMsHMs",      @"image", nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"Berries",     @"item", @"BagItemIcon_Berries",     @"image", nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"Mail",        @"item", @"BagItemIcon_Mail",        @"image", nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"BattleItems", @"item", @"BagItemIcon_BattleItems", @"image", nil],
               [NSDictionary dictionaryWithObjectsAndKeys:@"KeyItems",    @"item", @"BagItemIcon_KeyItems",    @"image", nil],
               nil];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.bagItems = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.bagItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 52.f; // ~ (480 - 60) / 8
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  BagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[BagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  NSDictionary * itemDict = [self.bagItems objectAtIndex:[indexPath row]];
  [cell.labelTitle setText:[itemDict valueForKey:@"item"]];
  [cell.imageView setImage:[UIImage imageNamed:[itemDict objectForKey:@"image"]]];
  
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
  BagItemTableViewController * bagItemTableViewController
  = [[BagItemTableViewController alloc] initWithBagItem:(row ? 1 << row : 0)];
  [self.navigationController pushViewController:bagItemTableViewController animated:YES];
  [bagItemTableViewController release];
}

@end
