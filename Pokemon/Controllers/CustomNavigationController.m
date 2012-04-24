//
//  CustomNavigationViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomNavigationController.h"

#import "GlobalConstants.h"
#import "GlobalRender.h"


@implementation CustomNavigationController

- (void)dealloc {
  self.navigationBar.delegate = nil;
  [super dealloc];
}

- (id)init {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    NSLog(@"|%@| - INIT......", [self class]);
    CustomNavigationBar * customNavigationBar = [CustomNavigationBar alloc];
    [customNavigationBar initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kNavigationBarHeight)];
    customNavigationBar.delegate = self;
    [self setValue:customNavigationBar forKey:@"navigationBar"];
    [customNavigationBar release];
    [self setNavigationBarHidden:YES];
  }
  return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
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
- (void)loadView {
  [super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Overwrited UINavigationController Methods

// Uses a horizontal slide transition.
// Has no effect if the view controller is already in the stack.
- (void)pushViewController:(UIViewController *)viewController
                  animated:(BOOL)animated {
  // Set original |backButton| hidden to show custom |backButton|
  [viewController.navigationItem setHidesBackButton:YES];
  
  // If |viewCount| == 2, add |backButton| for previous view
  if (++((CustomNavigationBar *)self.navigationBar).viewCount == 2)
    [(CustomNavigationBar *)self.navigationBar addBackButtonForPreviousView];
  
  if (viewController.title) {
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 300.f, 32.f)];
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(300.f - 210.f, -15.f, 200.f, 32.f)];
    [title setBackgroundColor:[UIColor clearColor]];
    [title setTextColor:[GlobalRender textColorOrange]];
    [title setFont:[GlobalRender textFontBoldInSizeOf:18.f]];
    [title setTextAlignment:UITextAlignmentRight];
    [title setText:viewController.title];
    [titleView addSubview:title];
    [title release];
    [viewController.navigationItem setTitleView:titleView];
    [titleView release];
  }
  
  // Dispatch |UINavigationController|'s |pushViewController:animated:| method
  [super pushViewController:viewController animated:animated];
}

#pragma mark - CustomNavigationBar Delegate

- (void)hideNavigationBar:(BOOL)hide animated:(BOOL)animated {
  [self setNavigationBarHidden:hide animated:animated];
}

- (id)rootViewController {
  return self.topViewController;
}

- (void)backToRootViewAnimated:(BOOL)animated {
  [self popToRootViewControllerAnimated:animated];
}

- (void)backToPreviousViewAnimated:(BOOL)animated {
  [self popViewControllerAnimated:animated];
}

@end
