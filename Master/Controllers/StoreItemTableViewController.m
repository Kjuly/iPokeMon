//
//  BagItemTableViewController.m
//  iPokeMon
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
  NSArray * items_;
  
  UIView                            * hiddenCellAreaView_;
  StoreItemTableViewCell            * selectedCell_;
  BagItemTableViewHiddenCell        * hiddenCell_;
  PMAudioPlayer                     * audioPlayer_;
  TrainerController                 * trainer_;
  BagDataController                 * bagDataController_;
  BagItemInfoViewController         * bagItemInfoViewController_;
  StoreItemQuantityChangeViewController * storeItemQuantityChangeViewController_;
  
  BagQueryTargetType targetType_;
  NSInteger          selectedCellIndex_; // For querying data
  NSInteger          selectedPokemonIndex_;
  NSInteger          quantity_;
}

@property (nonatomic, copy)   NSArray * items;

@property (nonatomic, strong) UIView                     * hiddenCellAreaView;
@property (nonatomic, strong) StoreItemTableViewCell     * selectedCell;
@property (nonatomic, strong) BagItemTableViewHiddenCell * hiddenCell;
@property (nonatomic, strong) PMAudioPlayer              * audioPlayer;
@property (nonatomic, strong) TrainerController          * trainer;
@property (nonatomic, strong) BagDataController          * bagDataController;
@property (nonatomic, strong) BagItemInfoViewController  * bagItemInfoViewController;
@property (nonatomic, strong) StoreItemQuantityChangeViewController * storeItemQuantityChangeViewController;

- (void)_configureCell:(StoreItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)_showHiddenCellToReplaceCell:(StoreItemTableViewCell *)cell;
- (void)_cancelHiddenCellWithCompletionBlock:(void (^)(BOOL finished))completion;
- (NSString *)_localizedNameHeader;
- (void)_updateSelectedItemQuantity:(NSNotification *)notification;

@end


@implementation StoreItemTableViewController

@synthesize items = items_;

@synthesize hiddenCellAreaView        = hiddenCellAreaView_;
@synthesize selectedCell              = selectedCell_;
@synthesize hiddenCell                = hiddenCell_;
@synthesize audioPlayer               = audioPlayer_;
@synthesize trainer                   = trainer_;
@synthesize bagDataController         = bagDataController_;
@synthesize bagItemInfoViewController = bagItemInfoViewController_;
@synthesize storeItemQuantityChangeViewController = storeItemQuantityChangeViewController_;

