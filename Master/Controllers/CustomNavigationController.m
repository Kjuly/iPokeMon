//
//  CustomNavigationViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomNavigationController.h"

#import "GlobalRender.h"


@interface CustomNavigationController ()

- (void)_setupNavigationBar;

@end


@implementation CustomNavigationController

- (void)dealloc
{
  self.navigationBar.delegate = nil;
}

- (id)init
{
  return (self = [super init]);
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
  // Setup navigation bar with the custom one before do initialization job
  // In iOS6, |-initWithRootViewController:| won't send |-init| message
  [self _setupNavigationBar];
  if (self = [super initWithRootViewController:rootViewController]) {
    
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
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view setFrame:(CGRect){CGPointZero, {kViewWidth, kViewHeight}}];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Method

// Setup |navigationBar|
- (void)_setupNavigationBar
{
  NSLog(@"...SETUP NavigationBar...");
  CustomNavigationBar * customNavigationBar = [CustomNavigationBar alloc];
  (void)[customNavigationBar initWithFrame:(CGRect){CGPointZero, {kViewWidth, kNavigationBarHeight}}];
  customNavigationBar.delegate   = self;
  customNavigationBar.dataSource = self;
  [self setValue:customNavigationBar forKey:@"navigationBar"];
  [self setNavigationBarHidden:YES];
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    [self.navigationBar setTranslucent:NO];
  }
}

#pragma mark - Overwrited UINavigationController Methods

// Uses a horizontal slide transition.
// Has no effect if the view controller is already in the stack.
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated
{
  // Set original |backButton| hidden to show custom |backButton|
  [viewController.navigationItem setHidesBackButton:YES];
       
  // If |viewCount| == 2, add |backButton| for previous view
  if (++((CustomNavigationBar *)self.navigationBar).viewCount == 2)
    [(CustomNavigationBar *)self.navigationBar addBackButtonForPreviousView];
  
  if (viewController.title) {
    UIView * titleView = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {300.f, 32.f}}];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(300.f - 210.f, -15.f, 200.f, 32.f)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextColor:[GlobalRender textColorOrange]];
    [title setFont:[GlobalRender textFontBoldInSizeOf:18.f]];
    [title setTextAlignment:NSTextAlignmentRight];
    [title setText:viewController.title];
    [titleView addSubview:title];
    [viewController.navigationItem setTitleView:titleView];
  }
  
  // Dispatch |UINavigationController|'s |pushViewController:animated:| method
  [super pushViewController:viewController animated:animated];
}

#pragma mark - CustomNavigationBar Delegate

- (void)customNavigationBarWillHide:(BOOL)hide
                           animated:(BOOL)animated
{
  [self setNavigationBarHidden:hide animated:animated];
}

- (void)customNavigationBarWillBackToRootAnimated:(BOOL)animated
{
  [self popToRootViewControllerAnimated:animated];
}

- (void)customNavigationBarWillBackToPreviousAnimated:(BOOL)animated
{
  [self popViewControllerAnimated:animated];
}

#pragma mark - CustomNavigationBar Data Source

- (id)rootViewController
{
  return self.topViewController;
}

@end
