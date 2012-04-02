//
//  BagItemTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemTableViewController.h"

#import "AppDelegate.h"
#import "GlobalConstants.h"
#import "GlobalNotificationConstants.h"
#import "PListParser.h"
#import "TrainerController.h"
#import "BagItemTableViewCell.h"
#import "BagItemInfoViewController.h"
#import "GameMenuSixPokemonsViewController.h"

#import <QuartzCore/QuartzCore.h>


@interface BagItemTableViewController () {
 @private
  BagItemTableViewCell              * selectedCell_;
  BagItemTableViewHiddenCell        * hiddenCell_;
  UIView                            * hiddenCellAreaView_;
  BagItemInfoViewController         * bagItemInfoViewController_;
  GameMenuSixPokemonsViewController * gameMenuSixPokemonsViewController_;
}

@property (nonatomic, retain) BagItemTableViewCell              * selectedCell;
@property (nonatomic, retain) BagItemTableViewHiddenCell        * hiddenCell;
@property (nonatomic, retain) UIView                            * hiddenCellAreaView;
@property (nonatomic, retain) BagItemInfoViewController         * bagItemInfoViewController;

@property (nonatomic, retain) GameMenuSixPokemonsViewController * gameMenuSixPokemonsViewController;

- (void)configureCell:(BagItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)showHiddenCellToReplaceCell:(BagItemTableViewCell *)cell;
- (void)cancelHiddenCellWithCompletionBlock:(void (^)(BOOL finished))completion;
- (void)useItemForSelectedPokemon:(NSNotification *)notification;

// Methods for using different items' type
- (void)healStatusAndRestoreHPForPokemon:(TrainerTamedPokemon *)pokemon withBagMedicine:(BagMedicine *)bagMedicine;
- (void)healStatusForPokemon:(TrainerTamedPokemon *)pokemon withBagMedicine:(BagMedicine *)bagMedicine;
- (void)restoreHPForPokemon:(TrainerTamedPokemon *)pokemon withBagMedicine:(BagMedicine *)bagMedicine;
- (void)restorePPForPokemonMove:(Move *)move withBagMedicine:(BagMedicine *)bagMedicine;
- (void)useBerryForPokemon:(TrainerTamedPokemon *)pokemon withBagBerry:(BagBerry *)bagBerry;
- (void)useBattleItemForPokemon:(TrainerTamedPokemon *)pokemon withBagBattleItem:(BagBattleItem *)bagBattleItem;

@end


@implementation BagItemTableViewController

@synthesize items                = items_;
@synthesize itemNumberSequence   = itemNumberSequence;
@synthesize targetType           = targetType_;
@synthesize selectedPokemonIndex = selectedPokemonIndex_;
@synthesize isDuringBattle       = isDuringBattle_;

@synthesize selectedCellIndex                 = selectedCellIndex_;
@synthesize selectedCell                      = selectedCell_;
@synthesize hiddenCell                        = hiddenCell_;
@synthesize hiddenCellAreaView                = hiddenCellAreaView_;
@synthesize bagItemInfoViewController         = bagItemInfoViewController_;
@synthesize gameMenuSixPokemonsViewController = gameMenuSixPokemonsViewController_;

-(void)dealloc
{
  [items_ release];
  
  self.selectedCell = nil;
  self.hiddenCell   = nil;
  [hiddenCellAreaView_                release];
  [bagItemInfoViewController_         release];
  [gameMenuSixPokemonsViewController_ release];
  
  // Remove observers
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kPMNUseItemForSelectedPokemon
                                                object:self.gameMenuSixPokemonsViewController];
  [super dealloc];
}

- (id)initWithBagItem:(BagQueryTargetType)targetType
{
  self = [self initWithStyle:UITableViewStylePlain];
  if (self) [self setBagItem:targetType];
  return self;
}

