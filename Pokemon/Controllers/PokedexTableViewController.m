//
//  PokedexTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokedexTableViewController.h"

#import "PListParser.h"
#import "DataDecoder.h"
#import "Pokemon.h"
#import "PokedexTableViewCell.h"
#import "PokemonDetailTabViewController.h"

#import "AppDelegate.h"


@interface PokedexTableViewController ()

- (void)configureCell:(PokedexTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation PokedexTableViewController

@synthesize pokedexSequence = pokedexSequence_;

@synthesize fetchedResultsController = fetchedResultsController_;

- (void)dealloc
{
  [pokedexSequence_ release];
  
  self.fetchedResultsController.delegate = nil;
  self.fetchedResultsController = nil;
  
  [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Get a handle to our fetchedResultsController (which implicitly creates it as well)
    // and call |performFetch:| to retrieve the first batch of data
    NSError * error;
    if (! [[self fetchedResultsController] performFetch:&error]) {
      // Update to handle the error appropriately.
      NSLog(@">>> Unresolved error %@, %@", error, [error userInfo]);
      exit(-1);  // Fail
    }
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
  NSString * dataFromWebService = @"2db7aab7";
  self.pokedexSequence = [DataDecoder generateHexArrayFrom:dataFromWebService];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.pokedexSequence = nil;
  
  self.fetchedResultsController = nil;
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
  id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController_ sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  PokedexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[PokedexTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell
  NSInteger rowID = [indexPath row];
  // Set Pokemon photo & name
  // 1 << 0 = 0001, 1 << 1 = 0010
  if ([[self.pokedexSequence objectAtIndex:([self.pokedexSequence count] - rowID / 16 - 1)] intValue] & (1 << (rowID % 16)))
    [self configureCell:cell atIndexPath:indexPath];
  else {
    [cell.labelTitle setText:@"? ? ?"];
    [cell.imageView setImage:[UIImage imageNamed:@"PokedexDefaultImage.png"]];
  }
  // Set Pokemon ID as subtitle
  [cell.labelSubtitle setText:[NSString stringWithFormat:@"#%.3d", ++rowID]];
  
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
  NSInteger rowID = [indexPath row];
  if ([[self.pokedexSequence objectAtIndex:([self.pokedexSequence count] - rowID / 16 - 1)] intValue] & (1 << (rowID % 16))) {
    PokemonDetailTabViewController * pokemonDetailTabViewController = [[PokemonDetailTabViewController alloc]
                                                                       initWithPokemonID:++rowID];
    [self.navigationController pushViewController:pokemonDetailTabViewController animated:YES];
    [pokemonDetailTabViewController release];
  }
}

#pragma mark - Private Methods

- (void)configureCell:(PokedexTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  //  FailedBankInfo *info = [_fetchedResultsController objectAtIndexPath:indexPath];
  //  cell.textLabel.text = info.name;
  //  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", 
  //                               info.city, info.state];
  Pokemon * pokemon = [fetchedResultsController_ objectAtIndexPath:indexPath];
  [cell.labelTitle setText:NSLocalizedString(pokemon.name, nil)];
  [cell.imageView setImage:pokemon.image];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController
{
  if (fetchedResultsController_ != nil) {
    NSLog(@"PokedexTableViewController fetchedResultsController_ != nil");
    return fetchedResultsController_;
  }
  
  NSLog(@"PokedexTableViewController fetchedResultsController_ == nil, generating a new one...");
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext * context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  NSEntityDescription * entity = [NSEntityDescription entityForName:@"Pokemon" inManagedObjectContext:context];
  [fetchRequest setEntity:entity];
  
  // Set Sort Descriptors
  NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"sid" ascending:YES];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
  
  // Set Batch Size
  // The fetched results controller will only retrieve a subset of objects at a time from the underlying database,
  // and automatically fetch mroe as we scroll
  [fetchRequest setFetchBatchSize:20];
  
  // Create the |NSFetchedRequestController| instance
  NSFetchedResultsController *theFetchedResultsController = 
  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                      managedObjectContext:context
                                        sectionNameKeyPath:nil          // sort the data into sections in table view
                                                 cacheName:nil]; // the name of the file the fetched results controller should use to cache any repeat work such as setting up sections and ordering contents
  self.fetchedResultsController = theFetchedResultsController;
  fetchedResultsController_.delegate = self;
  
  [sort release];
  [fetchRequest release];
  [theFetchedResultsController release];
  
  return fetchedResultsController_;  
}


// NSFetchedResultsControllerDelegate for TableView
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  
  UITableView *tableView = self.tableView;
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self configureCell:(PokedexTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray
                                         arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray
                                         arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
  [self.tableView endUpdates];
}

@end
