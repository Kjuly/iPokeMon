//
//  PMPurchaseManager.m
//  iPokemon
//
//  Created by Kaijie Yu on 4/30/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PMPurchaseManager.h"

#define kPMCurrencyTier1ID @"com.kjuly.Mew.coin.tier1"
#define kPMCurrencyTier2ID @"com.kjuly.Mew.coin.tier2"
#define kPMCurrencyTier3ID @"com.kjuly.Mew.coin.tier3"

@implementation PMPurchaseManager

// singleton
static PMPurchaseManager * purchaseManager_ = nil;
+ (InAppPurchaseManager *)sharedInstance {
  if (purchaseManager_ != nil)
    return purchaseManager_;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    purchaseManager_ = [[PMPurchaseManager alloc] init];
  });
  return purchaseManager_;
}

- (id)init {
  NSSet * productIdentifiers = [[NSSet alloc] initWithObjects:
                                kPMCurrencyTier1ID,
                                kPMCurrencyTier2ID,
                                kPMCurrencyTier3ID, nil];
  if (self = [super initWithProductIdentifiers:productIdentifiers]) {
  }
  [productIdentifiers release];
  return self;
}

@end