- (void)setBagItem:(BagQueryTargetType)targetType {
  self.items = [[[TrainerController sharedInstance] bagItemsFor:targetType] mutableCopy];
  self.targetType = targetType;
  
  if ([self.items count] <= 1)
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"EmptyTableViewBackground.png"]]];
  else
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewBackgroundBlack.png"]]];
  
  [self.tableView reloadData];
  
  // Pokeball, Battle Items can only be used during battle
  // can only be used during battle
  if (((targetType & kBagQueryTargetTypePokeball) || (targetType & kBagQueryTargetTypeBattleItem))
      && ! self.isDuringBattle)
    [self.hiddenCell.use setHidden:YES];

  //
  // TODO:
  // Implement them!
  //
  [self.hiddenCell.give setHidden:YES];
  [self.hiddenCell.toss setHidden:YES];
  
  // When during battle, |give| & |toss| can not be actioned
  if (self.isDuringBattle) {
    [self.hiddenCell.give setHidden:YES];
    [self.hiddenCell.toss setHidden:YES];
  }
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewBackgroundBlack.png"]]];
    
    // Basic setting
    selectedCellIndex_    = 0;
    targetType_           = 0;
    selectedPokemonIndex_ = 0;
    isDuringBattle_       = NO;
    
    // Cell Area View
    hiddenCellAreaView_ = [[UIView alloc] initWithFrame:CGRectMake(kViewWidth, 0.f, kViewWidth, kCellHeightOfBagItemTableView)];
    [self.view addSubview:hiddenCellAreaView_];
    
    // Hidden Cell
    hiddenCell_ = [[BagItemTableViewHiddenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hiddenCell"];
    [self.hiddenCell setFrame:CGRectMake(0.f, 0.f, kViewWidth, kCellHeightOfBagItemTableView)];
    self.hiddenCell.delegate = self;
    [hiddenCellAreaView_ addSubview:self.hiddenCell];
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
  
  // Add observer for notification from |GameMenuSixPokemonsViewController|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(useItemForSelectedPokemon:)
                                               name:kPMNUseItemForSelectedPokemon
                                             object:self.gameMenuSixPokemonsViewController];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.items                             = nil;
  self.selectedCell                      = nil;
  self.hiddenCell                        = nil;
  self.hiddenCellAreaView                = nil;
  self.bagItemInfoViewController         = nil;
  self.gameMenuSixPokemonsViewController = nil;
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
  return kCellHeightOfBagItemTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return round([self.items count] / 2); // <ID, Quantity>
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  BagItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[BagItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell
  [self configureCell:cell atIndexPath:indexPath];
  
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
  BagItemTableViewCell * cell = (BagItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  [self showHiddenCellToReplaceCell:cell];
  self.selectedCellIndex = [indexPath row];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if (self.selectedCell != nil) [self cancelHiddenCellWithCompletionBlock:nil];
}

#pragma mark - Public Methods

// Reset the view status
- (void)reset {
  if (self.selectedCell != nil) [self cancelHiddenCellWithCompletionBlock:nil];
}

#pragma mark - Private Methods

- (void)configureCell:(BagItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  NSString * localizedNameHeader;
  if      (targetType_ & kBagQueryTargetTypeItem)       localizedNameHeader = @"PMSBagItem";
  else if (targetType_ & kBagQueryTargetTypeMedicine)   localizedNameHeader = @"PMSBagMedicine";
  else if (targetType_ & kBagQueryTargetTypePokeball)   localizedNameHeader = @"PMSBagPokeball";
  else if (targetType_ & kBagQueryTargetTypeTMHM)       localizedNameHeader = @"PMSBagTMHM";
  else if (targetType_ & kBagQueryTargetTypeBerry)      localizedNameHeader = @"PMSBagBerry";
  else if (targetType_ & kBagQueryTargetTypeMail)       localizedNameHeader = @"PMSBagMail";
  else if (targetType_ & kBagQueryTargetTypeBattleItem) localizedNameHeader = @"PMSBagBattleItem";
  else if (targetType_ & kBagQueryTargetTypeKeyItem)    localizedNameHeader = @"PMSBagKeyItem";
  else return;
  NSInteger row            = [indexPath row];
  NSInteger entityID       = [[self.items objectAtIndex:(row * 2)] intValue];
  NSInteger entityQuantity = [[self.items objectAtIndex:(row * 2 + 1)] intValue];
  
  // Set the data for cell to display
  [cell.name setText:NSLocalizedString(([NSString stringWithFormat:@"%@%.3d", localizedNameHeader, entityID]), nil)];
  [cell.quantity setText:[NSString stringWithFormat:@"%d", entityQuantity]];
  localizedNameHeader = nil;
}

// Show |hiddenCell_|
- (void)showHiddenCellToReplaceCell:(BagItemTableViewCell *)cell {
  void (^showHiddenCellAnimationBlock)(BOOL) = ^(BOOL finished) {
    __block CGRect cellFrame = cell.frame;
    cellFrame.origin.x = kViewWidth;
    [self.hiddenCellAreaView setFrame:cellFrame];
    [UIView animateWithDuration:.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       cellFrame.origin.x = 0.f;
                       [self.hiddenCellAreaView setFrame:cellFrame];
                       cellFrame.origin.x = -kViewWidth;
                       [cell setFrame:cellFrame];
                     }
                     completion:nil];
    self.selectedCell = cell;
  };
  if (self.selectedCell == nil) showHiddenCellAnimationBlock(YES);
  else if (self.selectedCell == cell) return;
  else [self cancelHiddenCellWithCompletionBlock:showHiddenCellAnimationBlock];
}

// Cancel |hiddenCell_|
- (void)cancelHiddenCellWithCompletionBlock:(void (^)(BOOL))completion {
  __block CGRect cellFrame = self.selectedCell.frame;
  [UIView animateWithDuration:.2f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     cellFrame.origin.x = 0.f;
                     [self.selectedCell setFrame:cellFrame];
                     cellFrame.origin.x = kViewWidth;
                     [self.hiddenCellAreaView setFrame:cellFrame];
                   }
                   completion:^(BOOL finished) {
                     [UIView animateWithDuration:.1f
                                           delay:0.f
                                         options:UIViewAnimationOptionCurveEaseOut
                                      animations:^{
                                        cellFrame.origin.x = -10.f;
                                        [self.selectedCell setFrame:cellFrame];
                                      }
                                      completion:^(BOOL finished) {
                                        [UIView animateWithDuration:.1f
                                                              delay:0.f
                                                            options:UIViewAnimationOptionCurveEaseOut
                                                         animations:^{
                                                           cellFrame.origin.x = 0.f;
                                                           [self.selectedCell setFrame:cellFrame];
                                                           self.selectedCell = nil;
                                                         }
                                                         completion:completion];
                                      }];
                   }];
}

