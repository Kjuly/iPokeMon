//
//  BagItemTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemTableViewController.h"

#import "PListParser.h"
#import "TrainerCoreDataController.h"
#import "BagItemTableViewCell.h"


@interface BagItemTableViewController () {
 @private
  BagQueryTargetType targetType_;
}

@property (nonatomic, assign) BagQueryTargetType targetType;

- (void)configureCell:(BagItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation BagItemTableViewController

@synthesize items = items_;
@synthesize itemNumberSequence = itemNumberSequence;

@synthesize targetType = targetType_;

-(void)dealloc
{
  [items_ release];
  
  [super dealloc];
}

- (id)initWithBagItem:(NSInteger)itemTypeID
{
  self = [self initWithStyle:UITableViewStylePlain];
  if (self) {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewBackgroundBlack.png"]]];
    self.items = [[[TrainerCoreDataController sharedInstance] bagItemsFor:itemTypeID] mutableCopy];
    targetType_ = itemTypeID;
  }
  return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
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
  
  // Fetch data from web service
  // max: 0x03e7 = 999
  self.itemNumberSequence = 0x0000;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.items = nil;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 45.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return round([self.items count] / 2); // <ID, Quantity>
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  BagItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[BagItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
//  id entity = [self.items objectAtIndex:[indexPath row]];
  [self configureCell:cell atIndexPath:indexPath];
  
//  [cell.labelTitle setText:[entity.sid stringValue]];
//  [cell.imageView setImage:];
//  entity = nil;
  
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

#pragma mark - Private Methods

- (void)configureCell:(BagItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  NSInteger row = [indexPath row];
//  id anonymousEntity = [self.items objectAtIndex:[indexPath row]];
  NSString * localizedNameHeader;
  NSInteger entityID = [[self.items objectAtIndex:(row * 2)] intValue];
  NSInteger entityQuantity = [[self.items objectAtIndex:(row * 2 + 1)] intValue];
//  NSInteger  entityID;
  if (targetType_ & kBagQueryTargetTypeItem) {
//    BagItem * entity    = anonymousEntity;
    localizedNameHeader = @"PMSBagItem";
//    entityID            = [entity.sid intValue];
//    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeMedicine) {
//    BagMedicine * entity = anonymousEntity;
    localizedNameHeader  = @"PMSBagMedicine";
//    entityID             = [entity.sid intValue];
//    entity               = nil;
  } else if (targetType_ & kBagQueryTargetTypePokeball) {
//    BagPokeball * entity = anonymousEntity;
    localizedNameHeader  = @"PMSBagPokeball";
//    entityID             = [entity.sid intValue];
//    entity               = nil;
  } else if (targetType_ & kBagQueryTargetTypeTMHM) {
//    BagTMHM * entity    = anonymousEntity;
    localizedNameHeader = @"PMSBagTMHM";
//    entityID            = [entity.sid intValue];
//    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeBerry) {
//    BagBerry * entity   = anonymousEntity;
    localizedNameHeader = @"PMSBagBerry";
//    entityID            = [entity.sid intValue];
//    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeMail) {
//    BagMail * entity    = anonymousEntity;
    localizedNameHeader = @"PMSBagMail";
//    entityID            = [entity.sid intValue];
//    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeBattleItem) {
//    BagBattleItem * entity = anonymousEntity;
    localizedNameHeader    = @"PMSBagBattleItem";
//    entityID               = [entity.sid intValue];
//    entity                 = nil;
  } else if (targetType_ & kBagQueryTargetTypeKeyItem) {
//    BagKeyItem * entity = anonymousEntity;
    localizedNameHeader = @"PMSBagKeyItem";
//    entityID            = [entity.sid intValue];
//    entity = nil;
  } else return;
  
  // Set the data for cell to display
  [cell.name setText:NSLocalizedString(([NSString stringWithFormat:@"%@%.3d",
                                         localizedNameHeader, entityID]), nil)];
  [cell.quantity setText:[NSString stringWithFormat:@"%d", entityQuantity]];
//  anonymousEntity     = nil;
  localizedNameHeader = nil;
}

@end
