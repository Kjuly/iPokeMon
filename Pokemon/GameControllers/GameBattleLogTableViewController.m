//
//  GameBattleLogTableViewController.m
//  Mew
//
//  Created by Kaijie Yu on 5/20/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameBattleLogTableViewController.h"

@interface GameBattleLogTableViewController () {
 @private
  NSMutableArray * logs_;
}

@property (nonatomic, copy) NSMutableArray * logs;

@end

@implementation GameBattleLogTableViewController

@synthesize logs = logs_;

- (void)dealloc {
  self.logs = nil;
  [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.view setBackgroundColor:[UIColor clearColor]];
  
  logs_ = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.logs count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return kCellHeightOfGameBattleLogTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  GameBattleLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[GameBattleLogTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  NSDictionary * logDetail = [self.logs objectAtIndex:indexPath.row];
  [cell configureCellWithType:[[logDetail valueForKey:@"type"] intValue]
                          log:[logDetail valueForKey:@"log"]
                  description:[logDetail valueForKey:@"description"]
                          odd:(([self.logs count] - indexPath.row) % 2 == 1)];
  logDetail = nil;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - Public Methods

// push new log to |logs_|
- (void)pushLog:(NSString *)log
    description:(NSString *)description
        forType:(MEWGameBattleLogType)type {
  NSDictionary * logDetail = [[NSDictionary alloc] initWithObjectsAndKeys:
                              log,                           @"log",
                              description,                   @"description",
                              [NSNumber numberWithInt:type], @"type", nil];
  if ([self.logs count] == 0 ||
      [[[self.logs objectAtIndex:0] valueForKey:@"type"] intValue]
        != kMEWGameBattleLogTypeAskingForUserAction) {
    [self.logs insertObject:logDetail atIndex:0];
    
    if ([self.logs count])
      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
                            withRowAnimation:UITableViewRowAnimationTop];
    else [self.tableView reloadData];
  }
  else {
    [self.logs replaceObjectAtIndex:0 withObject:logDetail];
    [self.tableView reloadData];
  }
  [logDetail release];
}

@end
