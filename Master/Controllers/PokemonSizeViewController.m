//
//  PokemonSizeViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonSizeViewController.h"

@implementation PokemonSizeViewController

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
  
  // Constants
  CGFloat const imageHeight = 150.f;
  CGFloat const labelHeight = 30.f;
  
//  CGRect  const sizeViewFrame    = CGRectMake(10.f, imageHeight + 15.f, 300.f, labelHeight);
  CGRect  const sizeViewFrame    = CGRectMake(10.f, imageHeight + 15.f + 30.f, 300.f, labelHeight);
  CGRect  const heightLabelFrame = CGRectMake(0.f, 0.f, 140.f, labelHeight);
  CGRect  const weightLabelFrame = CGRectMake(140.f, 0.f, 160.f, labelHeight);
  
  
  ///Size View
  UIView * sizeView = [[UIView alloc] initWithFrame:sizeViewFrame];
  
  // Heigth
  PokemonInfoLabelView * heightLabelView =
    [[PokemonInfoLabelView alloc] initWithFrame:heightLabelFrame hasValueLabel:YES];
  [heightLabelView.name  setText:NSLocalizedString(@"PMSLabelHeight", nil)];
  [heightLabelView.value setText:[NSString stringWithFormat:@"%.2f m",
                                  [[self.pokemon valueForKey:@"height"] floatValue]]];
  [sizeView addSubview:heightLabelView];
  
  // Weight
  PokemonInfoLabelView * weightLabelView =
    [[PokemonInfoLabelView alloc] initWithFrame:weightLabelFrame hasValueLabel:YES];
  [weightLabelView.name  setText:NSLocalizedString(@"PMSLabelWeight", nil)];
  [weightLabelView.value setText:[NSString stringWithFormat:@"%.2f kg",
                                  [[self.pokemon valueForKey:@"weight"] floatValue]]];
  [sizeView addSubview:weightLabelView];
  
  // Add Size View to |self.view| & Release it
  [self.view addSubview:sizeView];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

@end
