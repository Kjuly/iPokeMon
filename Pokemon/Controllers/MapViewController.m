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
#import "MEWMapPoint.h"
#import "MEWMapAnnotationView.h"
#import "MapAnnotationCalloutViewController.h"

@interface MapViewController () {
 @private
  MKMapView  * mapView_;
  UIButton   * locateMeButton_;
  UIButton   * showWorldButton_;
  
  CLLocation * location_;
  MapAnnotationCalloutViewController * mapAnnotationCalloutViewController_;
  
  NSInteger zoomLevel_;
  NSInteger selectedAnnotationViewCount_;
  BOOL      shouldIgnoreFirstRegionChange_; // when select the annotation, map view will move the region
}

@property (nonatomic, retain) MKMapView  * mapView;
@property (nonatomic, retain) UIButton   * locateMeButton;
@property (nonatomic, retain) UIButton   * showWorldButton;

@property (nonatomic, retain) CLLocation * location;
@property (nonatomic, retain) MapAnnotationCalloutViewController * mapAnnotationCalloutViewController;
@property (nonatomic, retain) MKAnnotationView * selectedAnnotationView;

- (void)releaseSubviews;
- (void)_actionForButtonLocateMe:(id)sender;
- (void)_actionForButtonShowWorld:(id)sender;
- (void)_increaseSelectedAnnotationViewCount;
- (void)_decreaseSelectedAnnotationViewCount;
- (void)_setAnnotationView:(MKAnnotationView *)view
                asSelected:(BOOL)selected
                completion:(void (^)(BOOL))completion;

@end


@implementation MapViewController

@synthesize mapView         = mapView_;
@synthesize locateMeButton  = locateMeButton_;
@synthesize showWorldButton = showWorldButton_;

@synthesize location        = location_;
@synthesize mapAnnotationCalloutViewController = mapAnnotationCalloutViewController_;
@synthesize selectedAnnotationView = selectedAnnotationView_;

- (void)dealloc {
  self.location = nil;
  self.mapAnnotationCalloutViewController = nil;
  self.selectedAnnotationView = nil;
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
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self releaseSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UtilityViewControllerDelegate

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

#pragma mark - MKMapView Delegate

// Tells the delegate that one or more annotation views were added to the map
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
  // add animation for showing annotation views
  //CGRect visibleRect = [mapView annotationVisibleRect];
  for(MKAnnotationView *view in views) {
    if([view isKindOfClass:[MEWMapAnnotationView class]]) {
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
}

// Tells the delegate that the location of the user was updated
static BOOL generated = NO;
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  if (generated)
    return;
  generated = YES;
  
  CLLocationCoordinate2D userCoordinate = userLocation.location.coordinate;
  for(int i = 1; i <= 5; ++i) {
    CGFloat latDelta  = rand() * .035f / RAND_MAX - .02f;
    CGFloat longDelta = rand() * .03f / RAND_MAX - .015f;
    CLLocationCoordinate2D newCoord = {
      userCoordinate.latitude + latDelta,
      userCoordinate.longitude + longDelta
    };
    MEWMapPoint * mapPoint = [MEWMapPoint alloc];
    [mapPoint initWithCoordinate:newCoord
                           title:[NSString stringWithFormat:@"Azam Home %d", i]
                        subTitle:@"Home Sweet Home"];
    [self.mapView addAnnotation:mapPoint];
    [mapPoint release];
  }
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
  [annotationView setImageWithName:@"mpbCN-ZJ-HZ.png"];
  return annotationView;
}

// Tells the delegate that one of its annotation views was selected
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
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
  
  MEWMapPoint * mapPoint = (MEWMapPoint *)(view.annotation);
  MKCoordinateRegion region = self.mapView.region;
  region.center = CLLocationCoordinate2DMake(mapPoint.coordinate.latitude, mapPoint.coordinate.longitude);
  [self.mapView setRegion:region animated:YES];
  mapPoint = nil;
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
  NSLog(@"region did cahnged, zoom level:%d", zoomLevel_);
}

//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
//  
//}

@end
