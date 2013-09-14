//
//  NSString+Algorithm.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "NSString+Algorithm.h"

#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Algorithm)

// Encrypt NSString with MD5
- (NSString *)encrypt {
  return [self toMD5];
}

// MD5
- (NSString *)toMD5 {
  // Create pointer to the string as UTF8
  const char * ptr = [self UTF8String];
  
  // Create byte array of unsigned chars
  unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
  
  // Create 16 byte MD5 hash value, store in buffer
  CC_MD5(ptr, strlen(ptr), md5Buffer);
  
  // Convert MD5 value in the buffer to NSString of hex values
  NSMutableString * output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for(int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) 
    [output appendFormat:@"%02x",md5Buffer[i]];
  return output;
}

// For Pokedex
//     HEX: @"AFF"
//     BIN: 1  0  1  0 1 1 1 1 1 1 1 1 : 1:Caught 0:Not
// PokeDEX: 12 11 10 9 8 7 6 5 4 3 2 1
- (BOOL)isBinary1AtIndex:(NSInteger)index {
  NSInteger rangeStart = [self length] - round((index - 1) / 4) - 1;
  if (rangeStart < 0)
    return NO;
  
  unsigned  result    = 0;
  NSRange   scanRange = NSMakeRange(rangeStart, 1);
  NSScanner * scanner = [[NSScanner alloc] initWithString:[self substringWithRange:scanRange]];
  [scanner scanHexInt:&result];
  return (result & (1 << ((index - 1) % 4)));
}

// Generate a new Hex by modifying binary value at |index|
- (NSString *)generateHexBySettingBinaryTo1:(BOOL)settingBinaryTo1
                                    atIndex:(NSInteger)index
{
  NSString * string = self;
  NSInteger rangeStart = [string length] - round((index - 1) / 4) - 1;
  if (rangeStart < 0) {
    NSMutableString * appendedString = [NSMutableString string];
    for (NSInteger i = rangeStart; i < 0; ++i)
      [appendedString appendString:@"0"];
    string = [appendedString stringByAppendingString:string];
    rangeStart = 0;
//    NSString * s;
//    [s characterAtIndex:0];
  }
  
  // Get the single Hex to be modified
  NSRange   scanRange = NSMakeRange(rangeStart, 1);
  unsigned  result    = 0;
  NSScanner * scanner = [[NSScanner alloc] initWithString:[string substringWithRange:scanRange]];
  [scanner scanHexInt:&result];
  
  // New single Hex value by adding |mask|
  unsigned mask = 1 << ((index - 1) % 4);
  if (settingBinaryTo1) result = result |  mask;
  else                  result = result & ~mask;
  
  NSLog(@"|generateHexBySettingBainaryTo1:| - range:%@", [NSValue valueWithRange:scanRange]);
  return [string stringByReplacingCharactersInRange:scanRange
                                         withString:[NSString stringWithFormat:@"%x", result]];
}

// Number of 1s in Binary
- (NSInteger)numberOfBinary1 {
  NSInteger counter = 0;
  unsigned hex;
  for (int x = 0; x <= [self length] - 1; ++x) {
    NSScanner * scanner = [[NSScanner alloc] initWithString:[self substringWithRange:NSMakeRange(x, 1)]];
    [scanner scanHexInt:&hex];
    
    // Count 1s
    for (NSInteger i = 0; i < 4; ++i)
      if (hex & (1 << i)) ++counter;
  }
  
  return counter;
}

/*
// SHA1
- (NSString*) sha1:(NSString*)input {
  const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
  NSData *data = [NSData dataWithBytes:cstr length:input.length];
  
  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  
  CC_SHA1(data.bytes, data.length, digest);
  
  NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  
  for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
  
  return output;
}

// MD5
- (NSString *)md5:(NSString *)input {
  const char *cStr = [input UTF8String];
  unsigned char digest[16];
  CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
  
  NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  
  for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
  
  return  output;
}*/

@end