// Action for notification from |GameMenuSixPokemonsViewController|
- (void)useItemForSelectedPokemon:(NSNotification *)notification
{
  self.selectedPokemonIndex = [[notification.userInfo objectForKey:@"selectedPokemonIndex"] intValue];
  NSInteger selectedItemID       = [[self.items objectAtIndex:(self.selectedCellIndex * 2)] intValue];
  TrainerTamedPokemon * targetPokemon
  = [[TrainerController sharedInstance] pokemonOfSixAtIndex:self.selectedPokemonIndex];
  id anonymousEntity = [[BagDataController sharedInstance] queryDataFor:self.targetType withID:selectedItemID];
  
  if (self.targetType & kBagQueryTargetTypeItem)              {}
  else if (self.targetType & kBagQueryTargetTypeMedicine) {
    if (self.targetType & kBagQueryTargetTypeMedicineStatus)
      [self healStatusForPokemon:targetPokemon withBagMedicine:(BagMedicine *)anonymousEntity];
    else if (self.targetType & kBagQueryTargetTypeMedicineHP)
      [self restoreHPForPokemon:targetPokemon withBagMedicine:(BagMedicine *)anonymousEntity];
    else if (self.targetType & kBagQueryTargetTypeMedicinePP) {
      NSInteger selectedMoveIndex = [[notification.userInfo objectForKey:@"selectedMoveIndex"] intValue];
      [self restorePPForPokemonMove:[targetPokemon moveWithIndex:selectedMoveIndex]
                    withBagMedicine:(BagMedicine *)anonymousEntity];
    } else return;
  }
  else if (self.targetType & kBagQueryTargetTypePokeball)     {}
  else if (self.targetType & kBagQueryTargetTypeTMHM)         {}
  else if (self.targetType & kBagQueryTargetTypeBerry)
    [self useBerryForPokemon:targetPokemon withBagBerry:(BagBerry *)anonymousEntity];
  else if (self.targetType & kBagQueryTargetTypeMail)         {}
  else if (self.targetType & kBagQueryTargetTypeBattleItem)
    [self useBattleItemForPokemon:targetPokemon withBagBattleItem:(BagBattleItem *)anonymousEntity];
  else if (self.targetType & kBagQueryTargetTypeKeyItem)      {}
  else { anonymousEntity = nil; return; }
  
  // Cancel self view after Use Bag Item done
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUseBagItemDone object:self userInfo:nil];
}

#pragma mark - BagItemTableViewHiddenCell Delegate

