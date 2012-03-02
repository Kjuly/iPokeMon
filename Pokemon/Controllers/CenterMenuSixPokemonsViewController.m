//
//  CenterMenuSixPokemonsViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CenterMenuSixPokemonsViewController.h"
#import "GlobalNotificationConstants.h"

@implementation CenterMenuSixPokemonsViewController

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
  
  // Set Buttons' style in center menu view
  for (UIButton * button in [self.centerMenu subviews])
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"MainViewCenterMenuButton%d", button.tag]]
            forState:UIControlStateNormal];
  
  NSLog(@"Six... loadView");
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

@end
