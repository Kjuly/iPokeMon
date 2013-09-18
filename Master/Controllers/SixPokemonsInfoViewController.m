//
//  PokemonInfoViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/6/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsInfoViewController.h"

@interface SixPokemonsInfoViewController () {
 @private
  PokemonInfoLabelView * levelLabelView_;
  PokemonInfoLabelView * expLabelView_;
  PokemonInfoLabelView * toNextLevelLabelView_;
  UIImageView * expBarTotal_;
  UIImageView * expBarCurrntPoint_;
}

@property (nonatomic, strong) UIImageView * expBarTotal;
@property (nonatomic, strong) UIImageView * expBarCurrntPoint;
@property (nonatomic, strong) PokemonInfoLabelView * levelLabelView;
@property (nonatomic, strong) PokemonInfoLabelView * expLabelView;
@property (nonatomic, strong) PokemonInfoLabelView * toNextLevelLabelView;

@end


@implementation SixPokemonsInfoViewController

@synthesize levelLabelView       = levelLabelView_;
@synthesize expLabelView         = expLabelView_;
@synthesize toNextLevelLabelView = toNextLevelLabelView_;
@synthesize expBarTotal          = expBarTotal_;
@synthesize expBarCurrntPoint    = expBarCurrntPoint_;

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
  
  CGRect  const dataViewFrame       = CGRectMake(10.f, 5.f, 300.f, self.view.frame.size.height - 5.f);
  CGRect  const typeLabelViewFrame  = CGRectMake(0.f, 0.f, 300.f, labelHeight);
  CGRect  const levelLabelViewFrame = CGRectMake(0.f, labelHeight, 140.f, labelHeight);
  CGRect  const expLabelViewFrame   = CGRectMake(0.f, labelHeight * 2, 300.f, labelHeight);
  CGRect  const toNextLevelLabelViewFrame = CGRectMake(0.f, labelHeight * 3, 300.f, labelHeight);
  CGRect  const expBarTotalFrame    = CGRectMake(0.f, labelHeight * 4 + 10.f, 300.f, 6.f);
  
  // Base information for Pokemon
  Pokemon * pokemonBaseInfo = self.pokemon.pokemon;
  
  ///Data View in Center
  UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // Type
  PokemonInfoLabelView * typeLabelView =
    [[PokemonInfoLabelView alloc] initWithFrame:typeLabelViewFrame hasValueLabel:YES];
  [typeLabelView.name  setText:NSLocalizedString(@"PMSLabelType", nil)];
  NSString * types =
    KYResourceLocalizedString(([NSString stringWithFormat:@"PMSType%.2d", [pokemonBaseInfo.type1 intValue]]), nil);
  if ([pokemonBaseInfo.type2 intValue])
    types = [types stringByAppendingString:[NSString stringWithFormat:@", %@",
                                            KYResourceLocalizedString(([NSString stringWithFormat:@"PMSType%.2d",
                                                                        [pokemonBaseInfo.type2 intValue]]), nil)]];
  [typeLabelView.value setText:types];
  [dataView addSubview:typeLabelView];
  
  // Level
  levelLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:levelLabelViewFrame hasValueLabel:YES];
  [levelLabelView_.name setText:NSLocalizedString(@"PMSLabelLevel", nil)];
  [dataView addSubview:levelLabelView_];
  
  // EXP
  expLabelView_ = [[PokemonInfoLabelView alloc] initWithFrame:expLabelViewFrame hasValueLabel:YES];
  [expLabelView_ adjustNameLabelWidthWith:80.f];
  [expLabelView_.name setText:NSLocalizedString(@"PMSLabelEXP", nil)];
  [dataView addSubview:expLabelView_];
  
  // To Next Level
  toNextLevelLabelView_ =
    [[PokemonInfoLabelView alloc] initWithFrame:toNextLevelLabelViewFrame hasValueLabel:YES];
  [toNextLevelLabelView_ adjustNameLabelWidthWith:80.f];
  [toNextLevelLabelView_.name setText:NSLocalizedString(@"PMSLabelToNextLevel", nil)];
  [dataView addSubview:toNextLevelLabelView_];
  
  expBarTotal_ = [[UIImageView alloc] initWithFrame:expBarTotalFrame];
  [expBarTotal_ setImage:[UIImage imageNamed:kPMINPMExpBarBackground]];
  expBarCurrntPoint_ = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 0.f, expBarTotalFrame.size.height)];
  [expBarCurrntPoint_ setImage:[UIImage imageNamed:kPMINPMExpBar]];
  [expBarTotal_ addSubview:expBarCurrntPoint_];
  [dataView addSubview:expBarTotal_];
  
  // Add Data View to |self.view| & Release it
  [self.view addSubview:dataView];
  
  
  // Implement the completion block
  // iOS4 will not call |viewWillAppear:| when the VC is a child of another VC
  if (SYSTEM_VERSION_LESS_THAN(@"5.0"))
    [self viewWillAppear:YES];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.levelLabelView       = nil;
  self.expLabelView         = nil;
  self.toNextLevelLabelView = nil;
  self.expBarTotal          = nil;
  self.expBarCurrntPoint    = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self.levelLabelView.value       setText:[self.pokemon.level       stringValue]];
  [self.expLabelView.value         setText:[self.pokemon.exp         stringValue]];
  [self.toNextLevelLabelView.value setText:[self.pokemon.toNextLevel stringValue]];
  NSInteger exp         = [self.pokemon.exp intValue];
  NSInteger toNextLevel = [self.pokemon.toNextLevel intValue];
  CGFloat   expBarWith  = 300.f * abs(exp - toNextLevel) / (exp + toNextLevel);
  [self.expBarCurrntPoint setFrame:CGRectMake(0.f, 0.f, expBarWith, 6.f)];
}

@end