// Hidden Cell Button Action: Use Item
- (void)useItem:(id)sender {
  // Throw pokeball to catch wild Pokemon
  if (self.targetType & kBagQueryTargetTypePokeball) {
    
  }
  // Only open |gameMenuSixPokemonsViewController|'s view when the item is used for pokemon
  // (e.g. HP, PP restore, etc)
  else {
    if (self.gameMenuSixPokemonsViewController == nil) {
      GameMenuSixPokemonsViewController * gameMenuSixPokemonViewController
      = [[GameMenuSixPokemonsViewController alloc] init];
      self.gameMenuSixPokemonsViewController = gameMenuSixPokemonViewController;
      [gameMenuSixPokemonViewController release];
    }
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.gameMenuSixPokemonsViewController.view];
    [self.gameMenuSixPokemonsViewController initWithSixPokemonsForReplacing:NO];
    [self.gameMenuSixPokemonsViewController loadSixPokemonsAnimated:YES];
  }
}

// Hidden Cell Button Action: Give Item
- (void)giveItem:(id)sender
{
}

// Hidden Cell Button Action: Toss Item
- (void)tossItem:(id)sender
{
}

// Hidden Cell Button Action: Show Info
- (void)showInfo:(id)sender
{
  if (self.bagItemInfoViewController == nil) {
    BagItemInfoViewController * bagItemInfoViewController = [[BagItemInfoViewController alloc] init];
    self.bagItemInfoViewController = bagItemInfoViewController;
    [bagItemInfoViewController release];
  }
  
  [[[[UIApplication sharedApplication] delegate] window] addSubview:self.bagItemInfoViewController.view];
  NSInteger itemID = [[self.items objectAtIndex:(self.selectedCellIndex * 2)] intValue];
  id anonymousEntity = [[BagDataController sharedInstance] queryDataFor:self.targetType
                                                        withID:itemID];
  NSString * localizedNameHeader;
  NSInteger entityID;
  NSInteger price;
  if (targetType_ & kBagQueryTargetTypeItem) {
    BagItem * entity    = anonymousEntity;
    localizedNameHeader = @"PMSBagItem";
    entityID            = [entity.sid intValue];
    price               = [entity.price intValue];
    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeMedicine) {
    BagMedicine * entity = anonymousEntity;
    localizedNameHeader  = @"PMSBagMedicine";
    entityID             = [entity.sid intValue];
    price                = [entity.price intValue];
    entity               = nil;
  } else if (targetType_ & kBagQueryTargetTypePokeball) {
    BagPokeball * entity = anonymousEntity;
    localizedNameHeader  = @"PMSBagPokeball";
    entityID             = [entity.sid intValue];
    price                = [entity.price intValue];
    entity               = nil;
  } else if (targetType_ & kBagQueryTargetTypeTMHM) {
    BagTMHM * entity    = anonymousEntity;
    localizedNameHeader = @"PMSBagTMHM";
    entityID            = [entity.sid intValue];
    price               = 0;
    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeBerry) {
    BagBerry * entity   = anonymousEntity;
    localizedNameHeader = @"PMSBagBerry";
    entityID            = [entity.sid intValue];
    price               = 0;
    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeMail) {
    BagMail * entity    = anonymousEntity;
    localizedNameHeader = @"PMSBagMail";
    entityID            = [entity.sid intValue];
    price               = 0;
    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeBattleItem) {
    BagBattleItem * entity = anonymousEntity;
    localizedNameHeader    = @"PMSBagBattleItem";
    entityID               = [entity.sid intValue];
    price                  = [entity.price intValue];
    entity                 = nil;
  } else if (targetType_ & kBagQueryTargetTypeKeyItem) {
    BagKeyItem * entity = anonymousEntity;
    localizedNameHeader = @"PMSBagKeyItem";
    price               = 0;
    entityID            = [entity.sid intValue];
    entity = nil;
  } else return;
    
  NSString * name = NSLocalizedString(([NSString stringWithFormat:@"%@%.3d",
                                        localizedNameHeader, entityID]), nil);
  NSString * info = NSLocalizedString(([NSString stringWithFormat:@"%@Info%.3d",
                                        localizedNameHeader, entityID]), nil);
  
  [self.bagItemInfoViewController setDataWithName:name price:price info:info duringBattle:self.isDuringBattle];
  [self.bagItemInfoViewController loadViewWithAnimation];
}

// Hidden Cell Button Action: Cancel Hidden Cell
- (void)cancelHiddenCell:(id)sender {
  [self cancelHiddenCellWithCompletionBlock:nil];
}

#pragma mark - Methods for using different items' type

