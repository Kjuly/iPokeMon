//
//  IAPHelper.h
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

#define kPMNProductsLoadedNotification        @"ProductsLoaded"
#define kPMNProductPurchasedNotification      @"ProductPurchased"
#define kPMNProductPurchaseFailedNotification @"ProductPurchaseFailed"

@interface InAppPurchaseManager : NSObject <
  SKProductsRequestDelegate,
  SKPaymentTransactionObserver
> {
  NSSet             * productIdentifiers_;
  NSArray           * products_;
  SKProductsRequest * request_;
}

@property (nonatomic, copy)   NSSet             * productIdentifiers;
@property (nonatomic, copy)   NSArray           * products;
@property (nonatomic, strong) SKProductsRequest * request;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProducts;
- (void)buyProduct:(SKProduct *)product;

@end
