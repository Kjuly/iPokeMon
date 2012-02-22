//
//  PokemonInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsInfoViewController.h"

@implementation SixPokemonsInfoViewController

@synthesize levelLabelView       = levelLabelView_;
@synthesize expLabelView         = expLabelView_;
@synthesize toNextLevelLabelView = toNextLevelLabelView_;

- (void)dealloc
{
  [levelLabelView_       release];
  [expLabelView_         release];
  [toNextLevelLabelView_ release];
  
  [super dealloc];
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
  
  // Constants
  CGFloat const labelHeight = 30.0f;
  
  CGRect  const dataViewFrame      = CGRectMake(10.0f, 15.0f, 300.0f, 60.0f);
  CGRect  const levelLabelViewFrame = CGRectMake(0.0f, 0.0f, 140.0f, labelHeight);
  CGRect  const genderLabelViewFrame = CGRectMake(140.0f, 0.0f, 160.0f, labelHeight);
  CGRect  const typeLabelViewFrame = CGRectMake(0.0f, labelHeight, 300.0f, labelHeight);
  CGRect  const expLabelViewFrame  = CGRectMake(0.0f, labelHeight * 2, 300.0f, labelHeight);
  CGRect  const toNextLevelLabelViewFrame = CGRectMake(0.0f, labelHeight * 3, 300.0f, labelHeight);
  
  
  // Base information for Pokemon
  Pokemon * pokemonBaseInfo = self.pokemon.pokemon;
  
  ///Data View in Center
  UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // Level
  levelLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:levelLabelViewFrame hasValueLabel:YES];
  [levelLabelView_.name setText:NSLocalizedString(@"kLabelLevel", nil)];
  [dataView addSubview:levelLabelView_];
  
  // Gender
  PokemonInfoLabelView * genderLabelView = [[PokemonInfoLabelView alloc] initWithFrame:genderLabelViewFrame hasValueLabel:YES];
  [genderLabelView.name  setText:NSLocalizedString(@"kLabelGender", nil)];
  [genderLabelView.value setText:[self.pokemon.gender intValue] ? @"M" : @"F"];
  [dataView addSubview:genderLabelView];
  [genderLabelView release];
  
  // Type
  PokemonInfoLabelView * typeLabelView = [[PokemonInfoLabelView alloc] initWithFrame:typeLabelViewFrame hasValueLabel:YES];
  [typeLabelView.name  setText:NSLocalizedString(@"kLabelType", nil)];
  [typeLabelView.value setText:[pokemonBaseInfo.type1 stringValue]];
  [dataView addSubview:typeLabelView];
  [typeLabelView release];
  
  // EXP
  expLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:expLabelViewFrame hasValueLabel:YES];
  [expLabelView_.name setFont:[GlobalRender textFontBoldInSizeOf:12.0f]];
  [expLabelView_.name setText:NSLocalizedString(@"kLabelEXP", nil)];
  [dataView addSubview:expLabelView_];
  
  // To Next Level
  toNextLevelLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:toNextLevelLabelViewFrame hasValueLabel:YES];
  [toNextLevelLabelView_.name setFont:[GlobalRender textFontBoldInSizeOf:12.0f]];
  [toNextLevelLabelView_.name setText:NSLocalizedString(@"kLabelToNextLevel", nil)];
  [dataView addSubview:toNextLevelLabelView_];
  
  // Add Data View to |self.view| & Release it
  [self.view addSubview:dataView];
  [dataView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.levelLabelView       = nil;
  self.expLabelView         = nil;
  self.toNextLevelLabelView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self.levelLabelView.value       setText:[self.pokemon.level stringValue]];
  [self.expLabelView.value         setText:[self.pokemon.currEXP stringValue]];
  [self.toNextLevelLabelView.value setText:[self.pokemon.toNextLevel stringValue]];
}

@end