// Heal Status & Restore HP for Pokemon
- (void)healStatusAndRestoreHPForPokemon:(TrainerTamedPokemon *)pokemon withBagMedicine:(BagMedicine *)bagMedicine
{
  NSInteger effectCode = [bagMedicine.code intValue];
  // 0x81: Restores all HP to one Pokemon and cures them of any status effects
  if (effectCode & 0x01) {
    NSLog(@"- BagMedicine - Status & HP - EffectCode: 0x81");
  }
  // 0x82: Revives a fainted Pokemon and restores half of it's max HP
  else if (effectCode & 0x02) {
    NSLog(@"- BagMedicine - Status & HP - EffectCode: 0x82");
  }
  // 0x84: Revives a fainted Pokemon and fully restores it's HP
  else if (effectCode & 0x04) {
    NSLog(@"- BagMedicine - Status & HP - EffectCode: 0x84");
  }
  // 0x88: Revives all fainted Pokemons and fully restores their HP
  else if (effectCode & 0x08) {
    NSLog(@"- BagMedicine - Status & HP - EffectCode: 0x88");
  }
}

// Use 'Status Healers' to heal Pokemon
- (void)healStatusForPokemon:(TrainerTamedPokemon *)pokemon withBagMedicine:(BagMedicine *)bagMedicine
{
  NSInteger effectCode     = [bagMedicine.code intValue];
  NSInteger pokemonStatus  = [pokemon.status intValue];
  BOOL      healStatusDone = YES;
  
  // 0x80~0x8F: Status Healer & HP Restoree
  if (effectCode & 0x80) [self healStatusAndRestoreHPForPokemon:pokemon withBagMedicine:bagMedicine];
  // If Pokemon's status is Normal, no need to use Status Healers
  else if (pokemonStatus == kPokemonStatusNormal) {
    healStatusDone = NO;
  }
  // 0x7F: 0111 1111
  // Cures one Pokemon of any status effect
  else if (effectCode == 0x7F) {
    NSLog(@"- BagMedicine - Status - EffectCode: 0x7F");
    pokemonStatus = kPokemonStatusNormal;
  }
  // 0x01: 0000 0001
  // Cures one Pokemon of the Burn status effect
  else if (effectCode & 0x01) {
    NSLog(@"- BagMedicine - Status - EffectCode: 0x01");
    if (pokemonStatus & kPokemonStatusBurn)
      pokemonStatus = pokemonStatus & ~kPokemonStatusBurn;
    else healStatusDone = NO;
  }
  // 0x02: 0000 0010
  // Cures one Pokemon of the Confused status effect
  else if (effectCode & 0x02) {
    NSLog(@"- BagMedicine - Status - EffectCode: 0x02");
    if (pokemonStatus & kPokemonStatusConfused)
      pokemonStatus = pokemonStatus & ~kPokemonStatusConfused;
    else healStatusDone = NO;
  }
  // 0x04: 0000 0100
  // Cures one Pokemon of the Flinch status effect
  else if (effectCode & 0x04) {
    NSLog(@"- BagMedicine - Status - EffectCode: 0x04");
    if (pokemonStatus & kPokemonStatusFlinch)
      pokemonStatus = pokemonStatus & ~kPokemonStatusFlinch;
    else healStatusDone = NO;
  }
  // 0x08: 0000 1000
  // Cures one Pokemon of the Freeze status effect
  else if (effectCode & 0x08) {
    NSLog(@"- BagMedicine - Status - EffectCode: 0x08");
    if (pokemonStatus & kPokemonStatusFreeze)
      pokemonStatus = pokemonStatus & ~kPokemonStatusFreeze;
    else healStatusDone = NO;
  }
  // 0x10: 0001 0000
  // Cures one Pokemon of the Paralyze status effect
  else if (effectCode & 0x10) {
    NSLog(@"- BagMedicine - Status - EffectCode: 0x10");
    if (pokemonStatus & kPokemonStatusParalyze)
      pokemonStatus = pokemonStatus & ~kPokemonStatusParalyze;
    else healStatusDone = NO;
  }
  // 0x20: 0010 0000
  // Cures one Pokemon of the Poison status effect
  else if (effectCode & 0x20) {
    NSLog(@"- BagMedicine - Status - EffectCode: 0x20");
    if (pokemonStatus & kPokemonStatusPoison)
      pokemonStatus = pokemonStatus & ~kPokemonStatusPoison;
    else healStatusDone = NO;
  }
  // 0x40: 0100 0000
  // Cures one Pokemon of the Sleep status effect
  else if (effectCode & 0x40) {
    NSLog(@"- BagMedicine - Status - EffectCode: 0x40");
    if (pokemonStatus & kPokemonStatusSleep)
      pokemonStatus = pokemonStatus & ~kPokemonStatusSleep;
    else healStatusDone = NO;
  }
  
  // If Heal Status Done, set new Status to pokemon
  if (healStatusDone) pokemon.status = [NSNumber numberWithInt:pokemonStatus];
}

