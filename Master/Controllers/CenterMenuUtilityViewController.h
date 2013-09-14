//
//  CenterMenuUtilityViewController.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PMCircleMenu.h"

#ifdef KY_INVITATION_ONLY
#import "KYUnlockCodeManager.h"
#endif

@interface CenterMenuUtilityViewController : PMCircleMenu

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
#ifdef KY_INVITATION_ONLY
@property (retain, nonatomic) KYUnlockCodeManager * unlockCodeManager;
#endif

@end
