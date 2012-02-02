//
//  CustomNavigationViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomNavigationController.h"

#import "CustomNavigationBar.h"

@implementation CustomNavigationController

@synthesize delegate = delegate_;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
  self = [[[NSBundle mainBundle] loadNibNamed:@"CustomNavigationController" owner:self options:nil] lastObject];
  if (self) {
    delegate_ = (id <CustomNavigationControllerDelegate>)rootViewController;
    [self pushViewController:rootViewController animated:NO];
  }
  
  return self;
}

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
  
  // Set Navigation Bar
  [(CustomNavigationBar *)self.navigationBar initNavigationBarWith:[delegate_ navigationBarBackgroundImage]];
  if (! [self.delegate hasNavigationBar])
    [self setNavigationBarHidden:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.delegate = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
