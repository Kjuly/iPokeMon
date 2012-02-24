//
//  PoketchViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 1/31/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PoketchTabViewController.h"

#import "GlobalConstants.h"
#import "PoketchSixPokemonsViewController.h"
#import "PoketchStepsViewController.h"

@implementation PoketchTabViewController

- (void)dealloc
{
  [super dealloc];
}

- (id)init {
  self = [super init];
  if (self) {
    // Set View Frame
    self.viewFrame = CGRectMake(0.0f, kMapViewHeight + kUtilityBarHeight, 320.0f, 480.0f - kMapViewHeight - kUtilityBarHeight);
    
    // Add child view controllers to each tab
    UIViewController * controller1 = [[UIViewController alloc] init];
    PoketchSixPokemonsViewController * poketchSixPokemonsViewController = [[PoketchSixPokemonsViewController alloc] init];
    PoketchStepsViewController       * poketchStepsViewController       = [[PoketchStepsViewController alloc] init];
    
    // Set child view's frame
    CGRect childViewFrame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f - kMapViewHeight - kUtilityBarHeight);
    [poketchSixPokemonsViewController.view setFrame:childViewFrame];
    [poketchStepsViewController.view setFrame:childViewFrame];
    
    self.tabBarItems = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PoketchTabBarIcon_Messages.png", @"image", controller1, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PoketchTabBarIcon_SixPokemons.png", @"image", poketchSixPokemonsViewController, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:@"PoketchTabBarIcon_Steps.png", @"image", poketchStepsViewController, @"viewController", nil],
                        nil];
    
    [controller1 release];
    [poketchSixPokemonsViewController release];
    [poketchStepsViewController release];
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)loadView
{
  [super loadView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

@end
