//
//  Annotation+DataController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 5/26/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "Annotation+DataController.h"

#import "AppDelegate.h"
#import "ServerAPIClient.h"
#import "LoadingManager.h"

@interface Annotation (Private)

//- (void)_updateAnnotation;
+ (NSArray *)_parsedAnnotation:(NSString *)annotation;
+ (void)_updateForAnnotationType:(AnnotationType)annotationType
                  withCodePrefix:(NSString *)codePrefix
                            data:(NSArray *)data;

@end

@implementation Annotation (DataController)

// update annotation data for current region
+ (void)updateForCurrentRegion {
  NSLog(@"=== START");
  // Success Block Method
  void (^success)(AFHTTPRequestOperation *, id) = ^(AFHTTPRequestOperation *operation, id JSON) {
    // Get JSON Data Array from HTTP Response
    //
    // zl : Zoom Level
    // max: Map AnnotationS
    //
    // {
    //    "zl" : "3:4",
    //    "max": [
    //             "ZJ=30.2333=120.1670=Zhejiang=Zhejiang",
    //             ...
    //           ]
    // }
    //
    if ([[JSON valueForKey:@"mas"] isKindOfClass:[NSNull class]]) {
      NSLog(@"...SYNC Annotation Info from SERVER DONE...NO Annotation Data");
      // Hide loading
      [[LoadingManager sharedInstance] hideOverBar];
      return;
    }
    
    // Parse data from JSON
    NSArray * datas = [JSON valueForKey:@"mas"];
    NSLog(@"Pulled datas : SERVER => CLIENT::%@", datas);
    
    // start to update annotations
    NSManagedObjectContext * managedObjectContext =
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                        inManagedObjectContext:managedObjectContext]];
    [fetchRequest setFetchLimit:1];
    
    // update with all datas that fetched
    for (NSDictionary * data in datas) {
      NSArray * zoomLevels = [[data valueForKey:@"l"] componentsSeparatedByString:@"="];
      NSNumber * minZoomLevel = [NSNumber numberWithInt:[[zoomLevels objectAtIndex:0] intValue]];
      NSNumber * maxZoomLevel = [NSNumber numberWithInt:[[zoomLevels objectAtIndex:1] intValue]];
      
      NSArray * annotations = [data objectForKey:@"as"];
      // update annotations
      for (NSString *annotationData in annotations) {
        // parse annotation data (e.g.: "ZJ=30.2333=120.1670=Zhejiang=Zhejiang") to an array
        NSArray * parsedAnnotation = [self _parsedAnnotation:annotationData];
        // Update the data for model:|Annotation|
        Annotation * annotation;
        // Check the existence of the object
        //   if exist, execute fetching request, otherwise, insert new object
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"code == %@",
                                    [parsedAnnotation objectAtIndex:0]]];
        if ([managedObjectContext countForFetchRequest:fetchRequest error:&error])
          annotation = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] lastObject];
        else annotation = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                                        inManagedObjectContext:managedObjectContext];
        // set data for annotation
        annotation.code         = [parsedAnnotation objectAtIndex:0];
        annotation.latitude     = [NSNumber numberWithFloat:[[parsedAnnotation objectAtIndex:1] floatValue]];
        annotation.longitude    = [NSNumber numberWithFloat:[[parsedAnnotation objectAtIndex:2] floatValue]];
        annotation.title        = [parsedAnnotation objectAtIndex:3];
        annotation.subtitle     = [parsedAnnotation lastObject];
        annotation.minZoomLevel = minZoomLevel;
        annotation.maxZoomLevel = maxZoomLevel;
      }
    }
    
    if (! [managedObjectContext save:&error])
      NSLog(@"!!! Couldn't save data to %@, %@", NSStringFromClass([self class]), error);
    NSLog(@"...Update |%@| data done...", [self class]);
    
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
  };
  
  // Failure Block Method
  void (^failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError * error) {
    NSLog(@"!!! ERROR: %@", error);
    // Hide loading
    [[LoadingManager sharedInstance] hideOverBar];
  };
  
  // Show loading
  [[LoadingManager sharedInstance] showOverBar];
  // Fetch data from server & populate the |teamedPokemon|
  [[ServerAPIClient sharedInstance] fetchDataFor:kDataFetchTargetAnnotation
                                      withObject:nil
                                         success:success
                                         failure:failure];
}

// query annotations at current zoom level
+ (NSArray *)annotationsAtZoomLevel:(NSInteger)zoomLevel {
  NSManagedObjectContext * managedObjectContext =
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
  
  NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class])
                                      inManagedObjectContext:managedObjectContext]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"%d BETWEEN { minZoomLevel, maxZoomLevel }", zoomLevel]];
  
  NSError * error;
  NSArray * annotations = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
  return annotations;
}

#pragma mark - Private Methods

+ (NSArray *)_parsedAnnotation:(NSString *)annotation {
  return [annotation componentsSeparatedByString:@"="];
}

// update data fot annotations
+ (void)_updateForAnnotationType:(AnnotationType)annotationType
                  withCodePrefix:(NSString *)codePrefix
                            data:(NSArray *)data {
  
}

@end
