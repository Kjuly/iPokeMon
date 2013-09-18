//
//  PokedexTableViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokedexTableViewController.h"

#import "NSString+Algorithm.h"
#import "GlobalRender.h"
#import "ResourceManager.h"
#import "PokedexTableViewCell.h"
#import "TrainerController.h"
#import "PokemonDetailTabViewController.h"

#import "AppDelegate.h"


@interface PokedexTableViewController () {
 @private
  TrainerController          * trainer_;
  NSFetchedResultsController * fetchedResultsController_;
}

@property (nonatomic, strong) TrainerController          * trainer;
@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;

- (void)_configureCell:(PokedexTableViewCell *)cell
           atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation PokedexTableViewController

@synthesize trainer                  = trainer_;
@synthesize fetchedResultsController = fetchedResultsController_;

- (void)dealloc
{
  self.fetchedResultsController.delegate = nil;
}

- (id)initWithStyle:(UITableViewStyle)style
{
  if (self = [super initWithStyle:style]) {
    [self setTitle:NSLocalizedString(@"Pokedex", nil)];
    self.trainer = [TrainerController sharedInstance];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      // Get a handle to our fetchedResultsController (which implicitly creates it as well)
      // and call |performFetch:| to retrieve the first batch of data
      NSError * error;
      if (! [self.fetchedResultsController performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@">>> Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
      }
    });
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
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
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
//  id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController_ sections] objectAtIndex:section];
//  return [sectionInfo numberOfObjects];
  return [[self.trainer pokedex] length] * 4;
//  return 151;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kCellHeightOfPokedexTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString * cellIdentifier = @"Cell";
  PokedexTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[PokedexTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:cellIdentifier];
    [cell.labelSubtitle setTextColor:[GlobalRender textColorNormal]];
  }
  
  // Configure the cell
  NSInteger rowID = [indexPath row];
  // Set Pokemon photo & name
  if ([[self.trainer pokedex] isBinary1AtIndex:(rowID + 1)])
    [self _configureCell:cell atIndexPath:indexPath];
  else {
    [cell.labelTitle setText:@"? ? ?"];
    [cell.imageView setImage:[UIImage imageNamed:kPMINTableViewPokedexDefaultImage]];
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
  if ([[self.trainer pokedex] isBinary1AtIndex:(rowID + 1)]) {
    PokemonDetailTabViewController * pokemonDetailTabViewController;
    pokemonDetailTabViewController = [PokemonDetailTabViewController alloc];
    (void)[pokemonDetailTabViewController initWithPokemonSID:++rowID withTopbar:YES];
    [self.navigationController pushViewController:pokemonDetailTabViewController animated:YES];
  }
}

#pragma mark - Private Methods

// configure the data for table veiw cell
- (void)_configureCell:(PokedexTableViewCell *)cell
           atIndexPath:(NSIndexPath *)indexPath
{
  Pokemon * pokemon = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [cell.labelTitle setText:
    KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", [pokemon.sid intValue]]), nil)];
  [cell.imageView setImage:pokemon.image];
}

#pragma mark - NSFetchedResultsController Delegate

- (NSFetchedResultsController *)fetchedResultsController
{
  if (fetchedResultsController_ != nil)
    return fetchedResultsController_;
  
  NSLog(@"PokedexTableViewController fetchedResultsController_ == nil, generating a new one...");
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  NSManagedObjectContext * context =
    [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
  NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([Pokemon class])
                                             inManagedObjectContext:context];
  [fetchRequest setEntity:entity];
  
  // Set Sort Descriptors
  NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"sid" ascending:YES];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
  
  // Set Batch Size
  // The fetched results controller will only retrieve a subset of objects at a time from the underlying database,
  // and automatically fetch more as we scroll
  [fetchRequest setFetchBatchSize:20];
  
  // Create the |NSFetchedRequestController| instance
  // |sectionNameKeyPath|: sort the data into sections in table view
  // |cacheName|: the name of the file the fetched results controller should
  //   use to cache any repeat work such as setting up sections and ordering contents
  NSFetchedResultsController * fetchedResultsController = [NSFetchedResultsController alloc];
  (void)[fetchedResultsController initWithFetchRequest:fetchRequest
                                  managedObjectContext:context
                                    sectionNameKeyPath:nil
                                             cacheName:nil];
  
  self.fetchedResultsController = fetchedResultsController;
  fetchedResultsController_.delegate = self;
  return fetchedResultsController_;  
}


// NSFetchedResultsControllerDelegate for TableView
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  // The fetch controller is about to start sending change notifications,
  //   so prepare the table view for updates.
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  UITableView * tableView = self.tableView;
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:
      [self _configureCell:(PokedexTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]
               atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
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
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  // The fetch controller has sent all current change notifications,
  //   so tell the table view to process all updates.
  [self.tableView endUpdates];
}

@end
