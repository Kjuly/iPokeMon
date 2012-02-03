//
//  CustomNavigationViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomNavigationController.h"

//#import "CustomNavigationBar.h"

@implementation CustomNavigationController

@synthesize delegate = delegate_;

- (void)dealloc
{
  [super dealloc];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
//  NSArray * bundleArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
//                                                        owner:self
//                                                      options:nil];
//  self = [bundleArray lastObject];
//  bundleArray = nil;
  
//  NSBundle * viewBundle = [NSBundle bundleForClass:([self class])];
//  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
//                                owner:self
//                              options:nil];
  
  if (self = [super initWithRootViewController:rootViewController]) {
    NSLog(@"--- CustomNavigationController initWithRootViewController if(self) ---");
    delegate_ = (id <CustomNavigationControllerDelegate>)rootViewController;
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
/*- (void)loadView
{
  NSLog(@"--- CustomNavigationController loadView ---");
  [super loadView];
}*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  NSLog(@"--- CustomNavigationController viewDidLoad ---");
  
  [super viewDidLoad];
  
  // Set Navigation Bar
//  [(CustomNavigationBar *)self.navigationBar initNavigationBarWith:[delegate_ navigationBarBackgroundImage]];
  [self.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
  
//  if (! [self.delegate hasNavigationBar])
//    [self setNavigationBarHidden:YES];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.delegate = nil;
  
  NSLog(@"--- CustomNavigationController viewDidUnload ---");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.

- (UIViewController *)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated; // Pops view controllers until the one specified is on top. Returns the popped controllers.
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated; // Pops until there's only a single view controller left on the stack. Returns the popped controllers.
 */

@end
