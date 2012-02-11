//
//  TrainerCardViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/9/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerCardViewController.h"

#import "../GlobalConstants.h"
#import "TrainerInfoViewController.h"
#import "TrainerBadgesTableViewController.h"

@implementation TrainerCardViewController

- (void)dealloc
{
  [super dealloc];
}

- (id)init {
  self = [super init];
  if (self) {
    // Set View Frame
    self.viewFrame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
    
    // Add child view controllers to each tab
    TrainerInfoViewController        * trainerInfoViewController        = [[TrainerInfoViewController alloc] init];
    TrainerBadgesTableViewController * trainerBadgesTableViewController = [[TrainerBadgesTableViewController alloc] init];
    
    CGRect childViewFrame = CGRectMake(0.0f, kTopBarHeight, 320.0f, 480.0f - kTopBarHeight);
    [trainerInfoViewController.view setFrame:childViewFrame];
    [trainerBadgesTableViewController.view setFrame:childViewFrame];
    
    self.tabBarItems = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"TrainerCardTabIcon_Info.png",   @"image", trainerInfoViewController,        @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"TrainerCardTabIcon_Badges.png", @"image", trainerBadgesTableViewController, @"viewController", nil],
                        nil];
    
    [trainerInfoViewController   release];
    [trainerBadgesTableViewController release];
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
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
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if (self.navigationController.isNavigationBarHidden)
    [self.navigationController setNavigationBarHidden:NO];
}

@end
