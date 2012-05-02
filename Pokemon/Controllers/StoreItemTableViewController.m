//
//  BagItemTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "StoreItemTableViewController.h"

#import "LoadingManager.h"
#import "PMAudioPlayer.h"
#import "TrainerController.h"
#import "BagDataController.h"
#import "StoreItemTableViewCell.h"
#import "BagItemInfoViewController.h"
#import "StoreItemQuantityChangeViewController.h"


@interface StoreItemTableViewController () {
 @private
  NSArray          * items_;
  BagQueryTargetType targetType_;
  NSInteger          selectedCellIndex_; // For querying data
  NSInteger          selectedPokemonIndex_;
  
  StoreItemTableViewCell            * selectedCell_;
  BagItemTableViewHiddenCell        * hiddenCell_;
  UIView                            * hiddenCellAreaView_;
  PMAudioPlayer                     * audioPlayer_;
  TrainerController                 * trainer_;
  BagDataController                 * bagDataController_;
  BagItemInfoViewController         * bagItemInfoViewController_;
  StoreItemQuantityChangeViewController * storeItemQuantityChangeViewController_;
  
  NSInteger quantity_;
}

@property (nonatomic, copy)   NSArray          * items;
@property (nonatomic, assign) BagQueryTargetType targetType;
@property (nonatomic, assign) NSInteger          selectedCellIndex;
@property (nonatomic, assign) NSInteger          selectedPokemonIndex;

@property (nonatomic, retain) UIView                     * hiddenCellAreaView;
@property (nonatomic, retain) StoreItemTableViewCell     * selectedCell;
@property (nonatomic, retain) BagItemTableViewHiddenCell * hiddenCell;
@property (nonatomic, retain) PMAudioPlayer              * audioPlayer;
@property (nonatomic, retain) TrainerController          * trainer;
@property (nonatomic, retain) BagDataController          * bagDataController;
@property (nonatomic, retain) BagItemInfoViewController  * bagItemInfoViewController;
@property (nonatomic, retain) StoreItemQuantityChangeViewController * storeItemQuantityChangeViewController;

- (void)releaseSubviews;
- (void)configureCell:(StoreItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)showHiddenCellToReplaceCell:(StoreItemTableViewCell *)cell;
- (void)cancelHiddenCellWithCompletionBlock:(void (^)(BOOL finished))completion;
- (NSString *)localizedNameHeader;

@end


@implementation StoreItemTableViewController

@synthesize items                = items_;
@synthesize targetType           = targetType_;
@synthesize selectedCellIndex    = selectedCellIndex_;
@synthesize selectedPokemonIndex = selectedPokemonIndex_;

@synthesize selectedCell              = selectedCell_;
@synthesize hiddenCell                = hiddenCell_;
@synthesize hiddenCellAreaView        = hiddenCellAreaView_;
@synthesize audioPlayer               = audioPlayer_;
@synthesize trainer                   = trainer_;
@synthesize bagDataController         = bagDataController_;
@synthesize bagItemInfoViewController = bagItemInfoViewController_;
@synthesize storeItemQuantityChangeViewController = storeItemQuantityChangeViewController_;

-(void)dealloc {
  self.items                     = nil;
  self.audioPlayer               = nil;
  self.trainer                   = nil;
  self.bagDataController         = nil;
  self.bagItemInfoViewController = nil;
  self.selectedCell              = nil;
  self.storeItemQuantityChangeViewController = nil;
  [self releaseSubviews];
  [super dealloc];
}

- (void)releaseSubviews {
  self.hiddenCell         = nil;
  self.hiddenCellAreaView = nil;
}

- (id)initWithBagItem:(BagQueryTargetType)targetType {
  self = [self initWithStyle:UITableViewStylePlain];
  if (self) {
    [self setBagItem:targetType];
  }
  return self;
}

