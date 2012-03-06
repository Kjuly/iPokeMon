//
//  DataTransformer.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/18/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "DataTransformer.h"


#pragma mark - UIImage to NSData

@implementation ImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
	NSData * data = UIImagePNGRepresentation(value);
	return data;
}

- (id)reverseTransformedValue:(id)value {
	UIImage * image = [[UIImage alloc] initWithData:value];
	return [image autorelease];
}

@end

#pragma mark - NSArray to NSString

@implementation ArrayToStringTransformer // Need change to |ArrayToDataTransformer|

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
  return [value dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)reverseTransformedValue:(id)value {
  NSString * stringData = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
  NSArray * dataArray = [stringData componentsSeparatedByString:@","];
  [stringData release];
  return dataArray;
}

@end