// Use 'HP Restore' to restore Pokemon HP
- (void)restoreHPForPokemon:(TrainerTamedPokemon *)pokemon withBagMedicine:(BagMedicine *)bagMedicine
{
  NSInteger effectCode   = [bagMedicine.code intValue];
  NSInteger pokemonHP    = [pokemon.currHP intValue];
  NSInteger pokemonHPMax = [[pokemon.maxStats objectAtIndex:0] intValue];
  
  // 0x80~0x8F: Status Healer & HP Restoree
  if (effectCode & 0x80) [self healStatusAndRestoreHPForPokemon:pokemon withBagMedicine:bagMedicine];
  // 0x7F: 0111 1111
  // Restores all HP to every Pokemon
  else if (effectCode == 0x7F) {}
  // 0x39: 0011 1111
  // Restores all HP to one Pokemon
  else if (effectCode == 0x3F) {
    NSLog(@"- BagMedicine - HP - EffectCode: 0x3F");
    pokemonHP = pokemonHPMax;
  }
  // 0x01: 0000 0001
  // Restores 20 HP to one Pokemon
  else if (effectCode & 0x01) {
    NSLog(@"- BagMedicine - HP - EffectCode: 0x01");
    pokemonHP += 20;
  }
  // 0x02: 0000 0010
  // Restores 50 HP to one Pokemon
  else if (effectCode & 0x02) {
    NSLog(@"- BagMedicine - HP - EffectCode: 0x02");
    pokemonHP += 50;
  }
  // 0x04: 0000 0100
  // Restores 60 HP to one Pokemon
  else if (effectCode & 0x04) {
    NSLog(@"- BagMedicine - HP - EffectCode: 0x04");
    pokemonHP += 60;
  }
  // 0x08: 0000 1000
  // Restores 80 HP to one Pokemon
  else if (effectCode & 0x08) {
    NSLog(@"- BagMedicine - HP - EffectCode: 0x08");
    pokemonHP += 80;
  }
  // 0x10: 0001 0000
  // Restores 100 HP to one Pokemon
  else if (effectCode & 0x10) {
    NSLog(@"- BagMedicine - HP - EffectCode: 0x10");
    pokemonHP += 100;
  }
  // 0x20: 0010 0000
  // Restores 200 HP to one Pokemon
  else if (effectCode & 0x20) {
    NSLog(@"- BagMedicine - HP - EffectCode: 0x20");
    pokemonHP += 200;
  }
  else return;
  
  // Set new HP value to |currHP| for Pokemon
  pokemon.currHP = [NSNumber numberWithInt:(pokemonHP > pokemonHPMax ? pokemonHPMax : pokemonHP)];
}

// Use 'PP Restore' to restore Pokemon's move PP
- (void)restorePPForPokemonMove:(Move *)move withBagMedicine:(BagMedicine *)bagMedicine
{
  NSInteger effectCode = [bagMedicine.code intValue];
  // 0x1F: 0001 1111
  // Restores all PP to every move of a selected Pokemon
  if (effectCode == 0x1F) {
    NSLog(@"- BagMedicine - PP - EffectCode: 0x1F");
  }
  // 0x0F: 0000 1111
  // Restores 10 PP to every move of a selected Pokemon
  else if (effectCode == 0x0F) {
    NSLog(@"- BagMedicine - PP - EffectCode: 0x0F");
  }
  // 0x07: 0000 0111
  // Restores all PP to one move of a selected Pokemon
  else if (effectCode == 0x07) {
    NSLog(@"- BagMedicine - PP - EffectCode: 0x07");
  }
  // 0x01: 0000 0001
  // Restores 10 PP to one Pokemon's selected move
  if (effectCode & 0x01) {
    NSLog(@"- BagMedicine - PP - EffectCode: 0x01");
  }
}

// Use 'Berry' for Pokemon
- (void)useBerryForPokemon:(TrainerTamedPokemon *)pokemon withBagBerry:(BagBerry *)bagBerry
{
  
}

// Use 'Battle Item' for Pokemon
- (void)useBattleItemForPokemon:(TrainerTamedPokemon *)pokemon withBagBattleItem:(BagBattleItem *)bagBattleItem
{
  
}

@end
