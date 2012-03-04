//
//  PokemonStatsViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsSkillViewController.h"

@implementation SixPokemonsSkillViewController

@synthesize hpLabelView        = hpLabelView_;
@synthesize attackLabelView    = attackLabelView_;
@synthesize defenseLabelView   = defenseLabelView_;
@synthesize spAttackLabelView  = spAttackLabelView_;
@synthesize spDefenseLabelView = spDefenseLabelView_;
@synthesize speedLabelView     = speedLabelView_;
@synthesize abilityLabelView   = abilityLabelView_;

- (void)dealloc
{
  [hpLabelView_        release];
  [attackLabelView_    release];
  [defenseLabelView_   release];
  [spAttackLabelView_  release];
  [spDefenseLabelView_ release];
  [speedLabelView_     release];
  [abilityLabelView_   release];
  
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
  
  CGRect  const dataViewFrame           = CGRectMake(10.0f, 15.0f, 300.0f, 60.0f);
  CGRect  const hpLabelViewFrame        = CGRectMake(0.0f, 0.0f, 140.0f, labelHeight);
  CGRect  const attackLabelViewFrame    = CGRectMake(140.0f, 0.0f, 160.0f, labelHeight);
  CGRect  const defenseLabelViewFrame   = CGRectMake(0.0f, labelHeight, 300.0f, labelHeight);
  CGRect  const spAttackLabelViewFrame  = CGRectMake(0.0f, labelHeight * 2, 300.0f, labelHeight);
  CGRect  const spDefenseLabelViewFrame = CGRectMake(0.0f, labelHeight * 3, 300.0f, labelHeight);
  CGRect  const speedLabelViewFrame     = CGRectMake(0.0f, labelHeight * 4, 300.0f, labelHeight);
  CGRect  const abilityLabelViewFrame   = CGRectMake(0.0f, labelHeight * 5, 300.0f, labelHeight);
  
  
  ///Data View in Center
  UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // HP
  hpLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:hpLabelViewFrame hasValueLabel:YES];
  [hpLabelView_.name setText:NSLocalizedString(@"PMSLabelHP", nil)];
  [dataView addSubview:hpLabelView_];
  
  // Attack
  attackLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:attackLabelViewFrame hasValueLabel:YES];
  [attackLabelView_.name  setText:NSLocalizedString(@"PMSLabelAttack", nil)];
  [dataView addSubview:attackLabelView_];
  
  // Defense
  defenseLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:defenseLabelViewFrame hasValueLabel:YES];
  [defenseLabelView_.name  setText:NSLocalizedString(@"PMSLabelDefense", nil)];
  [dataView addSubview:defenseLabelView_];
  
  // Sp. Attack
  spAttackLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:spAttackLabelViewFrame hasValueLabel:YES];
  [spAttackLabelView_.name setText:NSLocalizedString(@"PMSLabelSpAttack", nil)];
  [dataView addSubview:spAttackLabelView_];
  
  // Sp. Defense
  spDefenseLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:spDefenseLabelViewFrame hasValueLabel:YES];
  [spDefenseLabelView_.name setText:NSLocalizedString(@"PMSLabelSpDefense", nil)];
  [dataView addSubview:spDefenseLabelView_];
  
  // Speed
  speedLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:speedLabelViewFrame hasValueLabel:YES];
  [speedLabelView_.name setText:NSLocalizedString(@"PMSLabelSpeed", nil)];
  [dataView addSubview:speedLabelView_];
  
  // Ability
  abilityLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:abilityLabelViewFrame hasValueLabel:YES];
  [abilityLabelView_.name setText:NSLocalizedString(@"PMSLabelAbility", nil)];
  [dataView addSubview:abilityLabelView_];
  
  // Add Data View to |self.view| & Release it
  [self.view addSubview:dataView];
  [dataView release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSArray * statsMax;
  if ([self.pokemon.maxStats isKindOfClass:[NSString class]])
    statsMax  = [self.pokemon.maxStats  componentsSeparatedByString:@","];
  else
    statsMax  = self.pokemon.maxStats;
  
  [self.hpLabelView.value setText:[NSString stringWithFormat:@"%d/%d",
                                  [self.pokemon.currHP intValue], [[statsMax objectAtIndex:0] intValue]]];
  [self.attackLabelView.value    setText:[statsMax objectAtIndex:1]];
  [self.defenseLabelView.value   setText:[statsMax objectAtIndex:2]];
  [self.spAttackLabelView.value  setText:[statsMax objectAtIndex:3]];
  [self.spDefenseLabelView.value setText:[statsMax objectAtIndex:4]];
  [self.speedLabelView.value     setText:[statsMax objectAtIndex:5]];
  [self.abilityLabelView.value   setText:[self.pokemon.pokemon.ability1 stringValue]];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.hpLabelView        = nil;
  self.attackLabelView    = nil;
  self.defenseLabelView   = nil;
  self.spAttackLabelView  = nil;
  self.spDefenseLabelView = nil;
  self.speedLabelView     = nil;
  self.abilityLabelView   = nil;
}

@end
