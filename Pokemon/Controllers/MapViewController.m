//
//  MapViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MapViewController.h"

#import "MKMapView+ZoomLevel.h"

#import "PMLocationManager.h"
#import "Annotation+DataController.h"
#import "MEWMapAnnotation.h"
#import "MEWMapAnnotationView.h"
#import "MapAnnotationCalloutViewController.h"

@interface MapViewController () {
 @private
  MKMapView  * mapView_;
  UIButton   * locateMeButton_;
  UIButton   * showWorldButton_;
  
  CLLocation       * location_;
  MapAnnotationCalloutViewController * mapAnnotationCalloutViewController_;
  MKAnnotationView * selectedAnnotationView_;
  NSMutableSet     * annotations_;
  NSMutableSet     * annotationCodes_; // store codes for annotations that already added
  
  NSInteger        zoomLevel_;          // zoom level: 0 ~ 20
  MEWZoomLevelType zoomLevelType_; // zoom level of terrain
  NSInteger selectedAnnotationViewCount_;    // selected annotation view count
  BOOL      shouldIgnoreFirstRegionChange_;  // when select the annotation, map view will move the region
}

@property (nonatomic, retain) MKMapView  * mapView;
@property (nonatomic, retain) UIButton   * locateMeButton;
@property (nonatomic, retain) UIButton   * showWorldButton;

@property (nonatomic, retain) CLLocation       * location;
@property (nonatomic, retain) MapAnnotationCalloutViewController * mapAnnotationCalloutViewController;
@property (nonatomic, retain) MKAnnotationView * selectedAnnotationView;
@property (nonatomic, copy)   NSMutableSet     * annotations;
@property (nonatomic, copy)   NSMutableSet     * annotationCodes;

- (void)releaseSubviews;
- (void)_actionForButtonLocateMe:(id)sender;  // zoom in to user
- (void)_actionForButtonShowWorld:(id)sender; // zoom out to show all world
- (void)_increaseSelectedAnnotationViewCount; // increase |selectedAnnotationViewCount_|
- (void)_decreaseSelectedAnnotationViewCount; // decrease |selectedAnnotationViewCount_|
- (void)_setAnnotationView:(MKAnnotationView *)view // toggle annotation view between selected or not
                asSelected:(BOOL)selected
                completion:(void (^)(BOOL))completion;
- (MEWZoomLevelType)_typeOfZoomLevel:(NSInteger)zoomLevel;
- (BOOL)_needToUpdateAnnotations;
- (void)_updateAnnotations; // only add annotation view at current zoom level

@end


@implementation MapViewController

@synthesize mapView         = mapView_;
@synthesize locateMeButton  = locateMeButton_;
@synthesize showWorldButton = showWorldButton_;

@synthesize location               = location_;
@synthesize mapAnnotationCalloutViewController = mapAnnotationCalloutViewController_;
@synthesize selectedAnnotationView = selectedAnnotationView_;
@synthesize annotations            = annotations_;
@synthesize annotationCodes        = annotationCodes_;

- (void)dealloc {
  self.location               = nil;
  self.mapAnnotationCalloutViewController = nil;
  self.selectedAnnotationView = nil;
  self.annotations            = nil;
  self.annotationCodes        = nil;
  [self releaseSubviews];
  [super dealloc];
}

