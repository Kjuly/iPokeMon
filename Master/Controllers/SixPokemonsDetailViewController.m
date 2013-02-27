//
//  PokemonInfoViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsDetailViewController.h"

@implementation SixPokemonsDetailViewController

@synthesize pokemon = pokemon_;

- (void)dealloc {
  self.pokemon = nil;
  [super dealloc];
}

- (id)initWithPokemon:(TrainerTamedPokemon *)pokemon {
  self = [self init];
  if (self) {
    self.pokemon = pokemon;
  }
  return self;
}

- (id)init {
  self = [super init];
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f,
                                                           kTopBarHeight + kTopIDViewHeight,
                                                           kViewWidth,
                                                           kViewHeight - kTopBarHeight - kTopIDViewHeight)];
  self.view = view;
  [view release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
