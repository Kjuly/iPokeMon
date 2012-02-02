//
//  PoketchViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PoketchTabViewController.h"

#import "../GlobalConstants.h"

@implementation PoketchTabViewController

@synthesize tabBar = tabBar_;
@synthesize tabBarItems = tabBarItems_;

// |self.view|'s Height & Width 
CGFloat viewWidth  = 320.0f;
CGFloat viewHeight = 480.0f - kMapViewHeight - kUtilityBarHeight;

- (void)dealloc
{
  [tabBar_ release];
  [tabBarItems_ release];
  
  [super dealloc];
}

- (id)init {
  self = [super init];
  if (self) {
    if (! [[UIApplication sharedApplication] isStatusBarHidden]) viewHeight -= 22.0f;
    
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
  
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                           kMapViewHeight + kUtilityBarHeight,
                                                           viewWidth,
                                                           viewHeight)];
  self.view = view;
  [view release];
  [self.view setBackgroundColor:[UIColor clearColor]];
  
  // Create a custom tab bar passing in the number of items,
  // the size of each item and setting ourself as the delegate
  tabBar_ = [[PoketchTabBar alloc] initWithItemCount:self.tabBarItems.count
                                                size:CGSizeMake(kPoketchTabBarWdith / self.tabBarItems.count, kPoketchTabBarHeight)
                                                 tag:0
                                            delegate:self];
  
  tabBar_.frame = CGRectMake((viewWidth - kPoketchTabBarWdith) / 2.0f,
                             viewHeight - kPoketchTabBarHeight - 10.0f,
                             kPoketchTabBarWdith,
                             kPoketchTabBarHeight);
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

// Icon for each Tab Bar Item
- (UIImage *)iconFor:(NSUInteger)itemIndex {
  return [UIImage imageNamed:[[self.tabBarItems objectAtIndex:itemIndex] objectForKey:@"image"]];
}

- (UIImage *)backgroundImage
{
  // Get the image that will form the top of the background
  UIImage * tabBarBackgroundImage = [UIImage imageNamed:@"PoketchTabBarBackground.png"];
  
  // Create a new image context
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(kPoketchTabBarWdith, kPoketchTabBarHeight), NO, 0.0f);
  
  // Create a stretchable image for the top of the background and draw it
  UIImage * stretchedTabBarBackgroundImage = [tabBarBackgroundImage stretchableImageWithLeftCapWidth:0.0f topCapHeight:0.0f];
  [stretchedTabBarBackgroundImage drawInRect:CGRectMake(0.0f, 0.0f, kPoketchTabBarWdith, kPoketchTabBarHeight)];
  
  // Draw a solid black color for the bottom of the background
//  [[UIColor colorWithWhite:0.95f alpha:1.0f] set];
//  CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0.0f, kPoketchTabBarHeight, kPoketchTabBarWdith, kPoketchTabBarHeight));
  
  // Generate a new image
  UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return resultImage;
}

// The background shown for selected tab bar items
- (UIImage *)backgroundImageForSelectedItem {
  return [UIImage imageNamed:@"PoketchTabBarBackgroundForSelectedItem.png"];
}

// The embossed-like image shown around a selected tab bar item
- (UIImage *)selectedItemImage
{
  CGSize tabBarItemSize = CGSizeMake(viewWidth / self.tabBarItems.count, kPoketchTabBarHeight);
  
  UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
  // Create a stretchable image using the TabBarSelection image but offset 4 pixels down
  [[[UIImage imageNamed:@"PoketchTabBarSelection.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:0] drawInRect:CGRectMake(0.0f, 0.0f, tabBarItemSize.width, tabBarItemSize.height)];  
  // Generate a new image
  UIImage * selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return selectedItemImage;
}

// The top arrow image
- (UIImage *)tabBarArrowImage {
  return [UIImage imageNamed:@"TabBarNipple.png"];
}

- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
  // Remove the current view controller's view
  UIView * currentView = [self.view viewWithTag:kPoketchSelectedViewControllerTag];
  [currentView removeFromSuperview];
  
  // Get the right view controller
  UIViewController * viewController = [[self.tabBarItems objectAtIndex:itemIndex] objectForKey:@"viewController"];
  [viewController.view setFrame:CGRectMake(0.0f, 0.0f, viewWidth, viewHeight - kPoketchTabBarHeight)];
  [viewController.view setTag:kPoketchSelectedViewControllerTag];
  
  // Add the new view controller's view
  if ([viewController respondsToSelector:@selector(viewWillAppear:)])
    [viewController viewWillAppear:NO];
  
  [self.view insertSubview:viewController.view belowSubview:self.tabBar];
  
  if ([viewController respondsToSelector:@selector(viewDidAppear:)])
    [viewController viewDidAppear:NO];
}

@end