- (void)releaseSubviews {
  self.mapView         = nil;
  self.locateMeButton  = nil;
  self.showWorldButton = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.location = [[PMLocationManager sharedInstance] currLocation];
    // update annotations for current region
    [Annotation updateForCurrentRegion];
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  self.view = view;
  [view release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // basic settings
  zoomLevel_                     = 12.f;
  zoomLevelType_                 = kMEWZoomLevelTypeNone;
  selectedAnnotationViewCount_   = 0;
  shouldIgnoreFirstRegionChange_ = NO;
  
  // Google Map View
  MKMapView * mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
  [mapView setShowsUserLocation:YES];
  self.mapView = mapView;
  [mapView release];
  self.mapView.delegate = self;
  [self.view addSubview:self.mapView];
  
  // set default region with zoom level
  [self.mapView setCenterCoordinate:self.location.coordinate
                          zoomLevel:zoomLevel_
                           animated:YES];
  
  // buttons: |locateMeButton_| & |showWorldButton_|
  // constants
  CGFloat marginLeft = 30.f;
  CGRect buttonFrame = CGRectMake(marginLeft, kViewHeight - kMapButtonSize - 20.f, kMapButtonSize, kMapButtonSize);
  
  locateMeButton_ = [[UIButton alloc] initWithFrame:buttonFrame];
  [locateMeButton_ setImage:[UIImage imageNamed:kPMINIconLocateMe] forState:UIControlStateNormal];
  [locateMeButton_ setOpaque:NO];
  [locateMeButton_ setAlpha:.5f];
  [locateMeButton_ addTarget:self
                      action:@selector(_actionForButtonLocateMe:)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:locateMeButton_];
  
  buttonFrame.origin.x = kViewWidth - marginLeft - kMapButtonSize;
  showWorldButton_ = [[UIButton alloc] initWithFrame:buttonFrame];
  [showWorldButton_ setImage:[UIImage imageNamed:kPMINIconShowWorld] forState:UIControlStateNormal];
  [showWorldButton_ setOpaque:NO];
  [showWorldButton_ setAlpha:.5f];
  [showWorldButton_ addTarget:self
                       action:@selector(_actionForButtonShowWorld:)
             forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:showWorldButton_];
  
  // annotation set
  annotations_     = [[NSMutableSet alloc] init];
  annotationCodes_ = [[NSMutableSet alloc] init];
  
  // initialize the annotations
  [self _updateAnnotations];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self releaseSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// reset to default
- (void)reset {
  [self mapView:self.mapView regionWillChangeAnimated:YES];
}

#pragma mark - Private Methods

// Locate user's location
- (void)_actionForButtonLocateMe:(id)sender {  
  // Zoom In the |mapView_| & make User's Location as |mapView_| center point
  MKCoordinateRegion region = self.mapView.region;
  region.span.longitudeDelta = 0.01f;
  region.span.latitudeDelta  = 0.01f;
  region.center = CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude);
  [self.mapView setRegion:region animated:YES];  
}

// Show whole world map
- (void)_actionForButtonShowWorld:(id)sender {
  // Zoom Out the |mapView_| & make User's Location as |mapView_| center point
  MKCoordinateRegion region = self.mapView.region;
  region.span.longitudeDelta = 90;
  region.span.latitudeDelta  = 90;
  region.center = CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude);
  [self.mapView setRegion:region animated:YES];
}

// increase |selectedAnnotationViewCount_|
- (void)_increaseSelectedAnnotationViewCount {
  if (++selectedAnnotationViewCount_ > 2)
    selectedAnnotationViewCount_ = 2;
}

// decrease |selectedAnnotationViewCount_|
- (void)_decreaseSelectedAnnotationViewCount {
  if (--selectedAnnotationViewCount_ < 0)
    selectedAnnotationViewCount_ = 0;
}

// toggle the annotation view
- (void)_setAnnotationView:(MKAnnotationView *)view
                asSelected:(BOOL)selected
                completion:(void (^)(BOOL finished))completion {
  CGRect viewFrame = view.frame;
  CGFloat offset = (kMapAnnotationCalloutSubViewSize - kMapAnnotationSize) / 2.f;
  if (selected) {
    viewFrame.origin.x -= offset;
    viewFrame.origin.y -= offset;
    viewFrame.size = CGSizeMake(kMapAnnotationCalloutSubViewSize, kMapAnnotationCalloutSubViewSize);
    self.selectedAnnotationView = view;
  }
  else {
    viewFrame.origin.x += offset;
    viewFrame.origin.y += offset;
    viewFrame.size = CGSizeMake(kMapAnnotationSize, kMapAnnotationSize);
  }
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveLinear
                   animations:^{
                     [view setFrame:viewFrame];
                     [view setNeedsDisplay];
                   }
                   completion:completion];
}

