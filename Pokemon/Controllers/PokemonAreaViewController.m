//
//  PokemonAreaViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonAreaViewController.h"

@implementation PokemonAreaViewController

@synthesize mapView = mapView_;

- (void)dealloc {
  self.mapView = nil;
  [super dealloc];
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
  
  // Google Map View
  CGRect mapViewFrame = self.view.frame;
  mapViewFrame.origin.y = -kNavigationBarBottomAlphaHegiht;
  MKMapView * mapView = [[MKMapView alloc] initWithFrame:mapViewFrame];
  self.mapView = mapView;
  [mapView release];
  [self.view addSubview:self.mapView];
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

@end
