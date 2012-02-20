//
//  PoketchStepsViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/13/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PoketchStepsViewController.h"

#import "GlobalRender.h"


@implementation PoketchStepsViewController

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
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  // Constans
  CGRect const stepsViewFrame  = CGRectMake(10.0f, 60.0f, 300.0f, 60.0f);
  CGRect const stepsLabelFrame = CGRectMake(0.0f, 10.0f, 100.0f, 50.0f);
  CGRect const stepsValueFrame = CGRectMake(100.0f, 0.0f, 200.0f, 60.0f);
  
  // Steps View
  UIView * stepsView = [[UIView alloc] initWithFrame:stepsViewFrame];
  
  // Steps Label
  UILabel * stepsLabel = [[UILabel alloc] initWithFrame:stepsLabelFrame];
  [stepsLabel setBackgroundColor:[UIColor clearColor]];
  [stepsLabel setTextColor:[GlobalRender textColorBlue]];
  [stepsLabel setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [stepsLabel setTextAlignment:UITextAlignmentRight];
  [stepsLabel setText:NSLocalizedString(@"kLabelSteps", nil)];
  [stepsView addSubview:stepsLabel];
  [stepsLabel release];
  
  // Steps Value
  UILabel * stepsValue = [[UILabel alloc] initWithFrame:stepsValueFrame];
  [stepsValue setBackgroundColor:[UIColor clearColor]];
  [stepsValue setTextColor:[GlobalRender textColorOrange]];
  [stepsValue setFont:[GlobalRender textFontBoldInSizeOf:20.0f]];
  [stepsValue setTextAlignment:UITextAlignmentLeft];
  [stepsValue setText:[NSString stringWithFormat:@"%d", 9999]];
  [stepsView addSubview:stepsValue];
  [stepsValue release];
  
  // Add |stepsView| to |self.view| & release it
  [self.view addSubview:stepsView];
  [stepsView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
