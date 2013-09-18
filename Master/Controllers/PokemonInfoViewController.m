//
//  PokemonInfoViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonInfoViewController.h"

@implementation PokemonInfoViewController

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
  
  CGRect  const speciesLabelViewFrame = (CGRect){CGPointZero, {300.f, labelHeight}};
  CGRect  const typeLabelViewFrame    = CGRectMake(0.f, labelHeight, 300.f, labelHeight);
  CGRect  const dataViewFrame     = CGRectMake(10.f, imageHeight + 15.f, 300.f, 60.f);
  CGRect  const descriptionFrame  = CGRectMake(10.f,
                                               imageHeight + dataViewFrame.size.height + 20.f,
                                               300.f,
                                               130.f);
  
  ///Data View in Center
  UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // Species
  PokemonInfoLabelView * speciesLabelView =
    [[PokemonInfoLabelView alloc] initWithFrame:speciesLabelViewFrame hasValueLabel:YES];
  [speciesLabelView.name  setText:NSLocalizedString(@"PMSLabelSpecies", nil)];
  [speciesLabelView.value setText:KYResourceLocalizedString(([NSString stringWithFormat:@"PMSSpecies%.3d",
                                                              [[self.pokemon valueForKey:@"species"] intValue]]), nil)];
  [dataView addSubview:speciesLabelView];
  
  // Type
  PokemonInfoLabelView * typeLabelView =
    [[PokemonInfoLabelView alloc] initWithFrame:typeLabelViewFrame hasValueLabel:YES];
  NSString * types = KYResourceLocalizedString(([NSString stringWithFormat:@"PMSType%.2d",
                                                 [self.pokemon.type1 intValue]]), nil);
  if ([self.pokemon.type2 intValue])
    types = [types stringByAppendingString:[NSString stringWithFormat:@", %@",
                                            KYResourceLocalizedString(([NSString stringWithFormat:@"PMSType%.2d",
                                                                        [self.pokemon.type2 intValue]]), nil)]];
  [typeLabelView.name  setText:NSLocalizedString(@"PMSLabelType", nil)];
  [typeLabelView.value setText:types];
  [dataView addSubview:typeLabelView];
  
  // Add Data View to |self.view| & Release it
  [self.view addSubview:dataView];
  
  
  ///Description
  UITextView * descriptionField = [[UITextView alloc] initWithFrame:descriptionFrame];
  [descriptionField setBackgroundColor:
   [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINPMDetailDescriptionBackground]]];
  [descriptionField setOpaque:NO];
  [descriptionField setEditable:NO];
  [descriptionField setFont:[GlobalRender textFontNormalInSizeOf:14.f]];
  [descriptionField setTextColor:[GlobalRender textColorNormal]];
  [descriptionField setText:
    KYResourceLocalizedString(([NSString stringWithFormat:@"PMSPMInfo%.3d", [self.pokemon.sid intValue]]), nil)];
  [self.view addSubview:descriptionField];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
