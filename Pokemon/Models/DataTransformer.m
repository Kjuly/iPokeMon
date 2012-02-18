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

@implementation ArrayToStringTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSString class];
}

- (id)transformedValue:(id)value {
  if ([value class] == [NSString class])
    return value;
  
  NSMutableString * string = [NSMutableString string];
  for (NSNumber * number in value)
    [string appendString:[NSString stringWithFormat:@"%@,", number]];
	return string;
}

- (id)reverseTransformedValue:(id)value {
  NSArray * array = [value componentsSeparatedByString:@","];
	return array;
}

@end
