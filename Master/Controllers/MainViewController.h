//
//  MainViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef KY_INVITATION_ONLY
#import "KYUnlockCodeManager.h"
#endif

@interface MainViewController : UIViewController
#ifdef KY_INVITATION_ONLY
  <KYUnlockCodeManagerDataSource, KYUnlockCodeManagerDelegate>
#endif

@property (retain, nonatomic) NSManagedObjectContext * managedObjectContext;

@end
