//
//  SixPokemonsTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsTableViewController.h"

#import "PListParser.h"
#import "SixPokemonsTableViewCell.h"
#import "PokemonDetailTabViewController.h"


@implementation SixPokemonsTableViewController

@synthesize sixPokemonsID = sixPokemonsID_;
@synthesize sixPokemons   = sixPokemons_;

- (void)dealloc
{
  [sixPokemonsID_ release];
  [sixPokemons_   release];
  
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
  
  // Initialize |sixPokemons_|'s data
  //
  // 0xFFF 1
  //   --- -
  //   ID  1:Live 0:Dead
  //
  sixPokemonsID_ = [[NSMutableArray alloc] initWithObjects:
                    [NSNumber numberWithInt:0x0001],
                    [NSNumber numberWithInt:0x0011],
                    [NSNumber numberWithInt:0x0021],
                    [NSNumber numberWithInt:0x0031],
                    [NSNumber numberWithInt:0x0041],
                    [NSNumber numberWithInt:0x0051],
                    nil];
  self.sixPokemons = [PListParser sixPokemons:self.sixPokemonsID];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.sixPokemonsID = nil;
  self.sixPokemons   = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if (self.navigationController.isNavigationBarHidden)
    [self.navigationController setNavigationBarHidden:NO];
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
  return [self.sixPokemonsID count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 70.0f; // (480 - 60) / 6
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  SixPokemonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[SixPokemonsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
  NSInteger rowID = [indexPath row];
  NSInteger pokemonID = [[self.sixPokemonsID objectAtIndex:rowID] intValue] >> 4;
  
  // Image
  [cell.imageView setImage:[PListParser pokedexGenerationOneImageForPokemon:pokemonID]];
  // Data
  [cell.nameLabel setText:[[self.sixPokemons objectAtIndex:rowID] objectForKey:@"name"]];
  [cell.genderLabel setText:@"M"];
  [cell.levelLabel setText:[NSString stringWithFormat:@"Lv.%d", 33]];
  [cell.HPLabel setText:[NSString stringWithFormat:@"%d/%d", 123, 999]];
  [cell.HPBarLeft setFrame:CGRectMake(0.0f, 0.0f, 123.0f, cell.HPBarLeft.frame.size.height)];
  
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
  NSInteger pokemonID = [[self.sixPokemonsID objectAtIndex:[indexPath row]] intValue] >> 4;
  PokemonDetailTabViewController * pokemonDetailTabViewController = [[PokemonDetailTabViewController alloc]
                                                                     initWithPokemonID:pokemonID];
  [self.navigationController pushViewController:pokemonDetailTabViewController animated:YES];
  [pokemonDetailTabViewController release];
}

@end
