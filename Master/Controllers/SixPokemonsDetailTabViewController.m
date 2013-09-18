//
//  SixPokemonsDetailTabViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/21/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "SixPokemonsDetailTabViewController.h"

#import "SixPokemonsInfoViewController.h"
#import "SixPokemonsMemoViewController.h"
#import "SixPokemonsSkillViewController.h"
#import "SixPokemonsMoveViewController.h"

#import <QuartzCore/QuartzCore.h>


@interface SixPokemonsDetailTabViewController () {
 @private
  TrainerTamedPokemon * pokemon_;
  BOOL                  withTopbar_;
}

@property (nonatomic, strong) TrainerTamedPokemon * pokemon;

@end


@implementation SixPokemonsDetailTabViewController

@synthesize pokemon = pokemon_;


- (id)initWithPokemon:(TrainerTamedPokemon *)pokemon
           withTopbar:(BOOL)withTopbar {
  self.pokemon = pokemon;
  withTopbar_  = withTopbar;
  NSString * title = [NSString stringWithFormat:@"%@ %@",
                      KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", [pokemon.sid intValue]]), nil),
                      NSLocalizedString(@"Info", nil)];
  self = [super initWithTitle:title
                   tabBarSize:CGSizeMake(kTabBarWdith, kTabBarHeight)
        tabBarBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTabBarBackground]]
                     itemSize:CGSizeMake(kTabBarItemSize, kTabBarItemSize)
                        arrow:[UIImage imageNamed:kPMINTabBarArrow]];
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  [super loadView];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINBackgroundBlack]]];
  
  // Constants
  CGFloat const imageHeight     = 150.f;
  CGFloat const imageWidth      = 150.f;
  
  CGFloat const labelHeight     = 30.f;
  CGFloat const labelWidth      = 80.f;
  
  CGFloat const nameLabelWidth  = 300.f - imageWidth;
  CGFloat const nameLabelHeight = imageHeight / 2 - labelHeight;
  
  CGRect  const imageContainerFrame = CGRectMake(10.f, 10.f, imageWidth, imageHeight);
  CGRect  const IDViewFrame         = CGRectMake(imageWidth + 20.f, 50.f, 300.f - imageWidth, imageHeight - 50.f);
  
  // Base information for Pokemon
  Pokemon * pokemonBaseInfo = self.pokemon.pokemon;
  
  ///Left Image View
  UIView * imageContainer = [[UIView alloc] initWithFrame:imageContainerFrame];
  [imageContainer setBackgroundColor:
   [UIColor colorWithPatternImage:[UIImage imageNamed:kPMINPMDetailImageBackgound]]];
  [imageContainer setOpaque:NO];
  
  // Image
  UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, imageWidth, imageHeight)];
  [imageView setUserInteractionEnabled:YES];
  [imageView setContentMode:UIViewContentModeCenter];
  [imageView setBackgroundColor:[UIColor clearColor]];
  [imageView setImage:pokemonBaseInfo.image];
  
  [imageContainer addSubview:imageView];
  [self.view addSubview:imageContainer];
  
  
  ///Right ID View
  UIView * IDView = [[UIView alloc] initWithFrame:IDViewFrame];
  
  // ID
  PokemonInfoLabelView * idLabelView = [PokemonInfoLabelView alloc];
  (void)[idLabelView initWithFrame:CGRectMake(0.f, 0.f, labelWidth / 2, labelHeight) hasValueLabel:NO];
  [idLabelView.name setText:[NSString stringWithFormat:@"#%.3d", [pokemonBaseInfo.sid intValue]]];
  [idLabelView.name.layer setShadowColor:[UIColor blackColor].CGColor];
  [idLabelView.name.layer setShadowOpacity:1.f];
  [idLabelView.name.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [idLabelView.name.layer setShadowRadius:0.f];
  [IDView addSubview:idLabelView];
  
  // Name
  UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, labelHeight, nameLabelWidth, nameLabelHeight)];
  [nameLabel setBackgroundColor:[UIColor clearColor]];
  [nameLabel setTextColor:[GlobalRender textColorOrange]];
  [nameLabel setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  [nameLabel setText:
    KYResourceLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", [pokemonBaseInfo.sid intValue]]), nil)];
  [nameLabel.layer setShadowColor:[UIColor blackColor].CGColor];
  [nameLabel.layer setShadowOpacity:1.f];
  [nameLabel.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [nameLabel.layer setShadowRadius:0.f];
  [IDView addSubview:nameLabel];
  
  // Gender
  UIImageView * genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90.f, 0.f, 32.f, 32.f)];
  [genderImageView setImage:
   [UIImage imageNamed:[NSString stringWithFormat:kPMINIconPMGender, [self.pokemon.gender intValue]]]];
  [IDView addSubview:genderImageView];
  
  // Add Right ID View to |self.view| & Release it
  [self.view addSubview:IDView];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Override

// Override |KYArcTabViewController|'s |-setup|
- (void)setup {
  // Set View Frame
  CGFloat marginTop = withTopbar_ ? kTopBarHeight + kKYStatusBarHeight : kKYStatusBarHeight;
  self.viewFrame = CGRectMake(0.f, 0.f, kViewWidth, kViewHeight - marginTop);
  
  // Add child view controllers to each tab
  SixPokemonsInfoViewController  * sixPokemonsInfoViewController;
  SixPokemonsMemoViewController  * sixPokemonsMemoViewController;
  SixPokemonsSkillViewController * sixPokemonsSkillViewController;
  SixPokemonsMoveViewController  * sixPokemonsMoveViewController;
  sixPokemonsInfoViewController  = [[SixPokemonsInfoViewController alloc]  initWithPokemon:self.pokemon];
  sixPokemonsMemoViewController  = [[SixPokemonsMemoViewController alloc]  initWithPokemon:self.pokemon];
  sixPokemonsSkillViewController = [[SixPokemonsSkillViewController alloc] initWithPokemon:self.pokemon];
  sixPokemonsMoveViewController  = [[SixPokemonsMoveViewController alloc]  initWithPokemon:self.pokemon];
  
  // Set child views' Frame
  CGRect childViewFrame =
    CGRectMake(0.f, kTopIDViewHeight, kViewWidth, kViewHeight - kTopIDViewHeight);
  [sixPokemonsInfoViewController.view  setFrame:childViewFrame];
  [sixPokemonsMemoViewController.view  setFrame:childViewFrame];
  [sixPokemonsSkillViewController.view setFrame:childViewFrame];
  [sixPokemonsMoveViewController.view  setFrame:childViewFrame];
  
  // Add child views as tab bar items
  self.tabBarItems = @[@{@"image"          : kPMINTabBarItemPMDetailInfo,
                         @"viewController" : sixPokemonsInfoViewController},
                       @{@"image"          : kPMINTabBarItem6PMsDetailMemo,
                         @"viewController" : sixPokemonsMemoViewController},
                       @{@"image"          : kPMINTabBarItem6PMsDetailSkill,
                         @"viewController" : sixPokemonsSkillViewController},
                       @{@"image"          : kPMINTabBarItem6PMsDetailMove,
                         @"viewController" : sixPokemonsMoveViewController}];
  
  // Release child view controllers
}

@end
