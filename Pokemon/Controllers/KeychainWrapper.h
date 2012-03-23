//
//  KeychainWrapper.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/23/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface KeychainWrapper : NSObject
{
  NSMutableDictionary * keychainData_;
  NSMutableDictionary * genericPasswordQuery_;
}

@property (nonatomic, retain) NSMutableDictionary * keychainData;
@property (nonatomic, retain) NSMutableDictionary * genericPasswordQuery;

- (void)setKeychainObject:(id)inObject forKey:(id)key;
- (id)keychainObjectForKey:(id)key;
- (void)resetKeychainItem;

@end
