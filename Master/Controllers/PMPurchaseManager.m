//
//  PMPurchaseManager.m
//  iPokeMon
//
//  Created by Kaijie Yu on 4/30/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PMPurchaseManager.h"

@implementation PMPurchaseManager

// singleton
static PMPurchaseManager * purchaseManager_ = nil;
+ (InAppPurchaseManager *)sharedInstance
{
  if (purchaseManager_ != nil)
    return purchaseManager_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    purchaseManager_ = [[PMPurchaseManager alloc] init];
  });
  return purchaseManager_;
}

- (id)init
{
  NSSet * productIdentifiers = [[NSSet alloc] initWithObjects:
                                kIAPCurrencyTier1,
                                kIAPCurrencyTier2,
                                kIAPCurrencyTier3, nil];
  self = [super initWithProductIdentifiers:productIdentifiers];
  return self;
}

@end
