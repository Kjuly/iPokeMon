//
//  ResourceManager.h
//  iPokeMon
//
//  Created by Kjuly on 1/24/13.
//  Copyright (c) 2013 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceManager : NSObject {
  NSBundle * bundle_;
}

@property (nonatomic, retain) NSBundle * bundle;

+ (ResourceManager *)sharedInstance;
- (NSBundle *)bundle;

@end
