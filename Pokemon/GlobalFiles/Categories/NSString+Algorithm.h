//
//  NSString+Algorithm.h
//  Pokemon
//
//  Created by Kaijie Yu on 3/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Algorithm)

- (NSString *)encrypt;
- (NSString *)toMD5;
- (BOOL)isBinary1AtIndex:(NSInteger)index;
- (NSString *)generateHexBySettingBainaryTo1:(BOOL)settingBinaryTo1 atIndex:(NSInteger)index;

@end
