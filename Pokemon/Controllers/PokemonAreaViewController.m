//
//  PokemonAreaViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonAreaViewController.h"

#import "MKMapView+ZoomLevel.h"
#import "PMLocationManager.h"

@interface PokemonAreaViewController () {
 @private
  MKMapView  * mapView_;
  CLLocation * location_;
  
  NSInteger zoomLevel_;
}

@property (nonatomic, retain) MKMapView  * mapView;
@property (nonatomic, retain) CLLocation * location;

- (void)_releaseSubviews;

@end

@implementation PokemonAreaViewController

@synthesize mapView  = mapView_;
@synthesize location = location_;

- (void)dealloc {
  self.location = nil;
  [self _releaseSubviews];
  [super dealloc];
}

- (void)_releaseSubviews {
  self.mapView = nil;
}

- (id)initWithPokemonSID:(NSInteger)pokemonSID {
  self = [self init];
  if (self) {
  }
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
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
- (void)loadView {
  [super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  // basic settings
  zoomLevel_ = 3.f;
  
  // Google Map View
  CGRect mapViewFrame = self.view.frame;
  mapViewFrame.origin.y = -kNavigationBarBottomAlphaHegiht;
  MKMapView * mapView = [[MKMapView alloc] initWithFrame:mapViewFrame];
  [mapView setShowsUserLocation:YES];
  self.mapView = mapView;
  [mapView release];
  [self.mapView setDelegate:self];
  [self.view addSubview:self.mapView];
  
  // set default region with zoom level
  [self.mapView setCenterCoordinate:self.location.coordinate
                          zoomLevel:zoomLevel_
                           animated:YES];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self _releaseSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
