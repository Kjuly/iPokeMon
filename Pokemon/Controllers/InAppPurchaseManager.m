//
//  IAPHelper.m
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import "InAppPurchaseManager.h"

@implementation InAppPurchaseManager

@synthesize productIdentifiers = productIdentifiers_;
@synthesize products           = products_;
@synthesize purchasedProducts  = purchasedProducts_;
@synthesize request            = request_;

- (void)dealloc {
  [productIdentifiers_ release];
  self.productIdentifiers = nil;
  [products_ release];
  self.products = nil;
  [purchasedProducts_ release];
  self.purchasedProducts = nil;
  [request_ release];
  self.request = nil;
  [super dealloc];
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
  if ((self = [super init])) {
    // Store product identifiers
    productIdentifiers_ = [productIdentifiers retain];
    
    // Check for previously purchased products
    NSMutableSet * purchasedProducts = [NSMutableSet set];
    for (NSString * productIdentifier in productIdentifiers_) {
      BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
      if (productPurchased) {
        [purchasedProducts addObject:productIdentifier];
        NSLog(@"Previously purchased: %@", productIdentifier);
      }
      NSLog(@"Not purchased: %@", productIdentifier);
    }
    self.purchasedProducts = purchasedProducts;
  }
  return self;
}

- (void)requestProducts {
  self.request = [[[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers_] autorelease];
  request_.delegate = self;
  [request_ start];
}

- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response {
  NSLog(@"Received products results...");
  self.products = response.products;
  self.request = nil;
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNProductsLoadedNotification
                                                      object:products_];
}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {
  // TODO: Record the transaction on the server side...    
}

- (void)provideContent:(NSString *)productIdentifier {
  NSLog(@"Toggling flag for: %@", productIdentifier);
  [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [purchasedProducts_ addObject:productIdentifier];
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNProductPurchasedNotification object:productIdentifier];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
  NSLog(@"completeTransaction...");
  [self recordTransaction: transaction];
  [self provideContent: transaction.payment.productIdentifier];
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
  NSLog(@"restoreTransaction...");
  [self recordTransaction: transaction];
  [self provideContent: transaction.originalTransaction.payment.productIdentifier];
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
  if (transaction.error.code != SKErrorPaymentCancelled) {
    NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
  }
  [[NSNotificationCenter defaultCenter] postNotificationName:kPMNProductPurchaseFailedNotification object:transaction];
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
  for (SKPaymentTransaction *transaction in transactions) {
    switch (transaction.transactionState) {
      case SKPaymentTransactionStatePurchased:
        [self completeTransaction:transaction];
        break;
      case SKPaymentTransactionStateFailed:
        [self failedTransaction:transaction];
        break;
      case SKPaymentTransactionStateRestored:
        [self restoreTransaction:transaction];
      default:
        break;
    }
  }
}

- (void)buyProductIdentifier:(NSString *)productIdentifier {
  NSLog(@"Buying %@...", productIdentifier);
  SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
  [[SKPaymentQueue defaultQueue] addPayment:payment];
}

@end
