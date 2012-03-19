//
//  BagItemTableViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemTableViewController.h"

#import "PListParser.h"
#import "TrainerCoreDataController.h"
#import "BagItemTableViewCell.h"

#import <QuartzCore/QuartzCore.h>


@interface BagItemTableViewController () {
 @private
  BagItemTableViewCell       * selectedCell_;
  BagItemTableViewHiddenCell * hiddenCell_;
}

@property (nonatomic, retain) BagItemTableViewCell       * selectedCell;
@property (nonatomic, retain) BagItemTableViewHiddenCell * hiddenCell;

- (void)configureCell:(BagItemTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)showHiddenCellToReplaceCell:(BagItemTableViewCell *)cell;
- (void)cancelHiddenCellWithCompletionBlock:(void (^)(BOOL finished))completion;

@end


@implementation BagItemTableViewController

@synthesize items              = items_;
@synthesize itemNumberSequence = itemNumberSequence;
@synthesize targetType         = targetType_;

@synthesize selectedCell = selectedCell_;
@synthesize hiddenCell   = hiddenCell_;

-(void)dealloc
{
  [items_ release];
  
  self.selectedCell = nil;
  self.hiddenCell   = nil;
  
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
  [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewBackgroundBlack.png"]]];
    
    // Basic setting
    targetType_ = 0;
    
    // Hidden Cell
    hiddenCell_ = [[BagItemTableViewHiddenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hiddenCell"];
    [self.hiddenCell setFrame:CGRectMake(kViewWidth, 0.f, kViewWidth, 45.f)];
    self.hiddenCell.delegate = self;
    [self.tableView addSubview:self.hiddenCell];
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
    cell = [[[BagItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  // Configure the cell...
//  id entity = [self.items objectAtIndex:[indexPath row]];
  [self configureCell:cell atIndexPath:indexPath];
  
//  [cell.labelTitle setText:[entity.sid stringValue]];
//  [cell.imageView setImage:];
//  entity = nil;
  
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
  NSLog(@"!!!!!!!!");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
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
    [self.hiddenCell setFrame:cellFrame];
    [UIView animateWithDuration:.2f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       cellFrame.origin.x = 0.f;
                       [self.hiddenCell setFrame:cellFrame];
                       cellFrame.origin.x = -kViewWidth;
                       [cell setFrame:cellFrame];
                     }
                     completion:nil];
    self.selectedCell = cell;
  };
  
  if (self.selectedCell == nil) showHiddenCellAnimationBlock(YES);
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
                     [self.hiddenCell setFrame:cellFrame];
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
  
}

- (void)giveItem:(id)sender
{
  
}

- (void)tossItem:(id)sender
{
  
}

- (void)cancelHiddenCell:(id)sender {
  [self cancelHiddenCellWithCompletionBlock:nil];
}

@end
