//
//  SixPokemonsDetailTabViewController.m
//  Pokemon
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
  SixPokemonsInfoViewController  * sixPokemonsInfoViewController_;
  SixPokemonsMemoViewController  * sixPokemonsMemoViewController_;
  SixPokemonsSkillViewController * sixPokemonsSkillViewController_;
  SixPokemonsMoveViewController  * sixPokemonsMoveViewController_;
}

@property (nonatomic, retain) TrainerTamedPokemon * pokemon;
@property (nonatomic, retain) SixPokemonsInfoViewController  * sixPokemonsInfoViewController;
@property (nonatomic, retain) SixPokemonsMemoViewController  * sixPokemonsMemoViewController;
@property (nonatomic, retain) SixPokemonsSkillViewController * sixPokemonsSkillViewController;
@property (nonatomic, retain) SixPokemonsMoveViewController  * sixPokemonsMoveViewController;

@end


@implementation SixPokemonsDetailTabViewController

@synthesize pokemon = pokemon_;
@synthesize sixPokemonsInfoViewController  = sixPokemonsInfoViewController_;
@synthesize sixPokemonsMemoViewController  = sixPokemonsMemoViewController_;
@synthesize sixPokemonsSkillViewController = sixPokemonsSkillViewController_;
@synthesize sixPokemonsMoveViewController  = sixPokemonsMoveViewController_;


-(void)dealloc {
  self.pokemon = nil;
  self.sixPokemonsInfoViewController  = nil;
  self.sixPokemonsMemoViewController  = nil;
  self.sixPokemonsSkillViewController = nil;
  self.sixPokemonsMoveViewController  = nil;
  [super dealloc];
}

- (id)initWithPokemon:(TrainerTamedPokemon *)pokemon
           withTopbar:(BOOL)withTopbar {
  self = [super init];
  if (self) {
    // Set View Frame
    CGFloat marginTop = withTopbar ? kTopBarHeight : 0.f;
    self.viewFrame = CGRectMake(0.f, 0.f, kViewWidth, kViewHeight - marginTop);
    self.pokemon = pokemon;
    
    // Add child view controllers to each tab
    sixPokemonsInfoViewController_  = [[SixPokemonsInfoViewController alloc]  initWithPokemon:self.pokemon];
    sixPokemonsMemoViewController_  = [[SixPokemonsMemoViewController alloc]  initWithPokemon:self.pokemon];
    sixPokemonsSkillViewController_ = [[SixPokemonsSkillViewController alloc] initWithPokemon:self.pokemon];
    sixPokemonsMoveViewController_  = [[SixPokemonsMoveViewController alloc]  initWithPokemon:self.pokemon];
    
    // Set child views' Frame
    CGRect childViewFrame =
      CGRectMake(0.f, kTopIDViewHeight, kViewWidth, kViewHeight - kTopIDViewHeight);
    [sixPokemonsInfoViewController_.view  setFrame:childViewFrame];
    [sixPokemonsMemoViewController_.view  setFrame:childViewFrame];
    [sixPokemonsSkillViewController_.view setFrame:childViewFrame];
    [sixPokemonsMoveViewController_.view  setFrame:childViewFrame];
    
    // Add child views as tab bar items
    self.tabBarItems = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:kPMINTabBarItemPMDetailInfo, @"image", sixPokemonsInfoViewController_, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:kPMINTabBarItem6PMsDetailMemo, @"image", sixPokemonsMemoViewController_, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:kPMINTabBarItem6PMsDetailSkill, @"image", sixPokemonsSkillViewController_, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:kPMINTabBarItem6PMsDetailMove, @"image", sixPokemonsMoveViewController_, @"viewController", nil],
                        nil];
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
  [imageView release];
  [self.view addSubview:imageContainer];
  [imageContainer release];
  
  
  ///Right ID View
  UIView * IDView = [[UIView alloc] initWithFrame:IDViewFrame];
  
  // ID
  PokemonInfoLabelView * idLabelView = [PokemonInfoLabelView alloc];
  [idLabelView initWithFrame:CGRectMake(0.f, 0.f, labelWidth / 2, labelHeight) hasValueLabel:NO];
  [idLabelView.name setText:[NSString stringWithFormat:@"#%.3d", [pokemonBaseInfo.sid intValue]]];
  [idLabelView.name.layer setShadowColor:[UIColor blackColor].CGColor];
  [idLabelView.name.layer setShadowOpacity:1.f];
  [idLabelView.name.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [idLabelView.name.layer setShadowRadius:0.f];
  [IDView addSubview:idLabelView];
  [idLabelView release];
  
  // Name
  UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, labelHeight, nameLabelWidth, nameLabelHeight)];
  [nameLabel setBackgroundColor:[UIColor clearColor]];
  [nameLabel setTextColor:[GlobalRender textColorOrange]];
  [nameLabel setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  [nameLabel setText:NSLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", [pokemonBaseInfo.sid intValue]]), nil)];
  [nameLabel.layer setShadowColor:[UIColor blackColor].CGColor];
  [nameLabel.layer setShadowOpacity:1.f];
  [nameLabel.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [nameLabel.layer setShadowRadius:0.f];
  [IDView addSubview:nameLabel];
  [nameLabel release];
  
  // Gender
  UIImageView * genderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(90.f, 0.f, 32.f, 32.f)];
  [genderImageView setImage:
   [UIImage imageNamed:[NSString stringWithFormat:kPMINIconPMGender, [self.pokemon.gender intValue]]]];
  [IDView addSubview:genderImageView];
  [genderImageView release];
  
  // Add Right ID View to |self.view| & Release it
  [self.view addSubview:IDView];
  [IDView release];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