-(void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:kPMNUpdateStoreItemQuantity
                                                object:nil];
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
  targetType_ = targetType;
  NSString * itemIDsInString;
  // TODO:
  //   Hard code now. need to fetch from web server
  if (targetType & kBagQueryTargetTypeItem) {
    itemIDsInString = nil;
  }
  else if (targetType & kBagQueryTargetTypeMedicine) {
    if (targetType & kBagQueryTargetTypeMedicineStatus)
      itemIDsInString = nil;
    else if (targetType & kBagQueryTargetTypeMedicineHP)
      itemIDsInString = @"23,6,20,12,18,25";
    else if (targetType & kBagQueryTargetTypeMedicinePP)
      itemIDsInString = nil;
//      itemIDsInString = @"4,16";
    else itemIDsInString = nil;
  }
  else if (targetType & kBagQueryTargetTypePokeball) {
    itemIDsInString = @"11";
  }
  else itemIDsInString = nil;
  self.items = [self.bagDataController queryDataFor:targetType withIDsInString:itemIDsInString];
  
  if ([self.items count] < 1)
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundEmpty]]];
  else
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
  [self.tableView reloadData];
  
  // hide |give| & |toss| button
  [self.hiddenCell.give setHidden:YES];
  [self.hiddenCell.toss setHidden:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  if (self = [super initWithStyle:style]) {
    // Basic setting
    selectedCellIndex_     = 0;
    targetType_            = 0;
    selectedPokemonIndex_  = 0;
    quantity_              = 1;
    self.audioPlayer       = [PMAudioPlayer sharedInstance];
    self.trainer           = [TrainerController sharedInstance];
    self.bagDataController = [BagDataController sharedInstance];
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
  
  // Cell Area View
  CGRect hiddenCellAreaViewFrame = CGRectMake(kViewWidth, 0.f, kViewWidth, kCellHeightOfBagItemTableView);
  hiddenCellAreaView_ = [[UIView alloc] initWithFrame:hiddenCellAreaViewFrame];
  [self.view addSubview:hiddenCellAreaView_];
  
  // Hidden Cell
  hiddenCell_ = [BagItemTableViewHiddenCell alloc];
  (void)[hiddenCell_ initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hiddenCell"];
  [hiddenCell_ setFrame:CGRectMake(0.f, 0.f, kViewWidth, kCellHeightOfBagItemTableView)];
  hiddenCell_.delegate = self;
  [hiddenCell_ addQuantity:1 withOffsetX:64.f];
  [self.hiddenCellAreaView addSubview:hiddenCell_];
  
  // add observer for notification from |StoreItemQuantityChangeViewController| when quantity changed
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_updateSelectedItemQuantity:)
                                               name:kPMNUpdateStoreItemQuantity
                                             object:nil];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.hiddenCellAreaView = nil;
  self.selectedCell       = nil;
  self.hiddenCell         = nil;
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
  return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString * cellIdentifier = @"Cell";
  StoreItemTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    cell = [[StoreItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
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
  StoreItemTableViewCell * cell =
    (StoreItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
  [self _showHiddenCellToReplaceCell:cell];
  selectedCellIndex_ = [indexPath row];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if (self.selectedCell != nil) [self _cancelHiddenCellWithCompletionBlock:nil];
}

#pragma mark - Private Methods

// configure cell
- (void)_configureCell:(StoreItemTableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
  NSString * localizedNameHeader = [self _localizedNameHeader];
  if (localizedNameHeader == nil)
    return;
  id item = [self.items objectAtIndex:indexPath.row];
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
  [cell configureCellWithTitle:KYResourceLocalizedString(([NSString stringWithFormat:@"%@%.3d", localizedNameHeader, itemID]), nil)
                         price:price
                          icon:nil];
  localizedNameHeader = nil;
}

// Show |hiddenCell_|
- (void)_showHiddenCellToReplaceCell:(StoreItemTableViewCell *)cell
{
  // reset item quantity
  quantity_ = 1;
  [self.hiddenCell updateQuantity:quantity_];
  
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

// update selected item quantity
- (void)_updateSelectedItemQuantity:(NSNotification *)notification
{
  quantity_ = [notification.object intValue];
  [self.hiddenCell updateQuantity:quantity_];
}

#pragma mark - BagItemTableViewHiddenCell Delegate

// Hidden Cell Button Action: Use Item | acturally, just buy this item
- (void)useItem:(id)sender
{
  if (quantity_ <= 0)
    return;
  
  id item = [self.items objectAtIndex:selectedCellIndex_];
  NSInteger SID;
  NSInteger price;
  if (targetType_ & kBagQueryTargetTypeItem) {
    BagItem * bagItem = (BagItem *)item;
    SID     = [bagItem.sid intValue];
    price   = [bagItem.price intValue];
    bagItem = nil;
  }
  else if (targetType_ & kBagQueryTargetTypeMedicine) {
    BagMedicine * bagMedicine = (BagMedicine *)item;
    SID         = [bagMedicine.sid intValue];
    price       = [bagMedicine.price intValue];
    bagMedicine = nil;
  }
  else if (targetType_ & kBagQueryTargetTypePokeball) {
    BagPokeball * bagPokeball = (BagPokeball *)item;
    SID         = [bagPokeball.sid intValue];
    price       = [bagPokeball.price intValue];
    bagPokeball = nil;
  }
  else {
    SID    = 0;
    price  = 0;
  }
  
  // if money is not enough, show warning
  if (price * quantity_ > [self.trainer money]) {
    [[LoadingManager sharedInstance] showMessage:NSLocalizedString(@"Cash Shortage", nil)
                                            type:kProgressMessageTypeWarn
                                    withDuration:1.f];
    return;
  }
  
  // consume money for bought items
  if (price > 0)
    [self.trainer consumeMoney:(price * quantity_)];
  // add new bought item to bag
  [self.trainer addBagItemsForType:targetType_
                       withItemSID:SID
                          quantity:quantity_];
  
  // cancel hidden cell & show message that purchase succeed
  [self cancelHiddenCell:nil];
  [[LoadingManager sharedInstance] showMessage:nil
                                          type:kProgressMessageTypeSucceed
                                  withDuration:1.f];
}

// Hidden Cell Button Action: Show Info
- (void)showInfo:(id)sender
{
  if (self.bagItemInfoViewController == nil) {
    BagItemInfoViewController * bagItemInfoViewController = [[BagItemInfoViewController alloc] init];
    self.bagItemInfoViewController = bagItemInfoViewController;
  }
  [self.view.window addSubview:self.bagItemInfoViewController.view];
  
  id anonymousEntity = [self.items objectAtIndex:selectedCellIndex_];
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
  NSString * name = KYResourceLocalizedString(([NSString stringWithFormat:@"%@%.3d", localizedNameHeader, entityID]), nil);
  NSString * info = KYResourceLocalizedString(([NSString stringWithFormat:@"%@Info%.3d", localizedNameHeader, entityID]), nil);
  
  [self.bagItemInfoViewController setDataWithName:name price:price info:info duringBattle:NO];
  [self.bagItemInfoViewController loadViewWithAnimation];
}

// Hidden Cell Button Action: Cancel Hidden Cell
- (void)cancelHiddenCell:(id)sender
{
  [self _cancelHiddenCellWithCompletionBlock:nil];
}

// Change item quantity
- (void)changeItemQuantity:(id)sender
{
  if (self.storeItemQuantityChangeViewController == nil) {
    StoreItemQuantityChangeViewController * storeItemQuantityChangeViewController;
    storeItemQuantityChangeViewController = [[StoreItemQuantityChangeViewController alloc] init];
    self.storeItemQuantityChangeViewController = storeItemQuantityChangeViewController;
  }
  [self.view.window addSubview:self.storeItemQuantityChangeViewController.view];
  [self.storeItemQuantityChangeViewController loadViewWithItemQuantity:quantity_ animated:YES];
}

@end
