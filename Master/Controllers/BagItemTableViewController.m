//
//  BagItemTableViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemTableViewController.h"

#import "TrainerController.h"
#import "BagItemTableViewCell.h"
#import "BagItemInfoViewController.h"
#import "GameMenuSixPokemonsViewController.h"


@interface BagItemTableViewController () {
 @private
  BagItemTableViewCell              * selectedCell_;
  BagItemTableViewHiddenCell        * hiddenCell_;
  UIView                            * hiddenCellAreaView_;
  TrainerController                 * trainer_;
  BagItemInfoViewController         * bagItemInfoViewController_;
  GameMenuSixPokemonsViewController * gameMenuSixPokemonsViewController_;
}

@property (nonatomic, strong) UIView                            * hiddenCellAreaView;
@property (nonatomic, strong) BagItemTableViewCell              * selectedCell;
@property (nonatomic, strong) BagItemTableViewHiddenCell        * hiddenCell;
@property (nonatomic, strong) TrainerController                 * trainer;
@property (nonatomic, strong) BagItemInfoViewController         * bagItemInfoViewController;
@property (nonatomic, strong) GameMenuSixPokemonsViewController * gameMenuSixPokemonsViewController;

- (void)_configureCell:(BagItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)_showHiddenCellToReplaceCell:(BagItemTableViewCell *)cell;
- (void)_cancelHiddenCellWithCompletionBlock:(void (^)(BOOL finished))completion;
- (void)_useItemForSelectedPokemon:(NSNotification *)notification;
- (NSString *)_localizedNameHeader;

// Methods for using different items' type
- (void)_healStatusAndRestoreHPForPokemon:(TrainerTamedPokemon *)pokemon // heal status & restore HP
                          withBagMedicine:(BagMedicine *)bagMedicine;
- (void)_healStatusForPokemon:(TrainerTamedPokemon *)pokemon             // heal status
              withBagMedicine:(BagMedicine *)bagMedicine;
- (void)_restoreHPForPokemon:(TrainerTamedPokemon *)pokemon              // restore HP
             withBagMedicine:(BagMedicine *)bagMedicine;
- (void)_restorePPForPokemon:(TrainerTamedPokemon *)pokemon              // restore PP
                   moveIndex:(NSInteger)moveIndex
             withBagMedicine:(BagMedicine *)bagMedicine;
- (void)_useBerryForPokemon:(TrainerTamedPokemon *)pokemon               // user berry
               withBagBerry:(BagBerry *)bagBerry;
- (void)_useBattleItemForPokemon:(TrainerTamedPokemon *)pokemon          // user battle item
               withBagBattleItem:(BagBattleItem *)bagBattleItem;

@end


@implementation BagItemTableViewController

@synthesize items                = items_;
@synthesize isDuringBattle       = isDuringBattle_;
@synthesize targetType           = targetType_;
@synthesize selectedCellIndex    = selectedCellIndex_;
@synthesize selectedPokemonIndex = selectedPokemonIndex_;

@synthesize selectedCell                      = selectedCell_;
@synthesize hiddenCell                        = hiddenCell_;
@synthesize hiddenCellAreaView                = hiddenCellAreaView_;
@synthesize trainer                           = trainer_;
@synthesize bagItemInfoViewController         = bagItemInfoViewController_;
@synthesize gameMenuSixPokemonsViewController = gameMenuSixPokemonsViewController_;

-(void)dealloc
{
  // Remove observers
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kPMNUseItemForSelectedPokemon
                                                object:self.gameMenuSixPokemonsViewController];
}

- (id)initWithBagItem:(BagQueryTargetType)targetType
{
  if (self = [self initWithStyle:UITableViewStylePlain]) {
    [self setBagItem:targetType];
  }
  return self;
}