- (void)setBagItem:(BagQueryTargetType)targetType {
//  self.items = [NSMutableArray arrayWithArray:[self.trainer bagItemsFor:targetType]];
  self.targetType = targetType;
  
  NSString * itemIDsInString;
  // TODO:
  //   Hard code now. need to fetch from web server
  if (targetType & kBagQueryTargetTypeItem) {
    itemIDsInString = @"1,2,3";
  }
  else if (targetType & kBagQueryTargetTypeMedicine) {
    if (targetType & kBagQueryTargetTypeMedicineStatus)
      itemIDsInString = @"1,2,3";
    else if (targetType & kBagQueryTargetTypeMedicineHP)
      itemIDsInString = @"1,2,3";
    else if (targetType & kBagQueryTargetTypeMedicinePP)
      itemIDsInString = @"1,2,3";
    else itemIDsInString = nil;
  }
  else if (targetType & kBagQueryTargetTypePokeball) {
    itemIDsInString = @"1,2,3";
  }
  else itemIDsInString = nil;
  self.items = [self.bagDataController queryDataFor:targetType withIDsInString:itemIDsInString];
  
  if ([self.items count] <= 1)
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundEmpty]]];
  else
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
  [self.tableView reloadData];
  
  // hide |give| & |toss| button
  [self.hiddenCell.give setHidden:YES];
  [self.hiddenCell.toss setHidden:YES];
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Basic setting
    selectedCellIndex_     = 0;
    targetType_            = 0;
    selectedPokemonIndex_  = 0;
    quantity_              = 1;
    self.audioPlayer       = [PMAudioPlayer sharedInstance];
    self.trainer           = [TrainerController sharedInstance];
    self.bagDataController = [BagDataController sharedInstance];
    
    // Cell Area View
    CGRect hiddenCellAreaViewFrame = CGRectMake(kViewWidth, 0.f, kViewWidth, kCellHeightOfBagItemTableView);
    hiddenCellAreaView_ = [[UIView alloc] initWithFrame:hiddenCellAreaViewFrame];
    [self.view addSubview:hiddenCellAreaView_];
    
    // Hidden Cell
    hiddenCell_ = [BagItemTableViewHiddenCell alloc];
    [hiddenCell_ initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hiddenCell"];
    [hiddenCell_ setFrame:CGRectMake(0.f, 0.f, kViewWidth, kCellHeightOfBagItemTableView)];
    hiddenCell_.delegate = self;
    [hiddenCell_ addQuantity:1 withOffsetX:64.f];
    [hiddenCellAreaView_ addSubview:self.hiddenCell];
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self releaseSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
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
  return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  StoreItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[StoreItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  StoreItemTableViewCell * cell = (StoreItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  [self showHiddenCellToReplaceCell:cell];
  self.selectedCellIndex = [indexPath row];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  if (self.selectedCell != nil) [self cancelHiddenCellWithCompletionBlock:nil];
}

#pragma mark - Public Methods

// Reset the view status
- (void)reset {
  if (self.selectedCell != nil) [self cancelHiddenCellWithCompletionBlock:nil];
}

#pragma mark - Private Methods

- (void)configureCell:(StoreItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  NSString * localizedNameHeader = [self localizedNameHeader];
  if (localizedNameHeader == nil) return;
  NSInteger row  = indexPath.row;
  id item = [self.items objectAtIndex:row];
  NSInteger  itemID;
  NSString * price;
  if (targetType_ & kBagQueryTargetTypeItem) {
    BagItem * bagItem = (BagItem *)item;
    itemID = [bagItem.sid   intValue];
    price  = [bagItem.price stringValue];
    bagItem = nil;
  }
  else if (targetType_ & kBagQueryTargetTypeMedicine) {
    BagMedicine * bagMedicine = (BagMedicine *)item;
    itemID = [bagMedicine.sid   intValue];
    price  = [bagMedicine.price stringValue];
    bagMedicine = nil;
  }
  else if (targetType_ & kBagQueryTargetTypePokeball) {
    BagPokeball * bagPokeball = (BagPokeball *)item;
    itemID = [bagPokeball.sid   intValue];
    price  = [bagPokeball.price stringValue];
    bagPokeball = nil;
  }
  else {
    itemID = 0;
    price  = nil;
  }
  // Set the data for cell to display
  [cell configureCellWithTitle:NSLocalizedString(([NSString stringWithFormat:@"%@%.3d", localizedNameHeader, itemID]), nil)
                         price:price
                          icon:nil];
  localizedNameHeader = nil;
}

// Show |hiddenCell_|
- (void)showHiddenCellToReplaceCell:(StoreItemTableViewCell *)cell {
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

// Name header for current |targetType_|
- (NSString *)localizedNameHeader {
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

// Hidden Cell Button Action: Use Item | acturally, just buy this item
- (void)useItem:(id)sender {
  if (quantity_ <= 0)
    return;
  
  id item = [self.items objectAtIndex:selectedCellIndex_];
  NSInteger price;
  if (targetType_ & kBagQueryTargetTypeItem) {
    BagItem * bagItem = (BagItem *)item;
    price  = [bagItem.price intValue];
    bagItem = nil;
  }
  else if (targetType_ & kBagQueryTargetTypeMedicine) {
    BagMedicine * bagMedicine = (BagMedicine *)item;
    price  = [bagMedicine.price intValue];
    bagMedicine = nil;
  }
  else if (targetType_ & kBagQueryTargetTypePokeball) {
    BagPokeball * bagPokeball = (BagPokeball *)item;
    price  = [bagPokeball.price intValue];
    bagPokeball = nil;
  }
  else {
    price  = 0;
  }
  
  // consume money for bought items
  if (price > 0) {
    [self.trainer consumeMoney:(price * quantity_)];
  }
  
  // cancel hidden cell & show message that purchase succeed
  [self cancelHiddenCell:nil];
  [[LoadingManager sharedInstance] showMessage:nil withDuration:1.f];
}

// Hidden Cell Button Action: Show Info
- (void)showInfo:(id)sender {
  if (self.bagItemInfoViewController == nil) {
    BagItemInfoViewController * bagItemInfoViewController = [[BagItemInfoViewController alloc] init];
    self.bagItemInfoViewController = bagItemInfoViewController;
    [bagItemInfoViewController release];
  }
  
  [[[[UIApplication sharedApplication] delegate] window] addSubview:self.bagItemInfoViewController.view];
//  NSInteger itemID = [[self.items objectAtIndex:self.selectedCellIndex] intValue];
//  id anonymousEntity = [[BagDataController sharedInstance] queryDataFor:self.targetType
//                                                                 withID:itemID];
  id anonymousEntity = [self.items objectAtIndex:self.selectedCellIndex];
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
  
  NSString * localizedNameHeader = [self localizedNameHeader];
  NSString * name = NSLocalizedString(([NSString stringWithFormat:@"%@%.3d", localizedNameHeader, entityID]), nil);
  NSString * info = NSLocalizedString(([NSString stringWithFormat:@"%@Info%.3d", localizedNameHeader, entityID]), nil);
  
  [self.bagItemInfoViewController setDataWithName:name price:price info:info duringBattle:NO];
  [self.bagItemInfoViewController loadViewWithAnimation];
}

// Hidden Cell Button Action: Cancel Hidden Cell
- (void)cancelHiddenCell:(id)sender {
  [self cancelHiddenCellWithCompletionBlock:nil];
}

// Change item quantity
- (void)changeItemQuantity:(id)sender {
  if (self.storeItemQuantityChangeViewController == nil) {
    StoreItemQuantityChangeViewController * storeItemQuantityChangeViewController;
    storeItemQuantityChangeViewController = [[StoreItemQuantityChangeViewController alloc] init];
    self.storeItemQuantityChangeViewController = storeItemQuantityChangeViewController;
    [storeItemQuantityChangeViewController release];
  }
  [[[[UIApplication sharedApplication] delegate] window] addSubview:self.storeItemQuantityChangeViewController.view];
  [self.storeItemQuantityChangeViewController loadViewAnimated:YES];
}

@end
