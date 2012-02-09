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

@synthesize navigationBarBackgroundImage = navigationBarBackgroundImage_;

- (void)dealloc
{
  [navigationBarBackgroundImage_ release];
  
  [super dealloc];
}

// Class Method of |initWithRootViewController:|
// This one is perfect without any leak
+ (id)initWithRootViewController:(UIViewController *)rootViewController
    navigationBarBackgroundImage:(UIImage *)navigationBarBackgroundImage
{
  NSArray * bundleArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                        owner:self
                                                      options:nil];
  CustomNavigationController * navigationController  = [bundleArray objectAtIndex:0];
  bundleArray = nil;
  
  if (self) {
    NSLog(@"--- CustomNavigationController initWithRootViewController if(self) ---");
    navigationController.navigationBarBackgroundImage = navigationBarBackgroundImage;
    [navigationController pushViewController:rootViewController  animated:NO];
  }
  return navigationController;
}

// Instance Method of |initWithRootViewController:|
// This instance method will cause a leak with nib's retain
- (id)initWithRootViewController:(UIViewController *)rootViewController
{
  self = [super initWithRootViewController:rootViewController];
  if (self) {
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
  NSLog(@"--- CustomNavigationController loadView ---");
  [super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  NSLog(@"--- CustomNavigationController viewDidLoad ---");
  
  [super viewDidLoad];
  
  // Set Navigation Bar
  [(CustomNavigationBar *)self.navigationBar initNavigationBarWith:self.navigationBarBackgroundImage];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.navigationBarBackgroundImage = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Overwrited UINavigationController Methods

// Uses a horizontal slide transition.
// Has no effect if the view controller is already in the stack.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  // Set original |backButton| hidden to show custom |backButton|
  [viewController.navigationItem setHidesBackButton:YES];
  
  // If |viewCount| == 2, add |backButton| for previous view
  if (++((CustomNavigationBar *)self.navigationBar).viewCount == 2)
    [(CustomNavigationBar *)self.navigationBar addBackButtonForPreviousView];
  
  // Dispatch |UINavigationController|'s |pushViewController:animated:| method
  [super pushViewController:viewController animated:animated];
}

@end
