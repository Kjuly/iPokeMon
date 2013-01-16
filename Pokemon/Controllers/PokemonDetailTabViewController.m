//
//  PokemonDetailTabViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/5/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonDetailTabViewController.h"

#import "Pokemon+DataController.h"
#import "PokemonInfoViewController.h"
#import "PokemonAreaViewController.h"
#import "PokemonSizeViewController.h"


@interface PokemonDetailTabViewController () {
 @private
  Pokemon * pokemon_;
}

@property (nonatomic, retain) Pokemon * pokemon;

@end


@implementation PokemonDetailTabViewController

@synthesize pokemon = pokemon_;

- (void)dealloc {
  self.pokemon = nil;
  [super dealloc];
}

- (id)initWithPokemonSID:(NSInteger)pokemonSID withTopbar:(BOOL)withTopbar {
  self = [super init];
  if (self) {
    [self setTitle:[NSString stringWithFormat:@"%@ %@",
                    NSLocalizedString(([NSString stringWithFormat:@"PMSName%.3d", pokemonSID]), nil),
                    NSLocalizedString(@"Info", nil)]];
    
    // Set View Frame
    CGFloat marginTop = withTopbar ? kTopBarHeight : 0.f;
    self.viewFrame = CGRectMake(0.f, 0.f, kViewWidth, kViewHeight - marginTop);
    
    self.pokemon = [Pokemon queryPokemonDataWithSID:pokemonSID];
    
    // Add child view controllers to each tab
    PokemonInfoViewController * pokemonInfoViewController;
    PokemonAreaViewController * pokemonAreaViewController;
    PokemonSizeViewController * pokemonSizeViewController;
    pokemonInfoViewController = [[PokemonInfoViewController alloc] initWithPokemon:self.pokemon];
    pokemonAreaViewController = [[PokemonAreaViewController alloc] initWithPokemonSID:pokemonSID];
    pokemonSizeViewController = [[PokemonSizeViewController alloc] initWithPokemon:self.pokemon];
    
    // Set child views' Frame
    CGRect childViewFrame = CGRectMake(0.f, 0.f, kViewWidth, kViewHeight);
    [pokemonInfoViewController.view setFrame:childViewFrame];
    [pokemonAreaViewController.view setFrame:childViewFrame];
    [pokemonSizeViewController.view setFrame:childViewFrame];
    
    // Add child views as tab bar items
    self.tabBarItems = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:kPMINTabBarItemPMDetailInfo, @"image", pokemonInfoViewController, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:kPMINTabBarItemPMDetailArea, @"image", pokemonAreaViewController, @"viewController", nil],
                        [NSDictionary dictionaryWithObjectsAndKeys:kPMINTabBarItemPMDetailSize, @"image", pokemonSizeViewController, @"viewController", nil],
                        nil];
    
    // Release child view controllers
    [pokemonInfoViewController release];
    [pokemonAreaViewController release];
    [pokemonSizeViewController release];
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)loadView {
  [super loadView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

@end
