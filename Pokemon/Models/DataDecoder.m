//
//  DataDecoder.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/4/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "DataDecoder.h"

const NSRange kRangePokemonName = {0, 4};

@implementation DataDecoder

+ (NSUInteger)decodeNameFrom:(NSString *)hex
{
  NSUInteger decodeResult;
  NSScanner * scanner = [NSScanner scannerWithString:[hex substringWithRange:kRangePokemonName]];
  [scanner setScanLocation:0];
  [scanner scanHexInt:&decodeResult];
  return decodeResult;
}

@end
