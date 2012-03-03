//
//  PoketchViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomTabViewController.h"

#import "GlobalConstants.h"

#import <QuartzCore/QuartzCore.h>


@interface CustomTabViewController () {
@private
  
}

- (void)moveView:(UIView *)view toLeft:(BOOL)toLeft;
- (CGFloat)angleForRatationWithItemIndex:(NSUInteger)itemIndex previousItemIndex:(NSUInteger)previousItemIndex;

@end


@implementation CustomTabViewController

@synthesize tabBar      = tabBar_;
@synthesize tabBarItems = tabBarItems_;
@synthesize viewFrame   = viewFrame_;

- (void)dealloc
{
  [tabBar_      release];
  [tabBarItems_ release];
  
  [super dealloc];
}

- (id)init {
  self = [super init];
  if (self) {
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
  
  UIView * view = [[UIView alloc] initWithFrame:self.viewFrame];
  self.view = view;
  [view release];
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainViewBackgroundBlack.png"]]];
  
  if (! [[UIApplication sharedApplication] isStatusBarHidden]) viewFrame_.size.height -= 22.0f;
  
  // Create a custom tab bar passing in the number of items,
  // the size of each item and setting ourself as the delegate
  tabBar_ = [[CustomTabBar alloc] initWithItemCount:self.tabBarItems.count
                                                size:CGSizeMake(kTabBarWdith / self.tabBarItems.count, kTabBarHeight)
                                                 tag:0
                                            delegate:self];
  
  tabBar_.frame = CGRectMake((320.0f - kTabBarWdith) / 2.0f,
                             self.viewFrame.size.height - kTabBarHeight,
                             kTabBarWdith,
                             kTabBarHeight);
  [self.view addSubview:tabBar_];
  
  // Select the first tab
  [tabBar_ selectItemAtIndex:0];
  [self touchDownAtItemAtIndex:0 withPreviousItemIndex:0];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Place the layout for view's layer
  for (int i = 0; i < [self.tabBarItems count]; ++i) {
    UIView * view = [[[self.tabBarItems objectAtIndex:i] objectForKey:@"viewController"] view];
    [view.layer setAnchorPoint:CGPointMake(0.5f, 1.0f)];
    [view.layer setPosition:CGPointMake(view.frame.size.width / 2, 480.0f)];
  }
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.tabBar      = nil;
  self.tabBarItems = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - PoketchTabBarDelegate

// Icon for each Tab Bar Item
- (UIImage *)iconFor:(NSUInteger)itemIndex {
  return [UIImage imageNamed:[[self.tabBarItems objectAtIndex:itemIndex] objectForKey:@"image"]];
}

- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex withPreviousItemIndex:(NSUInteger)previousItemIndex
{
  // if |angle > 0|, rotate to left
  CGFloat angle = [self angleForRatationWithItemIndex:itemIndex previousItemIndex:previousItemIndex];
  
  // Remove the current view controller's view
  UIView * currentView = [self.view viewWithTag:kPoketchSelectedViewControllerTag];
  if (itemIndex != previousItemIndex)
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       currentView.transform = CGAffineTransformRotate(currentView.transform, angle);
                       [currentView setAlpha:0.0];
                     }
                     completion:^(BOOL finished) {
                       [currentView removeFromSuperview];
                     }];
  else [currentView removeFromSuperview];
  
  
  // Get the right view controller
  UIViewController * viewController = [[self.tabBarItems objectAtIndex:itemIndex] objectForKey:@"viewController"];
  [viewController.view setTag:kPoketchSelectedViewControllerTag];
  if (itemIndex != previousItemIndex) {
    CGAffineTransform transform = CGAffineTransformIdentity;
    viewController.view.transform = CGAffineTransformRotate(transform, -angle);
    [viewController.view setAlpha:0.0f];
    [UIView animateWithDuration:0.3f
                          delay:0.3f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       [viewController.view setAlpha:1.0f];
                       viewController.view.transform = CGAffineTransformRotate(viewController.view.transform, angle);
                     }
                     completion:nil];
  }
  
  // Add the new view controller's view
  if ([viewController respondsToSelector:@selector(viewWillAppear:)])
    [viewController viewWillAppear:NO];
  
  [self.view insertSubview:viewController.view belowSubview:self.tabBar];
  
  if ([viewController respondsToSelector:@selector(viewDidAppear:)])
    [viewController viewDidAppear:NO];
}

#pragma mark - Private Methods

- (void)moveView:(UIView *)view toLeft:(BOOL)toLeft
{
  if (toLeft) {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       CGAffineTransform transform = 
                       CGAffineTransformMakeRotation(1);
                       [view setTransform:transform];
                     }
                     completion:nil];
  }
}

// Return angle (in redians) for rotation
- (CGFloat)angleForRatationWithItemIndex:(NSUInteger)itemIndex previousItemIndex:(NSUInteger)previousItemIndex
{
  CGFloat degree;
  switch ([self.tabBarItems count]) {
    case 2:
      degree = 45;
      break;
      
    case 3:
      degree = 35;
      break;
      
    case 4:
    default:
      degree = 25;
      break;
  }
  return degree * (NSInteger)(previousItemIndex - itemIndex) * M_PI / 180 ;
}

@end
