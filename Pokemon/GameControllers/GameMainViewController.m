//
//  GameMainViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/24/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMainViewController.h"

#import "GlobalNotificationConstants.h"

@interface GameMainViewController ()

- (void)loadBattleScene:(NSNotification *)notification;

@end

@implementation GameMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
- (void)loadView
{
  [super loadView];
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(320.0f, 0.0f, 320.0f, 480.0f)];
  self.view = view;
  [view release];
  
  [self.view setBackgroundColor:[UIColor grayColor]];
  [self.view setAlpha:0.0f];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Add Notification Observer
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadBattleScene:)
                                               name:kPMNPokemonAppeared
                                             object:nil];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  // Remove Notification Observer
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNPokemonAppeared object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

- (void)loadBattleScene:(NSNotification *)notification
{
  NSLog(@"!!!!!!!!");
  [self.view setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
  [UIView animateWithDuration:0.3f
                        delay:0.0f
                      options:UIViewAnimationCurveEaseIn
                   animations:^{
                     [self.view setAlpha:1.0f];
                   }
                   completion:nil];
}

@end
