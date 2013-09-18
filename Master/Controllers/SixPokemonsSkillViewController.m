//
//  PokemonStatsViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsSkillViewController.h"

@interface SixPokemonsSkillViewController () {
 @private
  PokemonInfoLabelView * hpLabelView_;
  UIImageView          * hpBarTotal_;
  UIImageView          * hpBarLeft_;
  PokemonInfoLabelView * attackLabelView_;
  PokemonInfoLabelView * defenseLabelView_;
  PokemonInfoLabelView * spAttackLabelView_;
  PokemonInfoLabelView * spDefenseLabelView_;
  PokemonInfoLabelView * speedLabelView_;
  PokemonInfoLabelView * abilityLabelView_;
}

@property (nonatomic, strong) PokemonInfoLabelView * hpLabelView;
@property (nonatomic, strong) UIImageView          * hpBarTotal;
@property (nonatomic, strong) UIImageView          * hpBarLeft;
@property (nonatomic, strong) PokemonInfoLabelView * attackLabelView;
@property (nonatomic, strong) PokemonInfoLabelView * defenseLabelView;
@property (nonatomic, strong) PokemonInfoLabelView * spAttackLabelView;
@property (nonatomic, strong) PokemonInfoLabelView * spDefenseLabelView;
@property (nonatomic, strong) PokemonInfoLabelView * speedLabelView;
@property (nonatomic, strong) PokemonInfoLabelView * abilityLabelView;

@end


@implementation SixPokemonsSkillViewController

@synthesize hpLabelView        = hpLabelView_;
@synthesize hpBarTotal         = hpBarTotal_;
@synthesize hpBarLeft          = hpBarLeft_;
@synthesize attackLabelView    = attackLabelView_;
@synthesize defenseLabelView   = defenseLabelView_;
@synthesize spAttackLabelView  = spAttackLabelView_;
@synthesize spDefenseLabelView = spDefenseLabelView_;
@synthesize speedLabelView     = speedLabelView_;
@synthesize abilityLabelView   = abilityLabelView_;

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
  CGFloat const labelHeight = 30.f;
  
  CGRect  const dataViewFrame           = CGRectMake(10.f, 5.f, 300.f, self.view.frame.size.height - 5.f);
  CGRect  const HPBarFrame              = CGRectMake(0.f, 9.f, 160.f, 13.f);
  CGRect  const hpLabelViewFrame        = CGRectMake(170.f, 0.f, 130.f, labelHeight);
  CGRect  const attackLabelViewFrame    = CGRectMake(0.f, labelHeight, 300.f, labelHeight);
  CGRect  const defenseLabelViewFrame   = CGRectMake(0.f, labelHeight * 2, 300.f, labelHeight);
  CGRect  const spAttackLabelViewFrame  = CGRectMake(0.f, labelHeight * 3, 300.f, labelHeight);
  CGRect  const spDefenseLabelViewFrame = CGRectMake(0.f, labelHeight * 4, 300.f, labelHeight);
  CGRect  const speedLabelViewFrame     = CGRectMake(0.f, labelHeight * 5, 300.f, labelHeight);
  CGRect  const abilityLabelViewFrame   = CGRectMake(0.f, labelHeight * 6, 300.f, labelHeight);
  
  
  ///Data View in Center
  UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // HP Bar
  hpBarTotal_ = [[UIImageView alloc] initWithFrame:HPBarFrame];
  [hpBarTotal_ setImage:[UIImage imageNamed:kPMINPMHPBarBackground]];
  // HP Bar Left Part
  hpBarLeft_ = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, HPBarFrame.size.height)];
  [hpBarLeft_ setImage:[UIImage imageNamed:kPMINPMHPBar]];
  [hpBarTotal_ addSubview:hpBarLeft_];
  [dataView addSubview:hpBarTotal_];
  
  // HP
  hpLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:hpLabelViewFrame hasValueLabel:YES];
  [hpLabelView_ adjustNameLabelWidthWith:-40.f];
  [hpLabelView_.name setText:NSLocalizedString(@"PMSLabelHP", nil)];
  [hpLabelView_.value setTextColor:[GlobalRender textColorOrange]];
  [dataView addSubview:hpLabelView_];
  
  // Attack
  attackLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:attackLabelViewFrame hasValueLabel:YES];
  [attackLabelView_ adjustNameLabelWidthWith:80.f];
  [attackLabelView_.name  setText:NSLocalizedString(@"PMSLabelAttack", nil)];
  [dataView addSubview:attackLabelView_];
  
  // Defense
  defenseLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:defenseLabelViewFrame hasValueLabel:YES];
  [defenseLabelView_ adjustNameLabelWidthWith:80.f];
  [defenseLabelView_.name  setText:NSLocalizedString(@"PMSLabelDefense", nil)];
  [dataView addSubview:defenseLabelView_];
  
  // Sp. Attack
  spAttackLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:spAttackLabelViewFrame hasValueLabel:YES];
  [spAttackLabelView_ adjustNameLabelWidthWith:80.f];
  [spAttackLabelView_.name setText:NSLocalizedString(@"PMSLabelSpAttack", nil)];
  [dataView addSubview:spAttackLabelView_];
  
  // Sp. Defense
  spDefenseLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:spDefenseLabelViewFrame hasValueLabel:YES];
  [spDefenseLabelView_ adjustNameLabelWidthWith:80.f];
  [spDefenseLabelView_.name setText:NSLocalizedString(@"PMSLabelSpDefense", nil)];
  [dataView addSubview:spDefenseLabelView_];
  
  // Speed
  speedLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:speedLabelViewFrame hasValueLabel:YES];
  [speedLabelView_ adjustNameLabelWidthWith:80.f];
  [speedLabelView_.name setText:NSLocalizedString(@"PMSLabelSpeed", nil)];
  [dataView addSubview:speedLabelView_];
  
  // Ability
  abilityLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:abilityLabelViewFrame hasValueLabel:YES];
  [abilityLabelView_.name setText:NSLocalizedString(@"PMSLabelAbility", nil)];
  //  [dataView addSubview:abilityLabelView_];
  
  // Add Data View to |self.view| & Release it
  [self.view addSubview:dataView];
  
  
  NSArray * statsMax = [self.pokemon maxStatsInArray];
  NSInteger hpLeft = [self.pokemon.hp intValue];
  NSInteger hpTotal = [[statsMax objectAtIndex:0] intValue];
  [self.hpLabelView.value setText:[NSString stringWithFormat:@"%d / %d", hpLeft, hpTotal]];
  [self.hpBarLeft setFrame:CGRectMake(0.f, 0.f, 160.f * hpLeft / hpTotal, 13.f)];
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
  self.hpBarTotal         = nil;
  self.hpBarLeft          = nil;
  self.attackLabelView    = nil;
  self.defenseLabelView   = nil;
  self.spAttackLabelView  = nil;
  self.spDefenseLabelView = nil;
  self.speedLabelView     = nil;
  self.abilityLabelView   = nil;
}

@end
