//
//  PurchaseTableViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 4/30/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PurchaseTableViewController.h"

//#import "Reachability.h"
#import "LoadingManager.h"
#import "PMPurchaseManager.h"
#import "CustomNavigationBar.h"
#import "PurchaseTableViewCell.h"
#import "TrainerController.h"


@interface PurchaseTableViewController () {
 @private
  LoadingManager    * loadingManager_;
  PMPurchaseManager * purchaseManager_;
  
  NSInteger selectedRowIndex_;
}

@property (nonatomic, strong) LoadingManager    * loadingManager;
@property (nonatomic, strong) PMPurchaseManager * purchaseManager;

- (void)_setupNotificationObservers;
- (void)_timeOut:(id)sender;
- (void)_productsLoaded:(NSNotification *)notification;
- (void)_productPurchased:(NSNotification *)notification;
- (void)_productPurchaseFailed:(NSNotification *)notification;
- (void)_exchangeCurrency:(id)sender;

@end

@implementation PurchaseTableViewController

@synthesize loadingManager  = loadingManager_;
@synthesize purchaseManager = purchaseManager_;

- (void)dealloc
{
  // remove notification observers
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewStyle)style
{
  if (self = [super initWithStyle:style]) {
    // Custom initialization
    [self setTitle:NSLocalizedString(@"PMSStoreCurrencyExchange", nil)];
    self.loadingManager  = [LoadingManager sharedInstance];
    self.purchaseManager = [PMPurchaseManager sharedInstance];
    selectedRowIndex_    = -1;
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
  [self.tableView setAlpha:0.f];
  [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  
  // Setup notification observers
  [self _setupNotificationObservers];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if (self.purchaseManager.products == nil) {
    [self.purchaseManager requestProducts];
    // Loaidng start
    [self.loadingManager showOverView];
    [self performSelector:@selector(_timeOut:) withObject:nil afterDelay:15.f];
  }
  else [self.tableView setAlpha:1.f];
  
  /*
  Reachability *reach = [Reachability reachabilityForInternetConnection];	
  NetworkStatus netStatus = [reach currentReachabilityStatus];    
  if (netStatus == NotReachable) {
    NSLog(@"No internet connection!");
  }
  else {
    if (self.purchaseManager.products == nil) {
      [self.purchaseManager requestProducts];
      // Loaidng start
      [self.loadingManager showOverView];
      [self performSelector:@selector(_timeOut:) withObject:nil afterDelay:5.f];
    }
  }*/
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
    return [self.purchaseManager.products count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kCellHeightOfCurrencyExchange;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  PurchaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[PurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                         reuseIdentifier:CellIdentifier];
  }
    
  // Configure the cell...
  NSInteger row = indexPath.row;
  SKProduct * product = [self.purchaseManager.products objectAtIndex:row];
  
  NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
  [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  [numberFormatter setLocale:product.priceLocale];
  [cell configureCellWithTitle:product.localizedTitle
                         price:[numberFormatter stringFromNumber:product.price]
                          icon:[UIImage imageNamed:[NSString stringWithFormat:kPMINIconCurrencyExchangeIcon, row + 1]]
                           odd:(row % 2 == 0 ? YES : NO)];
  [cell.exchangeButton setTag:row];
  [cell.exchangeButton addTarget:self
                          action:@selector(_exchangeCurrency:)
                forControlEvents:UIControlEventTouchUpInside];
  product = nil;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

#pragma mark - Private Methods

// Setup notification observer
- (void)_setupNotificationObservers
{
  NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self
                         selector:@selector(_productsLoaded:)
                             name:kPMNProductsLoadedNotification
                           object:nil];
  [notificationCenter addObserver:self
                         selector:@selector(_productPurchased:)
                             name:kPMNProductPurchasedNotification
                           object:nil];
  [notificationCenter addObserver:self
                         selector:@selector(_productPurchaseFailed:)
                             name:kPMNProductPurchaseFailedNotification
                           object:nil];
}

- (void)_timeOut:(id)sender
{
  NSLog(@"!!!ERROR: TIMEOUT");
  [self.loadingManager hideOverView];
  CGFloat delay = 1.5f;
  [[LoadingManager sharedInstance] showMessage:NSLocalizedString(@"ErrorLoadingTimeOut", nil)
                                          type:kProgressMessageTypeError
                                  withDuration:delay];
  CustomNavigationBar * navigationBar = (CustomNavigationBar *)self.navigationController.navigationBar;
  [navigationBar performSelector:@selector(back:) withObject:nil afterDelay:delay];
  navigationBar = nil;
}

- (void)_productsLoaded:(NSNotification *)notification
{
  NSLog(@"Products Loaded");
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  // loading done
  [self.loadingManager hideOverView];
  [self.tableView reloadData];
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveLinear
                   animations:^{ [self.tableView setAlpha:1.f]; }
                   completion:nil];
}

- (void)_productPurchased:(NSNotification *)notification
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  // loading done
  [self.loadingManager hideOverView];
  NSString * productIdentifier = (NSString *)notification.object;
  NSLog(@"Purchased: %@", productIdentifier);
  
  // earn money for purchased product
  SKProduct * product = [self.purchaseManager.products objectAtIndex:selectedRowIndex_];
  [[TrainerController sharedInstance] earnMoney:[product.localizedTitle intValue]];
  product = nil;
  
  // show message over view
  [self.loadingManager showMessage:NSLocalizedString(@"Exchange Done", nil)
                              type:kProgressMessageTypeSucceed
                      withDuration:1.f];
}

- (void)_productPurchaseFailed:(NSNotification *)notification
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  // loading done
  [self.loadingManager hideOverView];
  
  SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
  if (transaction.error.code != SKErrorPaymentCancelled) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                     message:transaction.error.localizedDescription 
                                                    delegate:nil 
                                           cancelButtonTitle:nil 
                                           otherButtonTitles:@"OK", nil];
    [alert show];
    // show message to warn user the Exchange Failed
//    [self.loadingManager showMessage:NSLocalizedString(@"Exchange Failed", nil)
//                                type:kProgressMessageTypeError
//                        withDuration:1.f];
  }
}

// Button Action: exchange the currency
- (void)_exchangeCurrency:(id)sender
{
  selectedRowIndex_ = ((UIButton *)sender).tag;
  SKProduct * product = [self.purchaseManager.products objectAtIndex:selectedRowIndex_];
  NSLog(@"Buying %@...", product);
  [self.purchaseManager buyProduct:product];
  // loading
  [self.loadingManager showOverView];
  [self performSelector:@selector(_timeOut:) withObject:nil afterDelay:60*5];
  product = nil;
}

@end
