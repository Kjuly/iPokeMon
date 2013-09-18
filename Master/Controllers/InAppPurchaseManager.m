//
//  IAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "InAppPurchaseManager.h"

@interface InAppPurchaseManager ()

- (void)_recordTransaction:(SKPaymentTransaction *)transaction;
- (void)_provideContent:(NSString *)productIdentifier;
- (void)_completeTransaction:(SKPaymentTransaction *)transaction;
- (void)_restoreTransaction:(SKPaymentTransaction *)transaction;
- (void)_failedTransaction:(SKPaymentTransaction *)transaction;

@end


@implementation InAppPurchaseManager

@synthesize productIdentifiers = productIdentifiers_;
@synthesize products           = products_;
@synthesize request            = request_;


#pragma mark - Public Methods

// init
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
  if ((self = [super init])) {
    // Store product identifiers
    productIdentifiers_ = productIdentifiers;
  }
  return self;
}

// request Products from Apple Server
- (void)requestProducts
{
  self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers_];
  request_.delegate = self;
  [request_ start];
}

// When the user selects an item in the store, create a payment object
//   and add it to the payment queue.
// If your store offers the ability to purchase more than one of a product,
//   you can create a single payment and set the quantity property.
- (void)buyProduct:(SKProduct *)product
{
  NSLog(@"Buying %@...", product);
  SKPayment * payment = [SKPayment paymentWithProduct:product];
  // payment.quantity = 3;
  [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKProductsRequestDelegate

// manage the response
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
  NSLog(@"Received products results");
  self.products = response.products;
  self.request = nil;
  // post notification to |PurchaseTableViewController| to populate the UI from the products list
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNProductsLoadedNotification
                                                      object:products_];
}

#pragma mark - SKPaymentTransactionObserver

// It is called whenever new transactions are created or updated
- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
  for (SKPaymentTransaction *transaction in transactions) {
    switch (transaction.transactionState) {
      case SKPaymentTransactionStatePurchased:
        [self _completeTransaction:transaction];
        break;
      case SKPaymentTransactionStateFailed:
        [self _failedTransaction:transaction];
        break;
      case SKPaymentTransactionStateRestored:
        [self _restoreTransaction:transaction];
      default:
        break;
    }
  }
}

#pragma mark - Private Methods

// Record the transaction on the server side
- (void)_recordTransaction:(SKPaymentTransaction *)transaction
{
  // TODO: Record the transaction on the server side...    
}

- (void)_provideContent:(NSString *)productIdentifier
{
  NSLog(@"Toggling flag for: %@", productIdentifier);
  //  [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
  //  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNProductPurchasedNotification
                                                      object:productIdentifier];
}

// Provides the product when the user successfully purchases an item
- (void)_completeTransaction:(SKPaymentTransaction *)transaction
{
  NSLog(@"complete Transaction");
  [self _recordTransaction:transaction];
  [self _provideContent:transaction.payment.productIdentifier];
  // Remove the transaction from the payment queue
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// Finish the transaction for a restored purchase.
// This routine is similar to that for a purchased item.
// A restored purchase provides a new transaction, including a different
//   transaction identifier and receipt. You can save this information
//   separately as part of any audit trail if you desire. However, when
//   it comes time to complete the transaction, you’ll want to recover
//   the original transaction that holds the actual payment object and use
//   its product identifier.
- (void)_restoreTransaction:(SKPaymentTransaction *)transaction
{
  NSLog(@"restore Transaction");
  [self _recordTransaction:transaction];
  [self _provideContent:transaction.originalTransaction.payment.productIdentifier];
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// Finish the transaction for a failed purchase
// Usually a transaction fails because the user decided not to purchase the item.
// Your application can read the error field on a failed transaction to learn
//   exactly why the transaction failed.
// The only requirement for a failed purchase is that your application remove it
//   from the queue. If your application chooses to put up an dialog displaying
//   the error to the user, you should avoid presenting an error when the user
//   cancels a purchase.
- (void)_failedTransaction:(SKPaymentTransaction *)transaction
{
  if (transaction.error.code != SKErrorPaymentCancelled) {
    NSLog(@"!!!Transaction ERROR: %@", transaction.error.localizedDescription);
  }
  // post notification to |PurchaseTableViewController| to warn transaction failed
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNProductPurchaseFailedNotification
                                                      object:transaction];
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

@end
