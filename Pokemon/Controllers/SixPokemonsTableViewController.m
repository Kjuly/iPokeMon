//
//  SixPokemonsTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsTableViewController.h"

#import "PListParser.h"
#import "TrainerTamedPokemon+DataController.h"
#import "Pokemon.h"
#import "SixPokemonsTableViewCell.h"
#import "PokemonDetailTabViewController.h"


@implementation SixPokemonsTableViewController

@synthesize sixPokemons = sixPokemons_;

- (void)dealloc
{
  [sixPokemons_ release];
  
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
  /*sixPokemonsID_ = [[NSMutableArray alloc] initWithObjects:
                    [NSNumber numberWithInt:0x0001],
                    [NSNumber numberWithInt:0x0011],
                    [NSNumber numberWithInt:0x0021],
                    [NSNumber numberWithInt:0x0031],
                    [NSNumber numberWithInt:0x0041],
                    [NSNumber numberWithInt:0x0051],
                    nil];
  self.sixPokemons = [PListParser sixPokemons:self.sixPokemonsID];*/
  
  self.sixPokemons = [TrainerTamedPokemon sixPokemonsForTrainer:1];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.sixPokemons = nil;
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
  return [self.sixPokemons count];
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
//  NSInteger pokemonID = [[self.sixPokemonsID objectAtIndex:rowID] intValue] >> 4;
  
  TrainerTamedPokemon * pokemonData = [self.sixPokemons objectAtIndex:rowID];
  Pokemon * pokemonBaseInfo = pokemonData.pokemon;
  
  // Image
  [cell.imageView setImage:pokemonBaseInfo.image];
  
  // Data
  [cell.nameLabel setText:NSLocalizedString(pokemonBaseInfo.name, nil)];
  [cell.genderLabel setText:pokemonData.gender ? @"M" : @"F"];
  [cell.levelLabel setText:[NSString stringWithFormat:@"Lv.%d", [pokemonData.level intValue]]];
  
  // Stats data array
  NSArray * leftStatsArray;
  NSArray * maxStatsArray;
  if ([pokemonData.leftStats isKindOfClass:[NSString class]] || [pokemonData.maxStats isKindOfClass:[NSString class]]) {
    leftStatsArray = [pokemonData.leftStats componentsSeparatedByString:@","];
    maxStatsArray  = [pokemonData.maxStats  componentsSeparatedByString:@","];
  }
  else {
    leftStatsArray = pokemonData.leftStats;
    maxStatsArray  = pokemonData.maxStats;
  }
  NSInteger HPLeft  = [[leftStatsArray objectAtIndex:0] intValue];
  NSInteger HPTotal = [[maxStatsArray objectAtIndex:0] intValue];
  [cell.HPLabel setText:[NSString stringWithFormat:@"%d/%d", HPLeft, HPTotal]];
  [cell.HPBarLeft setFrame:CGRectMake(0.0f, 0.0f, 150.0f * HPLeft / HPTotal, cell.HPBarLeft.frame.size.height)];
  
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
//  NSInteger pokemonID = [[self.sixPokemonsID objectAtIndex:[indexPath row] + 1] intValue] >> 4;
  NSInteger pokemonID = [[[self.sixPokemons objectAtIndex:[indexPath row]] valueForKey:@"sid"] intValue];
  PokemonDetailTabViewController * pokemonDetailTabViewController = [[PokemonDetailTabViewController alloc]
                                                                     initWithPokemonID:pokemonID];
  [self.navigationController pushViewController:pokemonDetailTabViewController animated:YES];
  [pokemonDetailTabViewController release];
}

@end
