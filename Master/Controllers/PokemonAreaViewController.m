//
//  PokemonAreaViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonAreaViewController.h"

#import "MKMapView+ZoomLevel.h"
#import "PMLocationManager.h"
#import "Pokemon+DataController.h"
#import "PokemonAreaAnnotation.h"
#import "PokemonAreaAnnotationView.h"

@interface PokemonAreaViewController () {
 @private
  MKMapView    * mapView_;
  CLLocation   * location_;
  NSMutableSet * annotations_;
  
  NSInteger pokemonSID_;
  NSInteger zoomLevel_;
}

@property (nonatomic, strong) MKMapView    * mapView;
@property (nonatomic, strong) CLLocation   * location;
@property (nonatomic, copy)   NSMutableSet * annotations;

- (void)_updateAnnotations;

@end

@implementation PokemonAreaViewController

@synthesize mapView     = mapView_;
@synthesize location    = location_;
@synthesize annotations = annotations_;

- (id)initWithPokemonSID:(NSInteger)pokemonSID
{
  if (self = [self init]) {
    pokemonSID_ = pokemonSID;
  }
  return self;
}

- (id)init
{
  if (self = [super init]) {
    // Custom initialization
    self.location = [[PMLocationManager sharedInstance] currLocation];
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
  [super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  // basic settings
  zoomLevel_   = 3.f;
  annotations_ = [[NSMutableSet alloc] init];
  
  // Google Map View
  CGRect mapViewFrame = self.view.frame;
  mapViewFrame.origin.y = -kNavigationBarBottomAlphaHegiht;
  MKMapView * mapView = [[MKMapView alloc] initWithFrame:mapViewFrame];
  [mapView setShowsUserLocation:YES];
  self.mapView = mapView;
  [self.mapView setDelegate:self];
  [self.view addSubview:self.mapView];
  
  // set default region with zoom level
  [self.mapView setCenterCoordinate:self.location.coordinate
                          zoomLevel:zoomLevel_
                           animated:YES];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.mapView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

// only show annotation view in current zoom level
- (void)_updateAnnotations
{
  // remove old annotations
  [self.mapView removeAnnotations:[self.annotations allObjects]];
  // get PM with SID
  Pokemon * pokemon = [Pokemon queryPokemonDataWithSID:pokemonSID_];
  
  // completion block to be executed after area data fetched
  void (^completion)(BOOL) = ^(BOOL finished) {
    NSArray * coordinatePairs = [pokemon.area componentsSeparatedByString:@":"];
    NSMutableArray * pokemonAreaAnnotations = [[NSMutableArray alloc] init];
    // add annotations to |mapView_|
    for (NSString * coordinatePair in coordinatePairs) {
      NSLog(@"%@", coordinatePair);
      NSArray * coordinates = [coordinatePair componentsSeparatedByString:@","];
      if ([coordinates count] < 2)
        continue;
      PokemonAreaAnnotation * pokemonAreaAnnotation = [PokemonAreaAnnotation alloc];
      (void)[pokemonAreaAnnotation initWithCoordinate:CLLocationCoordinate2DMake([[coordinates objectAtIndex:0] floatValue],
                                                                                 [[coordinates objectAtIndex:1] floatValue])
                                                title:nil
                                             subtitle:nil];
      NSLog(@"---> new Annotation...");
      [pokemonAreaAnnotations addObject:pokemonAreaAnnotation];
    }
    
    [self.mapView addAnnotations:pokemonAreaAnnotations];
    self.annotations = [NSMutableSet setWithArray:pokemonAreaAnnotations];
    coordinatePairs = nil;
  };
  
  // get area data for PM
  [pokemon getAreaCompletion:completion];
}

#pragma mark - MKMapView Delegate

// Tells the delegate that one or more annotation views were added to the map
- (void)      mapView:(MKMapView *)mapView
didAddAnnotationViews:(NSArray *)views
{
  // add animation for showing annotation views
  //CGRect visibleRect = [mapView annotationVisibleRect];
  for(MKAnnotationView *view in views) {
    if(! [view isKindOfClass:[PokemonAreaAnnotationView class]])
      continue;
    //CGRect endFrame = view.frame;
    //CGRect startFrame = endFrame;
    //startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
    //view.frame = startFrame;
    
    CGRect endFrame = view.frame;
    CGRect startFrame = endFrame;
    CGFloat originalSize = view.frame.size.width;
    CGFloat startSize = 16.f;
    CGFloat offset = (originalSize - startSize) / 2.f;
    startFrame.origin.x += offset;
    startFrame.origin.y += offset;
    startFrame.size = CGSizeMake(startSize, startSize);
    [view setFrame:startFrame];
    [view setAlpha:0.f];
    
    [UIView commitAnimations];
    [UIView animateWithDuration:.3f
                          delay:0.f
                        options:(UIViewAnimationOptions)UIViewAnimationCurveEaseOut
                     animations:^{
                       [view setFrame:endFrame];
                       [view setAlpha:1.f];
                     }
                     completion:nil];
  }
}

// Returns the view associated with the specified annotation object
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
  if ([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
  
  NSString * annotationIdentifier = @"com.kjuly.Mew.PokemonAreaAnnotationView";
  PokemonAreaAnnotationView * annotationView =
    (PokemonAreaAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
  if (! annotationView) {
    annotationView = [[PokemonAreaAnnotationView alloc] initWithAnnotation:annotation
                                                            reuseIdentifier:annotationIdentifier];
    // do not show the default callout view
    //annotationView.canShowCallout = YES;
  }
  
  // Configure the |annotationView|
  annotationView.annotation = annotation;
//  [annotationView setNeedsDisplay];
  return annotationView;
}

// Tells the delegate that the region displayed by the map view just changed
- (void)        mapView:(MKMapView *)mapView
regionDidChangeAnimated:(BOOL)animated
{
  NSInteger zoomLevel = [mapView zoomLevel];
  NSLog(@"zoomLevel = %d", zoomLevel);
  if (zoomLevel_ == zoomLevel)
    return;
  zoomLevel_ = zoomLevel;
  
  // do updating for annotations in current zoom level
  NSLog(@"UPDATing annotation views...");
  [self _updateAnnotations];
}

@end
