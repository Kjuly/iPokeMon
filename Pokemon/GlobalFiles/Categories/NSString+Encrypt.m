//
//  NSString+Encrypt.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "NSString+Encrypt.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Encrypt)

// Encrypt NSString with MD5
- (NSString *)encrypt {
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
