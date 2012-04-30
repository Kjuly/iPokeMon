//
//  PoketchViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomTabViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface CustomTabViewController () {
 @private
  CustomTabBar * tabBar_;
  BOOL           isTabBarHide_;
  BOOL           isSwiping_;       // doing swiping
  CGFloat        swipeStartPoint_; // Value of the starting touch point's x location
}

@property (nonatomic, retain) CustomTabBar * tabBar;

- (CGFloat)angleForRatationWithItemIndex:(NSUInteger)itemIndex previousItemIndex:(NSUInteger)previousItemIndex;

@end


@implementation CustomTabViewController

@synthesize tabBar      = tabBar_;
@synthesize tabBarItems = tabBarItems_;
@synthesize viewFrame   = viewFrame_;

- (void)dealloc
{
  self.tabBar      = nil;
  self.tabBarItems = nil;
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMNToggleTabBar object:nil];
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
- (void)loadView {
  UIView * view = [[UIView alloc] initWithFrame:self.viewFrame];
  [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
  self.view = view;
  [view release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Create a custom tab bar passing in the number of items,
  // the size of each item and setting ourself as the delegate
  tabBar_ = [[CustomTabBar alloc] initWithItemCount:self.tabBarItems.count
                                               size:CGSizeMake(kTabBarWdith / [self.tabBarItems count], kTabBarHeight)
                                                tag:0
                                           delegate:self];
  [tabBar_ setFrame:
   CGRectMake((kViewWidth - kTabBarWdith) / 2.f, self.viewFrame.size.height, kTabBarWdith, kTabBarHeight)];
  [self.view addSubview:tabBar_];
  
  // Select the first tab
  [tabBar_ selectItemAtIndex:0];
  [self touchDownAtItemAtIndex:0 withPreviousItemIndex:0];
  
  isTabBarHide_ = YES;
  
  
  // Place the layout for view's layer
  for (int i = 0; i < [self.tabBarItems count]; ++i) {
    UIView * view = [[[self.tabBarItems objectAtIndex:i] objectForKey:@"viewController"] view];
    [view.layer setAnchorPoint:CGPointMake(.5f, 1.f)];
    [view.layer setPosition:CGPointMake(view.frame.size.width / 2, kViewHeight)];
  }
  
  // Notification for toggle tab bar
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(toggleTabBar:)
                                               name:kPMNToggleTabBar
                                             object:nil];
  
  // Implement the completion block
  // iOS4 will not call |viewWillAppear:| when the VC is a child of another VC
  if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    [self viewWillAppear:YES];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  self.tabBar      = nil;
  self.tabBarItems = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  // If |tabBar_| is hidden, show it
  if (isTabBarHide_)
    [self performSelector:@selector(toggleTabBar:) withObject:nil afterDelay:.6f];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Touch Actions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if ([touches count] != 1) return;
  UIView * currentView = [self.view viewWithTag:kPoketchSelectedViewControllerTag];
  swipeStartPoint_ = [[touches anyObject] locationInView:currentView].x;
  currentView = nil;
  isSwiping_ = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  if (! isSwiping_ || [touches count] != 1) return;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (! isSwiping_) return;
  UIView * currentView  = [self.view viewWithTag:kPoketchSelectedViewControllerTag];
  CGFloat swipeDistance = [[touches anyObject] locationInView:currentView].x - swipeStartPoint_;
  currentView = nil;
  NSInteger previousItemIndex = self.tabBar.previousItemIndex;
  
  // Swipe to left
  if (previousItemIndex > 0 && swipeDistance > 50.f) {
    UIButton * button = [self.tabBar.buttons objectAtIndex:previousItemIndex - 1];
    [self.tabBar touchDownAction:button];
    button = nil;
  }
  // Swipe to right
  else if (previousItemIndex < [self.tabBarItems count] - 1 && swipeDistance < -50.f) {
    UIButton * button = [self.tabBar.buttons objectAtIndex:previousItemIndex + 1];
    [self.tabBar touchDownAction:button];
    button = nil;
  }
  isSwiping_ = NO;
}

#pragma mark - PoketchTabBarDelegate

// Icon for each Tab Bar Item
- (UIImage *)iconFor:(NSUInteger)itemIndex {
  return [UIImage imageNamed:[[self.tabBarItems objectAtIndex:itemIndex] objectForKey:@"image"]];
}

- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex withPreviousItemIndex:(NSUInteger)previousItemIndex {
  // if |angle > 0|, rotate to left
  CGFloat angle = [self angleForRatationWithItemIndex:itemIndex previousItemIndex:previousItemIndex];
  
  // Remove the current view controller's view
  UIView * currentView = [self.view viewWithTag:kPoketchSelectedViewControllerTag];
  if (itemIndex != previousItemIndex)
    [UIView animateWithDuration:.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       currentView.transform = CGAffineTransformRotate(currentView.transform, angle);
                       [currentView setAlpha:0.f];
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
    [viewController.view setAlpha:0.f];
    [UIView animateWithDuration:.3f
                          delay:.3f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                       [viewController.view setAlpha:1.f];
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

#pragma mark - Public Methods

- (void)toggleTabBar:(NSNotification *)notification {
  CGRect tabBarFrame = self.tabBar.frame;
  if (isTabBarHide_) tabBarFrame.origin.y = self.viewFrame.size.height - kTabBarHeight;
  else               tabBarFrame.origin.y = self.viewFrame.size.height;
  
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{ [self.tabBar setFrame:tabBarFrame]; }
                   completion:^(BOOL finished) { isTabBarHide_ = ! isTabBarHide_; }];
}

#pragma mark - Private Methods

// Return angle (in redians) for rotation
- (CGFloat)angleForRatationWithItemIndex:(NSUInteger)itemIndex
                       previousItemIndex:(NSUInteger)previousItemIndex {
  CGFloat degree;
  switch ([self.tabBarItems count]) {
    case 2:
      degree = 12;
      break;
      
    case 3:
      degree = 10;
      break;
      
    case 4:
    default:
      degree = 8;
      break;
  }
  return degree * (NSInteger)(previousItemIndex - itemIndex) * M_PI / 180;
}

@end