// update |zoomLevelType_| with |zoomLevel|
- (MEWZoomLevelType)_typeOfZoomLevel:(NSInteger)zoomLevel {
  MEWZoomLevelType zoomLevelType = kMEWZoomLevelTypeNone;
  // contient & ocean: 0
  if (zoomLevel == kMEWMaxZoomLevelOfContinentAndOcean)
    zoomLevelType_ |= kMEWZoomLevelTypeContinentAndOcean;
  // country & sea: 1, 2
  else if (zoomLevel <= kMEWMaxZoomLevelOfCountryAndSea)
    zoomLevelType_ |= kMEWZoomLevelTypeCountryAndSea;
  // administrative (province): 3, 4
  else if (zoomLevel <= kMEWMaxZoomLevelOfAdministrativeArea)
    zoomLevelType_ |= kMEWZoomLevelTypeAdministrativeArea;
  // zoom levels are crossed for below types
  else {
    // locality (city): 5, 6, 7
    if (kMEWMinZoomLevelOfLocality <= zoomLevel <= kMEWMaxZoomLevelOfLocality)
      zoomLevelType_ |= kMEWZoomLevelTypeLocality;
    // lake: 6, 7, 8, 9
    if (kMEWMinZoomLevelOfLake <= zoomLevel <= kMEWMaxZoomLevelOfLake)
      zoomLevelType_ |= kMEWZoomLevelTypeLake;
    // sub-locality (district): 8, 9, 10
    if (kMEWMinZoomLevelOfSubLocality <= zoomLevel <= kMEWMaxZoomLevelOfSubLocality)
      zoomLevelType_ |= kMEWZoomLevelTypeSubLocality;
    // hot point: shop, etc.: 10, ..., 20
    if (kMEWMinZoomLevelOfHotPoint <= zoomLevel <= kMEWMaxZoomLevelOfHotPoint)
      zoomLevelType_ |= kMEWZoomLevelTypeHotPoint;
  }
  return zoomLevelType;
}

// whether need to update annotations at current zoom level
//   if types are same, no need to do updating
//   otherwise, update |zoomLevelType_| & return YES
- (BOOL)_needToUpdateAnnotations {
  MEWZoomLevelType zoomLevelType = [self _typeOfZoomLevel:zoomLevel_];
  if (zoomLevelType_ == zoomLevelType)
    return NO;
  zoomLevelType_ = zoomLevelType;
  return YES;
}

// only show annotation view in current zoom level
- (void)_updateAnnotations {
  // remove old annotations
  [self.mapView removeAnnotations:[self.annotations allObjects]];
  
  // only store annotations at current zoom level
  NSArray * annotations = [Annotation annotationsAtZoomLevel:zoomLevel_];
  NSMutableArray * mapAnnotations = [[NSMutableArray alloc] init];
  // add annotations to |mapView_|
  for (Annotation * annotation in annotations) {
    if ([self.annotationCodes containsObject:annotation.code])
      continue;
    [self.annotationCodes addObject:annotation.code];
    
    MEWMapAnnotation * mapAnnotation = [MEWMapAnnotation alloc];
    [mapAnnotation initWithCode:annotation.code
                     coordinate:CLLocationCoordinate2DMake([annotation.latitude floatValue], [annotation.longitude floatValue])
                          title:annotation.title
                       subtitle:annotation.subtitle];
    NSLog(@"---> new Annotation...code:%@", annotation.code);
    [mapAnnotations addObject:mapAnnotation];
    [mapAnnotation release];
  }
  
  [self.mapView addAnnotations:mapAnnotations];
  self.annotations = [NSMutableSet setWithArray:mapAnnotations];
  [mapAnnotations release];
  annotations = nil;

  
  // contient & ocean: 0
  if (zoomLevel_ == kMEWMaxZoomLevelOfContinentAndOcean) {
    
  }
  // country & sea: 1, 2
  else if (zoomLevel_ <= kMEWMaxZoomLevelOfCountryAndSea) {
    
  }
  // administrative (province): 3, 4
  else if (zoomLevel_ <= kMEWMaxZoomLevelOfAdministrativeArea) {
    
  }
  // zoom levels are crossed for below types
  else {
    // locality (city): 5, 6, 7
    if (kMEWMinZoomLevelOfLocality <= zoomLevel_ <= kMEWMaxZoomLevelOfLocality) {
      
    }
    // lake: 6, 7, 8, 9
    if (kMEWMinZoomLevelOfLake <= zoomLevel_ <= kMEWMaxZoomLevelOfLake) {
      
    }
    // sub-locality (district): 8, 9, 10
    if (kMEWMinZoomLevelOfSubLocality <= zoomLevel_ <= kMEWMaxZoomLevelOfSubLocality) {
      
    }
    // hot point: shop, etc.: 10, ..., 20
    if (kMEWMinZoomLevelOfHotPoint <= zoomLevel_ <= kMEWMaxZoomLevelOfHotPoint) {
      
    }
  }
}

#pragma mark - MKMapView Delegate

