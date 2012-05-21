//
//  MapViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MapViewController.h"

#import "PMLocationManager.h"
#import "MEWMapPoint.h"
#import "MEWMapAnnotationView.h"

@interface MapViewController () {
 @private
  MKMapView  * mapView_;
  UIButton   * locateMeButton_;
  UIButton   * showWorldButton_;
  
  CLLocation * location_;
}

@property (nonatomic, retain) MKMapView  * mapView;
@property (nonatomic, retain) UIButton   * locateMeButton;
@property (nonatomic, retain) UIButton   * showWorldButton;

@property (nonatomic, retain) CLLocation * location;

- (void)releaseSubviews;
- (void)_actionForButtonLocateMe:(id)sender;
- (void)_actionForButtonShowWorld:(id)sender;

@end


@implementation MapViewController

@synthesize mapView         = mapView_;
@synthesize locateMeButton  = locateMeButton_;
@synthesize showWorldButton = showWorldButton_;

@synthesize location        = location_;

- (void)dealloc {
  self.location = nil;
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
  
  // Google Map View
  MKMapView * mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
  [mapView setShowsUserLocation:YES];
  self.mapView = mapView;
  [mapView release];
  self.mapView.delegate = self;
  [self.view addSubview:self.mapView];
  
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
  // Get current location
//  self.location = self.locationManager.location;
  
  // Zoom In the |mapView_| & make User's Location as |mapView_| center point
  MKCoordinateRegion region = self.mapView.region;
  region.span.longitudeDelta = 0.01f;
  region.span.latitudeDelta  = 0.01f;
  region.center = CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude);
  [self.mapView setRegion:region animated:YES];  
}

// Show whole world map
- (void)_actionForButtonShowWorld:(id)sender {
  // Get current location
//  self.location = self.locationManager.location;
  
  // Zoom Out the |mapView_| & make User's Location as |mapView_| center point
  MKCoordinateRegion region = self.mapView.region;
  region.span.longitudeDelta = 180;
  region.span.latitudeDelta  = 180;
  region.center = CLLocationCoordinate2DMake(self.location.coordinate.latitude, self.location.coordinate.longitude);
  [self.mapView setRegion:region animated:YES];
}

#pragma mark - MKMapView Delegate

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
//  MKAnnotationView *annotationView = [views objectAtIndex:0];
//  id<MKAnnotation> mp = [annotationView annotation];
//  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate] ,250,250);
//  [self.mapView setRegion:region animated:YES];
  
  // add animation for showing annotation views
//  CGRect visibleRect = [mapView annotationVisibleRect];
  for(MKAnnotationView *view in views) {
    if([view isKindOfClass:[MEWMapAnnotationView class]]) {
//      CGRect endFrame = view.frame;
//      CGRect startFrame = endFrame;
//      startFrame.origin.y = visibleRect.origin.y - startFrame.size.height;
//      view.frame = startFrame;
      
      CGRect endFrame = view.frame;
      CGRect startFrame = endFrame;
      CGFloat originalSize = view.frame.size.width;
      CGFloat startSize = 128.f;
      CGFloat offset = (startSize - originalSize) / 2.f;
      startFrame.origin.x -= offset;
      startFrame.origin.y -= offset;
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

// when a new location update is received by the map view.
static BOOL generated = NO;
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
  self.location = userLocation.location;
  
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
                           title:[NSString stringWithFormat:@"Azam Home %d",i]
                        subTitle:@"Home Sweet Home"];
    [self.mapView addAnnotation:mapPoint];
    [mapPoint release];
  }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  if([annotation isKindOfClass:[MKUserLocation class]])
    return nil;
  
  NSString *annotationIdentifier = @"PinViewAnnotation";
  MEWMapAnnotationView * annotationView =
    (MEWMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
  if (!annotationView) {
    annotationView = [[[MEWMapAnnotationView alloc] initWithAnnotation:annotation
                                                reuseIdentifier:annotationIdentifier] autorelease];
    annotationView.canShowCallout = YES;
    
//    UIImageView * houseIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kPMINIconRefresh]];
//    pinView.leftCalloutAccessoryView = houseIconView;
//    [houseIconView release];
  }
  else annotationView.annotation = annotation;
  
  return annotationView;
}

//- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
//  
//}

@end
