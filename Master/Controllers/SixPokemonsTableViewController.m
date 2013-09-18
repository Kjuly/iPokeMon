//
//  SixPokemonsTableViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsTableViewController.h"

#import "TrainerController.h"
#import "Pokemon.h"
#import "SixPokemonsTableViewCell.h"
#import "SixPokemonsDetailTabViewController.h"


@interface SixPokemonsTableViewController () {
 @private
  TrainerController      * trainer_;
  NSMutableArray         * sixPokemons_;
  UITapGestureRecognizer * tapGestureRecognizer_;
}

- (void)_tapGestureAction:(UITapGestureRecognizer *)recognizer;

@property (nonatomic, strong) TrainerController      * trainer;
@property (nonatomic, copy)   NSMutableArray         * sixPokemons;
@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;

@end


@implementation SixPokemonsTableViewController

@synthesize trainer              = trainer_;
@synthesize sixPokemons          = sixPokemons_;
@synthesize tapGestureRecognizer = tapGestureRecognizer_;


- (id)initWithStyle:(UITableViewStyle)style
{
  if (self = [super initWithStyle:style]) {
    [self setTitle:NSLocalizedString(@"Pokemon", nil)];
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
  
  // Basic setting
  self.trainer = [TrainerController sharedInstance];
  
  // Tap gesture recognizer
  UITapGestureRecognizer * tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapGestureAction:)];
  self.tapGestureRecognizer = tapGestureRecognizer;
  [self.tapGestureRecognizer setNumberOfTapsRequired:1];
  [self.tapGestureRecognizer setNumberOfTouchesRequired:2];
  [self.tableView addGestureRecognizer:self.tapGestureRecognizer];
  
  // Implement the completion block
  // iOS4 will not call |viewWillAppear:| when the VC is a child of another VC
  if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    [self viewWillAppear:YES];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.sixPokemons = [NSMutableArray arrayWithArray:[self.trainer sixPokemons]];
  NSLog(@"%@, %@, %@", [self.trainer sixPokemonsUID], [self.trainer sixPokemons], self.trainer);
  NSLog(@"%@", self.sixPokemons);
  [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.sixPokemons count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kCellHeightOfSixPokemonsTableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString * cellIdentifier = @"Cell";
  
  SixPokemonsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[SixPokemonsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:cellIdentifier];
  }
  
  // Configure the cell...
  NSInteger rowID = [indexPath row];
  TrainerTamedPokemon * tamedPokemon = [self.sixPokemons objectAtIndex:rowID];
  Pokemon * pokemonBaseInfo = tamedPokemon.pokemon;
  
  // Image
  [cell.imageView setImage:pokemonBaseInfo.image];
  
  // Data
  [cell.nameLabel setText:KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d",
                                                      [pokemonBaseInfo.sid intValue]]), nil)];
  [cell.genderImageView setImage:
    [UIImage imageNamed:[NSString stringWithFormat:kPMINIconPMGender, [tamedPokemon.gender intValue]]]];
  [cell.levelLabel setText:[NSString stringWithFormat:@"Lv.%d", [tamedPokemon.level intValue]]];
  
  // Stats data array
  NSInteger HPLeft  = [tamedPokemon.hp intValue];
  NSInteger HPTotal = [[[tamedPokemon maxStatsInArray] objectAtIndex:0] intValue];
  [cell.HPLabel setText:[NSString stringWithFormat:@"%d/%d", HPLeft, HPTotal]];
  [cell.HPBarLeft setFrame:CGRectMake(0.f, 0.f, 160.f * HPLeft / HPTotal, cell.HPBarLeft.frame.size.height)];
  
  return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return UITableViewCellEditingStyleNone;
}

- (NSInteger)           tableView:(UITableView *)tableView
indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 0;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

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

// Override to support rearranging the table view.
- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
       toIndexPath:(NSIndexPath *)toIndexPath
{
  NSInteger sourceRow      = [fromIndexPath row];
  NSInteger destinationRow = [toIndexPath   row];
  [self.trainer replacePokemonAtIndex:sourceRow toIndex:destinationRow];
  
  // Retch data
  self.sixPokemons = [NSMutableArray arrayWithArray:[self.trainer sixPokemons]];
  [tableView reloadData];
  
  /*
   id object = [self.sixPokemons objectAtIndex:sourceRow];
   
   [self.sixPokemons removeObjectAtIndex:sourceRow];
   [self.sixPokemons insertObject:object atIndex:destinationRow];
   */
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the item to be re-orderable.
  return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  SixPokemonsDetailTabViewController * sixPokemonsDetailTabViewController;
  sixPokemonsDetailTabViewController = [SixPokemonsDetailTabViewController alloc];
  (void)[sixPokemonsDetailTabViewController initWithPokemon:[self.sixPokemons objectAtIndex:[indexPath row]]
                                                 withTopbar:YES];
  [self.navigationController pushViewController:sixPokemonsDetailTabViewController animated:YES];
}

#pragma mark - Private Methods

// Tap gesture action
- (void)_tapGestureAction:(UITapGestureRecognizer *)recognizer
{
  if ([self.tableView isEditing])
    [self.tableView setEditing:NO animated:YES];
  else
    [self.tableView setEditing:YES animated:YES];
}

@end