// Tells the delegate that one or more annotation views were added to the map
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
  // add animation for showing annotation views
  //CGRect visibleRect = [mapView annotationVisibleRect];
  for(MKAnnotationView *view in views) {
    if(! [view isKindOfClass:[MEWMapAnnotationView class]])
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
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                       [view setFrame:endFrame];
                       [view setAlpha:1.f];
                     }
                     completion:nil];
  }
}

// Tells the delegate that the location of the user was updated
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
}

// Returns the view associated with the specified annotation object
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
  if([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
  
  NSString * annotationIdentifier = @"com.kjuly.Mew.PinViewAnnotation";
  MEWMapAnnotationView * annotationView =
    (MEWMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
  if (! annotationView) {
    annotationView = [[[MEWMapAnnotationView alloc] initWithAnnotation:annotation
                                                       reuseIdentifier:annotationIdentifier] autorelease];
    // do not show the default callout view
    //annotationView.canShowCallout = YES;
  }
  
  // Configure the |annotationView|
  annotationView.annotation = annotation;
  [annotationView updateImage];
  return annotationView;
}

// Tells the delegate that one of its annotation views was selected
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
  if ([view.annotation isKindOfClass:[MKUserLocation class]])
    return;
  
  shouldIgnoreFirstRegionChange_ = YES;
  [self _increaseSelectedAnnotationViewCount];
  
  if (self.mapAnnotationCalloutViewController == nil) {
    mapAnnotationCalloutViewController_ = [MapAnnotationCalloutViewController alloc];
    [mapAnnotationCalloutViewController_ init];
    CGRect viewFrame = self.mapAnnotationCalloutViewController.view.frame;
    viewFrame.origin.y = kMapButtonSize  / 2.f + 10.f;
    viewFrame.origin.x = (kViewWidth - kMapAnnotationCalloutViewWidth) / 2.f;
    [mapAnnotationCalloutViewController_.view setFrame:viewFrame];
  }
  
  // set content for callout view & move the annotation point to center of the view
  MEWMapAnnotation * mapAnnotation = (MEWMapAnnotation *)view.annotation;
  [self.mapAnnotationCalloutViewController configureWithTitle:mapAnnotation.title
                                                  description:mapAnnotation.subtitle];
  [self.mapView setCenterCoordinate:mapAnnotation.coordinate
                           animated:YES];
  mapAnnotation = nil;
  
  // if there's an annotation view selected already,
  //   close the previous one first & do switching for callout view
  if (selectedAnnotationViewCount_ == 2)
    [self.mapAnnotationCalloutViewController switchViewAnimated:YES];
  // otherwise, add callout view & load it animated
  else {
    [self.view addSubview:self.mapAnnotationCalloutViewController.view];
    [self.mapAnnotationCalloutViewController loadViewAnimated:YES];
  }
  // open selected annotation view
  [self _setAnnotationView:view
                asSelected:YES
                completion:nil];
}

// Tells the delegate that one of its annotation views was deselected
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
  if (selectedAnnotationViewCount_ == 0)
    return;
  [self _setAnnotationView:view
                asSelected:NO
                completion:^(BOOL finished) {
                  [self _decreaseSelectedAnnotationViewCount];
                  if (selectedAnnotationViewCount_ == 0) {
                    [self.mapAnnotationCalloutViewController unloadViewAnimated:YES];
                  }
                }];
}

// Tells the delegate that the region displayed by the map view is about to change
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
  // ignore the first region change when select a annotation
  //   to prevent unload the callout view
  if (shouldIgnoreFirstRegionChange_) {
    shouldIgnoreFirstRegionChange_ = NO;
    return;
  }
  
  // if no annotation is open, do nothing
  if (selectedAnnotationViewCount_ == 0 || self.selectedAnnotationView == nil)
    return;
//  [self mapView:self.mapView didDeselectAnnotationView:self.selectedAnnotationView];
  [self _setAnnotationView:self.selectedAnnotationView
                asSelected:NO
                completion:nil];
  selectedAnnotationViewCount_ = 0;
  [self.mapAnnotationCalloutViewController unloadViewAnimated:YES];
}

// Tells the delegate that the region displayed by the map view just changed
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
  zoomLevel_ = [mapView zoomLevel];
  NSLog(@"zoomLevel = %d", zoomLevel_);
  
  // check whether need to update annotations,
  //   if so, do updating for annotations in current zoom level
  if ([self _needToUpdateAnnotations]) {
    NSLog(@"UPDATing annotation views...");
    [self _updateAnnotations];
  }
}

//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
//  
//}

@end