- (void)setBagItem:(BagQueryTargetType)targetType
{
  self.items = [NSMutableArray arrayWithArray:[self.trainer bagItemsFor:targetType]];
  self.targetType = targetType;
  
  if ([self.items count] <= 1)
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundEmpty]]];
  else
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
  
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
  if (self = [super initWithStyle:style]) {
    // Basic setting
    selectedCellIndex_    = 0;
    targetType_           = 0;
    selectedPokemonIndex_ = 0;
    isDuringBattle_       = NO;
    self.trainer          = [TrainerController sharedInstance];
    
    // Cell Area View
    CGRect hiddenCellAreaViewFrame = CGRectMake(kViewWidth, 0.f, kViewWidth, kCellHeightOfBagItemTableView);
    hiddenCellAreaView_ = [[UIView alloc] initWithFrame:hiddenCellAreaViewFrame];
    [self.view addSubview:hiddenCellAreaView_];
    
    // Hidden Cell
    hiddenCell_ = [BagItemTableViewHiddenCell alloc];
    (void)[hiddenCell_ initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hiddenCell"];
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
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
  
  // Add observer for notification from |GameMenuSixPokemonsViewController|
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_useItemForSelectedPokemon:)
                                               name:kPMNUseItemForSelectedPokemon
                                             object:self.gameMenuSixPokemonsViewController];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.hiddenCell         = nil;
  self.hiddenCellAreaView = nil;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kCellHeightOfBagItemTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return round([self.items count] / 2); // <ID, Quantity>
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"Cell";
  BagItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[BagItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cellIdentifier];
  }
  
  // Configure the cell
  [self _configureCell:cell atIndexPath:indexPath];
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
  [self _showHiddenCellToReplaceCell:cell];
  self.selectedCellIndex = [indexPath row];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if (self.selectedCell != nil) [self _cancelHiddenCellWithCompletionBlock:nil];
}

#pragma mark - Public Methods

// Reset the view status
- (void)reset
{
  if (self.selectedCell != nil) [self _cancelHiddenCellWithCompletionBlock:nil];
}

#pragma mark - Private Methods

- (void)_configureCell:(BagItemTableViewCell *)cell
           atIndexPath:(NSIndexPath *)indexPath
{
  NSString * localizedNameHeader = [self _localizedNameHeader];
  if (localizedNameHeader == nil) return;
  
  NSInteger row            = [indexPath row];
  NSInteger entityID       = [[self.items objectAtIndex:(row * 2)] intValue];
  NSInteger entityQuantity = [[self.items objectAtIndex:(row * 2 + 1)] intValue];
  
  // Set the data for cell to display
  [cell.name setText:KYResourceLocalizedString(([NSString stringWithFormat:@"%@%.3d", localizedNameHeader, entityID]), nil)];
  [cell.quantity setText:[NSString stringWithFormat:@"%d", entityQuantity]];
  localizedNameHeader = nil;
}

// Show |hiddenCell_|
- (void)_showHiddenCellToReplaceCell:(BagItemTableViewCell *)cell
{
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
  else [self _cancelHiddenCellWithCompletionBlock:showHiddenCellAnimationBlock];
}

