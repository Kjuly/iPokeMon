//
//  DataDecoder.h
//  Pokemon
//
//  Created by Kaijie Yu on 2/4/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataDecoder : NSObject

+ (NSMutableArray *)decodePokedexFrom:(NSString *)data;

+ (NSString *)decodeNameFrom:(NSString *)hex;

@end
