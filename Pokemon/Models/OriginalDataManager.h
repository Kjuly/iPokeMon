//
//  OriginalDataManager.h
//  iPokeMon
//
//  Created by Kaijie Yu on 3/17/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OriginalDataManager : NSObject

// Update data with resource bundle
// If the bundle is not offered, use main bundle and init the data
+ (BOOL)updateDataWithMOC:(NSManagedObjectContext *)moc
           resourceBundle:(NSBundle *)bundle
                   isInit:(BOOL)isInit;

@end
