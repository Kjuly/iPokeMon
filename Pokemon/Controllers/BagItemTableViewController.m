//
//  BagItemTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemTableViewController.h"

#import "PListParser.h"
#import "BagDataController.h"
#import "BagItemTableViewCell.h"


@implementation BagItemTableViewController

@synthesize items = items_;
@synthesize itemNumberSequence = itemNumberSequence;

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
    self.items = [[[BagDataController sharedInstance] queryAllDataFor:itemTypeID] mutableCopy];
    
    /*switch (ItemTypeID) {
      case 0:
//        items_ = [[PListParser bagItems] mutableCopy];
        self.items = [[[BagDataController sharedInstance] queryAllDataFor:kBagQueryTargetTypeItem] mutableCopy];
        break;
        
      case 1:
//        items_ = [[PListParser bagMedicine] mutableCopy];
        self.items = [[[BagDataController sharedInstance] queryAllDataFor:kBagQueryTargetTypeMedicine] mutableCopy];
        break;
        
      case 2:
//        items_ = [[PListParser bagPokeballs] mutableCopy];
        self.items = [[[BagDataController sharedInstance] queryAllDataFor:kBagQueryTargetTypePokeball] mutableCopy];
        break;
        
      case 3:
//        items_ = [[PListParser bagTMsHMs] mutableCopy];
        self.items = [[[BagDataController sharedInstance] queryAllDataFor:kBagQueryTargetTypeTMHM] mutableCopy];
        break;
        
      case 4:
//        items_ = [[PListParser bagBerries] mutableCopy];
        self.items = [[[BagDataController sharedInstance] queryAllDataFor:kBagQueryTargetTypeBerry] mutableCopy];
        break;
        
      case 5:
//        items_ = [[PListParser bagMail] mutableCopy];
        self.items = [[[BagDataController sharedInstance] queryAllDataFor:kBagQueryTargetTypeMail] mutableCopy];
        break;
        
      case 6:
//        items_ = [[PListParser bagBattleItems] mutableCopy];
        self.items = [[[BagDataController sharedInstance] queryAllDataFor:kBagQueryTargetTypeBattleItem] mutableCopy];
        break;
        
      case 7:
        self.items = [[[BagDataController sharedInstance] queryAllDataFor:kBagQueryTargetTypeKeyItem] mutableCopy];
        break;
        
      default:
        self.items = nil;
        break;
    }*/
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
  return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  BagItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[BagItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
//  [cell.labelTitle setText:[[self.items objectAtIndex:[indexPath row]] objectForKey:@"name"]];
  BagMedicine * bagMedicine = [self.items objectAtIndex:[indexPath row]];
  NSLog(@"%@", bagMedicine);
  [cell.labelTitle setText:[bagMedicine.sid stringValue]];
//  [cell.imageView setImage:];
  bagMedicine = nil;
  
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

@end