// Cancel |hiddenCell_|
- (void)_cancelHiddenCellWithCompletionBlock:(void (^)(BOOL))completion
{
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
- (void)_useItemForSelectedPokemon:(NSNotification *)notification
{
  self.selectedPokemonIndex = [[notification.userInfo objectForKey:@"selectedPokemonIndex"] intValue];
  NSInteger selectedItemID  = [[self.items objectAtIndex:(self.selectedCellIndex * 2)] intValue];
  TrainerTamedPokemon * targetPokemon = [self.trainer pokemonOfSixAtIndex:self.selectedPokemonIndex];
  id anonymousEntity = [[BagDataController sharedInstance] queryDataFor:self.targetType withID:selectedItemID];
  
  if (self.targetType & kBagQueryTargetTypeItem)              {}
  else if (self.targetType & kBagQueryTargetTypeMedicine) {
    if (self.targetType & kBagQueryTargetTypeMedicineStatus)
      [self _healStatusForPokemon:targetPokemon withBagMedicine:(BagMedicine *)anonymousEntity];
    else if (self.targetType & kBagQueryTargetTypeMedicineHP)
      [self _restoreHPForPokemon:targetPokemon withBagMedicine:(BagMedicine *)anonymousEntity];
    else if (self.targetType & kBagQueryTargetTypeMedicinePP) {
      NSInteger selectedMoveIndex = 0;
      id selectedMove = [notification.userInfo objectForKey:@"selectedMoveIndex"];
      if (selectedMove)
        selectedMoveIndex = [selectedMove intValue];
      [self _restorePPForPokemon:targetPokemon
                      moveIndex:selectedMoveIndex
                withBagMedicine:(BagMedicine *)anonymousEntity];
    } else return;
  }
  else if (self.targetType & kBagQueryTargetTypeTMHM)         {}
  else if (self.targetType & kBagQueryTargetTypeBerry)
    [self _useBerryForPokemon:targetPokemon withBagBerry:(BagBerry *)anonymousEntity];
  else if (self.targetType & kBagQueryTargetTypeMail)         {}
  else if (self.targetType & kBagQueryTargetTypeBattleItem)
    [self _useBattleItemForPokemon:targetPokemon withBagBattleItem:(BagBattleItem *)anonymousEntity];
  else if (self.targetType & kBagQueryTargetTypeKeyItem)      {}
  else { anonymousEntity = nil; return; }
  
  // Update data for Bag
  [self _cancelHiddenCellWithCompletionBlock:^(BOOL finished) {
    [self.trainer useBagItemForType:self.targetType withItemIndex:self.selectedCellIndex];
    // Cancel self view after Use Bag Item done, post to |GameMenuBagViewController|
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUseBagItemDone object:self userInfo:nil];
    [self setBagItem:self.targetType];
    [self.tableView reloadData];
  }];
}

// Name header for current |targetType_|
- (NSString *)_localizedNameHeader
{
  NSString * localizedNameHeader;
  if      (targetType_ & kBagQueryTargetTypeItem)       localizedNameHeader = @"PMSBagItem";
  else if (targetType_ & kBagQueryTargetTypeMedicine)   localizedNameHeader = @"PMSBagMedicine";
  else if (targetType_ & kBagQueryTargetTypePokeball)   localizedNameHeader = @"PMSBagPokeball";
  else if (targetType_ & kBagQueryTargetTypeTMHM)       localizedNameHeader = @"PMSBagTMHM";
  else if (targetType_ & kBagQueryTargetTypeBerry)      localizedNameHeader = @"PMSBagBerry";
  else if (targetType_ & kBagQueryTargetTypeMail)       localizedNameHeader = @"PMSBagMail";
  else if (targetType_ & kBagQueryTargetTypeBattleItem) localizedNameHeader = @"PMSBagBattleItem";
  else if (targetType_ & kBagQueryTargetTypeKeyItem)    localizedNameHeader = @"PMSBagKeyItem";
  else return nil;
  return localizedNameHeader;
}

#pragma mark - BagItemTableViewHiddenCell Delegate

