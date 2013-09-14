//
//  DataTransformer.m
//  iPokeMon
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
	return image;
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
  if (! [value isKindOfClass:[NSArray class]])
    return [NSKeyedArchiver archivedDataWithRootObject:value];
  
  // If the |value| class is |NSArray| type,
  // Transform |NSArray| to |NSString| first, then to |NSData|.
  NSInteger arrayCount = [value count];
  if (arrayCount == 0)
    return [NSKeyedArchiver archivedDataWithRootObject:@""];
  NSMutableString * valueInString =
    [NSMutableString stringWithString:[NSString stringWithFormat:@"%d", [[value objectAtIndex:0] intValue]]];
  for (NSInteger i = 1; i < arrayCount; ++i)
    [valueInString appendString:[NSString stringWithFormat:@",%d", [[value objectAtIndex:i] intValue]]];
  return [NSKeyedArchiver archivedDataWithRootObject:valueInString];
}

- (id)reverseTransformedValue:(id)value {
//  NSString * stringData = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
//  NSArray * dataArray = [stringData componentsSeparatedByString:@","];
//  [stringData release];
//  return dataArray;
  return [[NSKeyedUnarchiver unarchiveObjectWithData:value] componentsSeparatedByString:@","];
//  return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
