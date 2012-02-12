//
//  TrainerBadgesTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerBadgesTableViewController.h"

#import "TrainerBadgesTableViewCell.h"


@implementation TrainerBadgesTableViewController

@synthesize gymLeaders = gymLeaders_;

- (void)dealloc
{
  [gymLeaders_ release];
  
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
  
  gymLeaders_ = [[NSArray alloc] initWithObjects:
                 [NSDictionary dictionaryWithObjectsAndKeys:@"gymLeaderImage_1.png", @"image", @"Gym Leader Name 1", @"name", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"gymLeaderImage_2.png", @"image", @"Gym Leader Name 2", @"name", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"gymLeaderImage_3.png", @"image", @"Gym Leader Name 3", @"name", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"gymLeaderImage_4.png", @"image", @"Gym Leader Name 4", @"name", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"gymLeaderImage_5.png", @"image", @"Gym Leader Name 5", @"name", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"gymLeaderImage_6.png", @"image", @"Gym Leader Name 6", @"name", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"gymLeaderImage_7.png", @"image", @"Gym Leader Name 7", @"name", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:@"gymLeaderImage_8.png", @"image", @"Gym Leader Name 8", @"name", nil],
                 nil];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.gymLeaders = nil;
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
  return [self.gymLeaders count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 52.5f; // (480 - 60) / 8
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  TrainerBadgesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[TrainerBadgesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  NSDictionary * gymLeaderDict = [self.gymLeaders objectAtIndex:[indexPath row]];
  [cell.imageView setImage:[UIImage imageNamed:[gymLeaderDict objectForKey:@"image"]]];
  [cell.labelTitle setText:[gymLeaderDict objectForKey:@"name"]];
  
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
//  NSLog(@"123333");
//  if (self.navigationController) {
//    NSLog(@"-----");
//  }
//  UIViewController * viewController = [[UIViewController alloc] init];
//  [viewController.view setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
//  [viewController.view setBackgroundColor:[UIColor blueColor]];
//  [self.parentViewController.navigationController pushViewController:viewController animated:YES];
////  [self.navigationController pushViewController:viewController animated:YES];
//  [viewController release];
}

@end
