//
//  DataDecoder.h
//  iPokeMon
//
//  Created by Kaijie Yu on 2/4/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDecoder : NSObject

+ (NSMutableArray *)generateHexArrayFrom:(NSString *)hexInString;

//+ (NSMutableArray *)decodePokedexFromBinary:(NSString *)dataInBinary;
+ (NSMutableArray *)decodePokedexFromHex:(NSString *)dataInHex;

//+ (NSString *)decodeNameFromHex:(NSString *)dataInHex;

@end