// Hidden Cell Button Action: Use Item
- (void)useItem:(id)sender
{
  // Throw pokeball to catch wild Pokemon
  // Directly use, no need to select Pokemon
  if (self.targetType & kBagQueryTargetTypePokeball) {
    [self _cancelHiddenCellWithCompletionBlock:^(BOOL finished) {
      // Update data for Bag
      [self.trainer useBagItemForType:self.targetType withItemIndex:self.selectedCellIndex];
      // Cancel self view after Use Bag Item done, post to |GameMenuBagViewController|
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNUseBagItemDone object:self userInfo:nil];
      [self setBagItem:self.targetType];
      [self.tableView reloadData];
      
      // Post notification to |GameMenuViewController| to run Throwing Pokeball animation
      [[NSNotificationCenter defaultCenter] postNotificationName:kPMNCatchWildPokemon object:self userInfo:nil];
    }];
  }
  // Only open |gameMenuSixPokemonsViewController|'s view when the item is used for Pokemon
  // (e.g. HP, PP restore, etc)
  // Not directly.
  // |self| => |GameMenuSixPokemonsViewController| to choose Pokemon
  //        => notification back to |self| - |_useItemForSelectedPokemon:|
  else {
    if (self.gameMenuSixPokemonsViewController == nil) {
      GameMenuSixPokemonsViewController * gameMenuSixPokemonViewController;
      gameMenuSixPokemonViewController = [[GameMenuSixPokemonsViewController alloc] init];
      self.gameMenuSixPokemonsViewController = gameMenuSixPokemonViewController;
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
  }
  
  [[[[UIApplication sharedApplication] delegate] window] addSubview:self.bagItemInfoViewController.view];
  NSInteger itemID = [[self.items objectAtIndex:(self.selectedCellIndex * 2)] intValue];
  id anonymousEntity = [[BagDataController sharedInstance] queryDataFor:self.targetType
                                                                 withID:itemID];
  NSInteger entityID;
  NSInteger price;
  if (targetType_ & kBagQueryTargetTypeItem) {
    BagItem * entity    = anonymousEntity;
    entityID            = [entity.sid intValue];
    price               = [entity.price intValue];
    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeMedicine) {
    BagMedicine * entity = anonymousEntity;
    entityID             = [entity.sid intValue];
    price                = [entity.price intValue];
    entity               = nil;
  } else if (targetType_ & kBagQueryTargetTypePokeball) {
    BagPokeball * entity = anonymousEntity;
    entityID             = [entity.sid intValue];
    price                = [entity.price intValue];
    entity               = nil;
  } else if (targetType_ & kBagQueryTargetTypeTMHM) {
    BagTMHM * entity    = anonymousEntity;
    entityID            = [entity.sid intValue];
    price               = 0;
    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeBerry) {
    BagBerry * entity   = anonymousEntity;
    entityID            = [entity.sid intValue];
    price               = 0;
    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeMail) {
    BagMail * entity    = anonymousEntity;
    entityID            = [entity.sid intValue];
    price               = 0;
    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeBattleItem) {
    BagBattleItem * entity = anonymousEntity;
    entityID               = [entity.sid intValue];
    price                  = [entity.price intValue];
    entity                 = nil;
  } else if (targetType_ & kBagQueryTargetTypeKeyItem) {
    BagKeyItem * entity = anonymousEntity;
    price               = 0;
    entityID            = [entity.sid intValue];
    entity = nil;
  } else return;
  
  NSString * localizedNameHeader = [self _localizedNameHeader];
  NSString * name =
    KYResourceLocalizedString(([NSString stringWithFormat:@"%@%.3d", localizedNameHeader, entityID]), nil);
  NSString * info =
    KYResourceLocalizedString(([NSString stringWithFormat:@"%@Info%.3d", localizedNameHeader, entityID]), nil);
  
  [self.bagItemInfoViewController setDataWithName:name price:price info:info duringBattle:self.isDuringBattle];
  [self.bagItemInfoViewController loadViewWithAnimation];
}

// Hidden Cell Button Action: Cancel Hidden Cell
- (void)cancelHiddenCell:(id)sender {
  [self _cancelHiddenCellWithCompletionBlock:nil];
}

#pragma mark - Methods for using different items' type

