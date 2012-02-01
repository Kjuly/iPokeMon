//
//  PoketchViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PoketchTabViewController.h"

#define kSelectedViewControllerTag 98456345

@implementation PoketchTabViewController

@synthesize tabBar = tabBar_;
@synthesize tabBarItems = tabBarItems_;

- (void)dealloc
{
  [tabBar_ release];
  [tabBarItems_ release];
  
  [super dealloc];
}

- (id)init {
  self = [super init];
  if (self) {
//    [self setWantsFullScreenLayout:YES];
    
    // Add child view controllers to each tab
    UIViewController * controller1 = [[UIViewController alloc] init];
    [controller1.view setBackgroundColor:[UIColor blueColor]];
    UIViewController * controller2 = [[UIViewController alloc] init];
    UIViewController * controller3 = [[UIViewController alloc] init];
    [controller3.view setBackgroundColor:[UIColor redColor]];
    UIViewController * controller4 = [[UIViewController alloc] init];
    
    self.tabBarItems = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"Categories.png", @"image", controller1, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"MyDownload.png", @"image", controller2, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"WordList.png", @"image", controller3, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"Setting.png", @"image", controller4, @"viewController", nil], nil];
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
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 240.0f, 320.0f, 240.0f)];
  self.view = view;
  [view release];
  
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
  UIImage * tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
  
  // Create a custom tab bar passing in the number of items, the size of each item and setting ourself as the delegate
  tabBar_ = [[PoketchTabBar alloc] initWithItemCount:self.tabBarItems.count
                                            itemSize:CGSizeMake(self.view.frame.size.width / self.tabBarItems.count, tabBarGradient.size.height * 2)
                                                 tag:0
                                            delegate:self];
  
  // Place the tab bar at the bottom of our view
  tabBar_.frame = CGRectMake(0,
                             self.view.frame.size.height - (tabBarGradient.size.height * 2),
                             self.view.frame.size.width,
                             tabBarGradient.size.height * 2);
  [self.view addSubview:tabBar_];
  
  
  // Select the first tab
  [tabBar_ selectItemAtIndex:0];
  [self touchDownAtItemAtIndex:0];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.tabBar = nil;
  self.tabBarItems = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - PoketchTabBarDelegate

- (UIImage *)imageFor:(PoketchTabBar *)tabBar atIndex:(NSUInteger)itemIndex
{
  // Get the right data
  NSDictionary * data = [self.tabBarItems objectAtIndex:itemIndex];
  // Return the image for this tab bar item
  return [UIImage imageNamed:[data objectForKey:@"image"]];
}

- (UIImage *)backgroundImage
{
  // The tab bar's width is the same as our width
  CGFloat width = self.view.frame.size.width;
  // Get the image that will form the top of the background
  UIImage * topImage = [UIImage imageNamed:@"TabBarGradient.png"];
  
  // Create a new image context
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height * 2), NO, 0.0);
  
  // Create a stretchable image for the top of the background and draw it
  UIImage * stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
  [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
  
  // Draw a solid black color for the bottom of the background
  [[UIColor colorWithWhite:0.95f alpha:1.0f] set];
  CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height, width, topImage.size.height));
  
  // Generate a new image
  UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return resultImage;
}

// This is the blue background shown for selected tab bar items
- (UIImage *)selectedItemBackgroundImage
{
  return [UIImage imageNamed:@"TabBarItemSelectedBackground.png"];
}

// This is the glow image shown at the bottom of a tab bar to indicate there are new items
- (UIImage *)glowImage
{
  UIImage * tabBarGlow = [UIImage imageNamed:@"TabBarGlow.png"];
  
  // Create a new image using the TabBarGlow image but offset 4 pixels down
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(tabBarGlow.size.width, tabBarGlow.size.height - 4.0), NO, 0.0);
  
  // Draw the image
  [tabBarGlow drawAtPoint:CGPointZero];
  
  // Generate a new image
  UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return resultImage;
}

// This is the embossed-like image shown around a selected tab bar item
- (UIImage *)selectedItemImage
{
  // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
  UIImage * tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
  CGSize tabBarItemSize = CGSizeMake(self.view.frame.size.width / self.tabBarItems.count, tabBarGradient.size.height * 2);
  UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
  
  // Create a stretchable image using the TabBarSelection image but offset 4 pixels down
  [[[UIImage imageNamed:@"TabBarSelection.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:0] drawInRect:CGRectMake(0.0f, 0.0f, tabBarItemSize.width, tabBarItemSize.height)];  
  
  // Generate a new image
  UIImage * selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return selectedItemImage;
}

- (UIImage *)tabBarArrowImage
{
  return [UIImage imageNamed:@"TabBarNipple.png"];
}

- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
  // Remove the current view controller's view
  UIView * currentView = [self.view viewWithTag:kSelectedViewControllerTag];
  [currentView removeFromSuperview];
  
  // Get the right view controller
  NSDictionary * data = [self.tabBarItems objectAtIndex:itemIndex];
  UIViewController * viewController = [data objectForKey:@"viewController"];
  
  // Use the TabBarGradient image to figure out the tab bar's height (22x2=44)
  UIImage * tabBarGradient = [UIImage imageNamed:@"TabBarGradient.png"];
  
  // Set the view controller's frame to account for the tab bar
  viewController.view.frame = CGRectMake(0.0f,
                                         0.0f,
                                         self.view.bounds.size.width,
                                         self.view.bounds.size.height - (tabBarGradient.size.height * 2));
  
  // Se the tag so we can find it later
  viewController.view.tag = kSelectedViewControllerTag;
  
  // Add the new view controller's view
  if ([viewController respondsToSelector:@selector(viewWillAppear:)]) {
    [viewController viewWillAppear: NO];
  }
  [self.view insertSubview:viewController.view belowSubview:self.tabBar];
  if ([viewController respondsToSelector:@selector(viewDidAppear:)]) {
    [viewController viewDidAppear: NO];
  }
}

- (void)addGlowTimerFireMethod:(NSTimer *)theTimer
{
  // Remove the glow from all tab bar items
  for (NSUInteger i = 0 ; i < self.tabBarItems.count ; ++i)
    [self.tabBar removeGlowAtIndex:i];
  
  // Then add it to this tab bar item
  [self.tabBar glowItemAtIndex:[[theTimer userInfo] integerValue]];
}

@end
