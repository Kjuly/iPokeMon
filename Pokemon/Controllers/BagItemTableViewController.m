//
//  BagItemTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemTableViewController.h"

#import "AppDelegate.h"
#import "PListParser.h"
#import "TrainerCoreDataController.h"
#import "BagItemTableViewCell.h"
#import "BagItemInfoViewController.h"

#import <QuartzCore/QuartzCore.h>


@interface BagItemTableViewController () {
 @private
  NSInteger                    selectedCellIndex_; // For query data
  BagItemTableViewCell       * selectedCell_;
  BagItemTableViewHiddenCell * hiddenCell_;
  UIView                     * hiddenCellAreaView_;
  BagItemInfoViewController  * bagItemInfoViewController_;
}

@property (nonatomic, assign) NSInteger                    selectedCellIndex;
@property (nonatomic, retain) BagItemTableViewCell       * selectedCell;
@property (nonatomic, retain) BagItemTableViewHiddenCell * hiddenCell;
@property (nonatomic, retain) UIView                     * hiddenCellAreaView;
@property (nonatomic, retain) BagItemInfoViewController  * bagItemInfoViewController;

- (void)configureCell:(BagItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)showHiddenCellToReplaceCell:(BagItemTableViewCell *)cell;
- (void)cancelHiddenCellWithCompletionBlock:(void (^)(BOOL finished))completion;

@end


@implementation BagItemTableViewController

@synthesize items              = items_;
@synthesize itemNumberSequence = itemNumberSequence;
@synthesize targetType         = targetType_;
@synthesize isDuringBattle     = isDuringBattle_;

@synthesize selectedCellIndex         = selectedCellIndex_;
@synthesize selectedCell              = selectedCell_;
@synthesize hiddenCell                = hiddenCell_;
@synthesize hiddenCellAreaView        = hiddenCellAreaView_;
@synthesize bagItemInfoViewController = bagItemInfoViewController_;

-(void)dealloc
{
  [items_ release];
  
  self.selectedCell = nil;
  self.hiddenCell   = nil;
  [hiddenCellAreaView_        release];
  [bagItemInfoViewController_ release];
  
  [super dealloc];
}

- (id)initWithBagItem:(BagQueryTargetType)targetType
{
  self = [self initWithStyle:UITableViewStylePlain];
  if (self) [self setBagItem:targetType];
  return self;
}

- (void)setBagItem:(BagQueryTargetType)targetType {
  self.items = [[[TrainerCoreDataController sharedInstance] bagItemsFor:targetType] mutableCopy];
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
  // Implement thme!
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
    selectedCellIndex_ = 0;
    targetType_        = 0;
    isDuringBattle_    = NO;
    
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
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.items = nil;
  self.selectedCell              = nil;
  self.hiddenCell                = nil;
  self.hiddenCellAreaView        = nil;
  self.bagItemInfoViewController = nil;
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
  NSInteger row = [indexPath row];
//  id anonymousEntity = [self.items objectAtIndex:[indexPath row]];
  NSString * localizedNameHeader;
  NSInteger entityID = [[self.items objectAtIndex:(row * 2)] intValue];
  NSInteger entityQuantity = [[self.items objectAtIndex:(row * 2 + 1)] intValue];
//  NSInteger  entityID;
  if (targetType_ & kBagQueryTargetTypeItem) {
//    BagItem * entity    = anonymousEntity;
    localizedNameHeader = @"PMSBagItem";
//    entityID            = [entity.sid intValue];
//    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeMedicine) {
//    BagMedicine * entity = anonymousEntity;
    localizedNameHeader  = @"PMSBagMedicine";
//    entityID             = [entity.sid intValue];
//    entity               = nil;
  } else if (targetType_ & kBagQueryTargetTypePokeball) {
//    BagPokeball * entity = anonymousEntity;
    localizedNameHeader  = @"PMSBagPokeball";
//    entityID             = [entity.sid intValue];
//    entity               = nil;
  } else if (targetType_ & kBagQueryTargetTypeTMHM) {
//    BagTMHM * entity    = anonymousEntity;
    localizedNameHeader = @"PMSBagTMHM";
//    entityID            = [entity.sid intValue];
//    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeBerry) {
//    BagBerry * entity   = anonymousEntity;
    localizedNameHeader = @"PMSBagBerry";
//    entityID            = [entity.sid intValue];
//    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeMail) {
//    BagMail * entity    = anonymousEntity;
    localizedNameHeader = @"PMSBagMail";
//    entityID            = [entity.sid intValue];
//    entity              = nil;
  } else if (targetType_ & kBagQueryTargetTypeBattleItem) {
//    BagBattleItem * entity = anonymousEntity;
    localizedNameHeader    = @"PMSBagBattleItem";
//    entityID               = [entity.sid intValue];
//    entity                 = nil;
  } else if (targetType_ & kBagQueryTargetTypeKeyItem) {
//    BagKeyItem * entity = anonymousEntity;
    localizedNameHeader = @"PMSBagKeyItem";
//    entityID            = [entity.sid intValue];
//    entity = nil;
  } else return;
  
  // Set the data for cell to display
  [cell.name setText:NSLocalizedString(([NSString stringWithFormat:@"%@%.3d",
                                         localizedNameHeader, entityID]), nil)];
  [cell.quantity setText:[NSString stringWithFormat:@"%d", entityQuantity]];
//  anonymousEntity     = nil;
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

#pragma mark - BagItemTableViewHiddenCell Delegate

- (void)useItem:(id)sender
{
  NSInteger itemID = [[self.items objectAtIndex:self.selectedCellIndex] intValue];
  id entity = [[BagDataController sharedInstance] queryDataFor:self.targetType
                                                        withID:itemID];
  
  if (self.targetType & kBagQueryTargetTypeItem)
    return;
  else if (self.targetType & kBagQueryTargetTypeMedicine) {
    if (self.targetType & kBagQueryTargetTypeMedicineStatus)  {}
    else if (self.targetType & kBagQueryTargetTypeMedicineHP) {}
    else if (self.targetType & kBagQueryTargetTypeMedicinePP) {}
    else return;
  }
  else if (self.targetType & kBagQueryTargetTypePokeball) {
  }
  else if (self.targetType & kBagQueryTargetTypeTMHM)
    return;
  else if (self.targetType & kBagQueryTargetTypeBerry)
    return;
  else if (self.targetType & kBagQueryTargetTypeMail)
    return;
  else if (self.targetType & kBagQueryTargetTypeBattleItem)
    return;
  else if (self.targetType & kBagQueryTargetTypeKeyItem)
    return;
  else {
    entity = nil;
    return;
  }
}

- (void)giveItem:(id)sender
{
}

- (void)tossItem:(id)sender
{
}

- (void)showInfo:(id)sender
{
  if (self.bagItemInfoViewController == nil) {
    BagItemInfoViewController * bagItemInfoViewController = [[BagItemInfoViewController alloc] init];
    self.bagItemInfoViewController = bagItemInfoViewController;
    [bagItemInfoViewController release];
  }
  
  [[[[UIApplication sharedApplication] delegate] window] addSubview:self.bagItemInfoViewController.view];
  NSInteger itemID = [[self.items objectAtIndex:self.selectedCellIndex] intValue];
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

- (void)cancelHiddenCell:(id)sender {
  [self cancelHiddenCellWithCompletionBlock:nil];
}

@end
