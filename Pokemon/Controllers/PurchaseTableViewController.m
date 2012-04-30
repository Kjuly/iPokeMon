//
//  PurchaseTableViewController.m
//  iPokemon
//
//  Created by Kaijie Yu on 4/30/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PurchaseTableViewController.h"

#import "Reachability.h"
#import "LoadingManager.h"
#import "PMPurchaseManager.h"


@interface PurchaseTableViewController () {
 @private
  LoadingManager    * loadingManager_;
  PMPurchaseManager * purchaseManager_;
}

@property (nonatomic, retain) LoadingManager    * loadingManager;
@property (nonatomic, retain) PMPurchaseManager * purchaseManager;

- (void)timeOut:(id)sender;
- (void)productsLoaded:(NSNotification *)notification;
- (void)productPurchased:(NSNotification *)notification;
- (void)productPurchaseFailed:(NSNotification *)notification;
- (void)buyButtonTapped:(id)sender;

@end

@implementation PurchaseTableViewController

@synthesize loadingManager  = loadingManager_;
@synthesize purchaseManager = purchaseManager_;

- (void)dealloc {
  self.loadingManager  = nil;
  self.purchaseManager = nil;
  // remove notification observers
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNProductsLoadedNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNProductPurchasedNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNProductPurchaseFailedNotification object:nil];
  [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
    [self setTitle:NSLocalizedString(@"PMSStoreCurrencyTransactions", nil)];
    self.loadingManager  = [LoadingManager sharedInstance];
    self.purchaseManager = [PMPurchaseManager sharedInstance];
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

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(productsLoaded:)
                                               name:kPMNProductsLoadedNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(productPurchased:)
                                               name:kPMNProductPurchasedNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(productPurchaseFailed:)
                                               name:kPMNProductPurchaseFailedNotification
                                             object:nil];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  Reachability *reach = [Reachability reachabilityForInternetConnection];	
  NetworkStatus netStatus = [reach currentReachabilityStatus];    
  if (netStatus == NotReachable) {        
    NSLog(@"No internet connection!");        
  } else {        
    if (self.purchaseManager.products == nil) {
      [self.purchaseManager requestProducts];
      // Loaidng start
      [self.loadingManager showOverView];
      [self performSelector:@selector(timeout) withObject:nil afterDelay:30.0];
    }        
  }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.purchaseManager.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
    
  // Configure the cell...
  SKProduct * product = [self.purchaseManager.products objectAtIndex:indexPath.row];
  
  NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
  [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  [numberFormatter setLocale:product.priceLocale];
  NSString * formattedString = [numberFormatter stringFromNumber:product.price];
  [numberFormatter release];
  
  cell.textLabel.text = product.localizedTitle;
  cell.detailTextLabel.text = formattedString;
  
  UIButton * buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  buyButton.frame = CGRectMake(0.f, 0.f, 72.f, 37.f);
  [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
  buyButton.tag = indexPath.row;
  [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
  cell.accessoryType = UITableViewCellAccessoryNone;
  cell.accessoryView = buyButton;
  
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - Private Methods

- (void)timeOut:(id)sender {
  NSLog(@"!!!ERROR: TIMEOUT");
  [self.loadingManager hideOverView];
}

- (void)productsLoaded:(NSNotification *)notification {
  NSLog(@"Products Loaded");
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  // loading done
  [self.loadingManager hideOverView];
  [self.tableView reloadData];
}

- (void)productPurchased:(NSNotification *)notification {
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  // loading done
  [self.loadingManager hideOverView];
  
  NSString * productIdentifier = (NSString *)notification.object;
  NSLog(@"Purchased: %@", productIdentifier);
  
  [self.tableView reloadData];
}

- (void)productPurchaseFailed:(NSNotification *)notification {
  [NSObject cancelPreviousPerformRequestsWithTarget:self];
  // loading done
  [self.loadingManager hideOverView];
  
  SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
  if (transaction.error.code != SKErrorPaymentCancelled) {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!"
                                                     message:transaction.error.localizedDescription 
                                                    delegate:nil 
                                           cancelButtonTitle:nil 
                                           otherButtonTitles:@"OK", nil] autorelease];
    [alert show];
  }
}

- (void)buyButtonTapped:(id)sender {
  UIButton * buyButton = (UIButton *)sender;
  SKProduct * product = [self.purchaseManager.products objectAtIndex:buyButton.tag];
  
  NSLog(@"Buying %@...", product.productIdentifier);
  [self.purchaseManager buyProductIdentifier:product.productIdentifier];
  
  // loading
  [self.loadingManager showOverView];
  [self performSelector:@selector(timeout) withObject:nil afterDelay:60*5];
}

@end