// Heal Status & Restore HP for Pokemon
- (void)_healStatusAndRestoreHPForPokemon:(TrainerTamedPokemon *)pokemon
                         withBagMedicine:(BagMedicine *)bagMedicine
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
- (void)_healStatusForPokemon:(TrainerTamedPokemon *)pokemon
             withBagMedicine:(BagMedicine *)bagMedicine
{
  NSInteger effectCode     = [bagMedicine.code intValue];
  NSInteger pokemonStatus  = [pokemon.status intValue];
  BOOL      healStatusDone = YES;
  
  // 0x80~0x8F: Status Healer & HP Restoree
  if (effectCode & 0x80) [self _healStatusAndRestoreHPForPokemon:pokemon withBagMedicine:bagMedicine];
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
- (void)_restoreHPForPokemon:(TrainerTamedPokemon *)pokemon
            withBagMedicine:(BagMedicine *)bagMedicine
{
  NSInteger effectCode   = [bagMedicine.code intValue];
  NSInteger pokemonHP    = [pokemon.hp intValue];
  NSInteger pokemonHPMax = [[[pokemon.maxStats componentsSeparatedByString:@","] objectAtIndex:0] intValue];
  
  // 0x80~0x8F: Status Healer & HP Restoree
  if (effectCode & 0x80) [self _healStatusAndRestoreHPForPokemon:pokemon withBagMedicine:bagMedicine];
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
  pokemon.hp = [NSNumber numberWithInt:(pokemonHP > pokemonHPMax ? pokemonHPMax : pokemonHP)];
  // SYNC data
  [pokemon syncWithFlag:kDataModifyTamedPokemon | kDataModifyTamedPokemonBasic];
}

// Use 'PP Restore' to restore Pokemon's move PP
- (void)_restorePPForPokemon:(TrainerTamedPokemon *)pokemon
                  moveIndex:(NSInteger)moveIndex
            withBagMedicine:(BagMedicine *)bagMedicine
{
  NSLog(@"selected Move Index: %d", moveIndex);
  // four Moves' PP array (with max value)
  //   currPP,maxPP,currPP,maxPP,...
  NSArray * PPArrayWithMax = [[NSMutableArray alloc] initWithArray:[pokemon fourMovesPPInArray]];
  NSLog(@"PPArrayWithMax:%@", [PPArrayWithMax componentsJoinedByString:@","]);
  NSInteger moveCount  = [PPArrayWithMax count] / 2;
  NSMutableArray * PPArray = [[NSMutableArray alloc] initWithCapacity:moveCount];
  NSInteger effectCode = [bagMedicine.code intValue];
  // 0x1F: 0001 1111
  // Restores all PP to every move of a selected Pokemon
  if (effectCode == 0x1F) {
    NSLog(@"- BagMedicine - PP - EffectCode: 0x1F");
    for (NSInteger i = 0; i < moveCount; ++i)
      [PPArray addObject:[PPArrayWithMax objectAtIndex:(i * 2 + 1)]];
  } 
  // 0x0F: 0000 1111
  // Restores 10 PP to every move of a selected Pokemon
  else if (effectCode == 0x0F) {
    NSLog(@"- BagMedicine - PP - EffectCode: 0x0F");
    for (NSInteger i = 0; i < moveCount; ++i) {
      NSInteger pp = [[PPArrayWithMax objectAtIndex:(i * 2)] intValue] + 10;
      NSInteger maxPP = [[PPArrayWithMax objectAtIndex:(i * 2 + 1)] intValue];
      [PPArray addObject:[NSNumber numberWithInt:(pp < maxPP ? pp : maxPP)]];
    }
  }
  /*
  // 0x07: 0000 0111
  // Restores all PP to one move of a selected Pokemon
  else if (effectCode == 0x07) {
    NSLog(@"- BagMedicine - PP - EffectCode: 0x07");
    if (! moveIndex) moveIndex = 1;
//    [PPArrayWithMax replaceObjectAtIndex:(moveIndex * 2)
//                              withObject:[PPArrayWithMax objectAtIndex:(moveIndex * 2 + 1)]];
  }
  // 0x01: 0000 0001
  // Restores 10 PP to one Pokemon's selected move
  else if (effectCode & 0x01) {
    NSLog(@"- BagMedicine - PP - EffectCode: 0x01");
    if (! moveIndex) moveIndex = 1;
//    NSInteger pp = [[PPArrayWithMax objectAtIndex:(moveIndex * 2)] intValue] + 10;
//    NSInteger maxPP = [[PPArrayWithMax objectAtIndex:(moveIndex * 2 + 1)] intValue];
//    [PPArrayWithMax replaceObjectAtIndex:(moveIndex * 2)
//                              withObject:[NSNumber numberWithInt:(pp < maxPP ? pp : maxPP)]];
  }*/
  else {
    return;
  }
  NSLog(@"PPArray:%@", [PPArray componentsJoinedByString:@","]);
  // update moves' PP & save
  [pokemon updateFourMovesWithPPArray:PPArray];
  [pokemon syncWithFlag:kDataModifyTamedPokemon | kDataModifyTamedPokemonBasic];
}

// Use 'Berry' for Pokemon
- (void)_useBerryForPokemon:(TrainerTamedPokemon *)pokemon
              withBagBerry:(BagBerry *)bagBerry
{
}

// Use 'Battle Item' for Pokemon
- (void)_useBattleItemForPokemon:(TrainerTamedPokemon *)pokemon
              withBagBattleItem:(BagBattleItem *)bagBattleItem
{
}

@end
