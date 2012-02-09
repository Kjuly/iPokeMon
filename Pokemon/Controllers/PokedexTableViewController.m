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
#import "PokemonDetailTabViewController.h"


@implementation PokedexTableViewController

@synthesize pokedexSequence = pokedexSequence_;
@synthesize pokedex         = pokedex_;
@synthesize pokedexImages   = pokedexImages_;

- (void)dealloc
{
  [pokedexSequence_ release];
  [pokedex_         release];
  [pokedexImages_   release];
  
  [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
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
  self.pokedex         = [PListParser pokedex];
  self.pokedexImages   = [PListParser pokedexGenerationOneImageArray];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.pokedexSequence = nil;
  self.pokedex         = nil;
  self.pokedexImages   = nil;
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
  return [self.pokedex count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell
  NSInteger rowID = [indexPath row];
  // Set Pokemon photo & name
  // 1 << 0 = 0001, 1 << 1 = 0010
  if ([[self.pokedexSequence objectAtIndex:([self.pokedexSequence count] - rowID / 16 - 1)] intValue] & (1 << (rowID % 16))) {
    [cell.textLabel setText:[[self.pokedex objectAtIndex:rowID] objectForKey:@"name"]];
    [cell.imageView setImage:[self.pokedexImages objectAtIndex:rowID]];
  }
  else {
    [cell.textLabel setText:@"? ? ?"];
    [cell.imageView setImage:[UIImage imageNamed:@"PokedexDefaultImage.png"]];
  }
  // Set Pokemon ID as subtitle
  [cell.detailTextLabel setText:[NSString stringWithFormat:@"#%.3d", ++rowID]];
  
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
                                                                       initWithPokemonID:[indexPath row]];
    [self.navigationController pushViewController:pokemonDetailTabViewController animated:YES];
    [pokemonDetailTabViewController release];
  }
}

@end
