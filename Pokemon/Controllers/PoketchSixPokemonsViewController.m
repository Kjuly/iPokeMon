//
//  PoketchSixPokemonsViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/12/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PoketchSixPokemonsViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "PListParser.h"
#import "GlobalRender.h"
#import "Pokemon.h"
#import "TrainerTamedPokemon+DataController.h"


@implementation PoketchSixPokemonsViewController

@synthesize sixPokemons = sixPokemons_;
@synthesize imageArray  = imageArray_;

- (void)dealloc
{
  [sixPokemons_ release];
  [imageArray_  release];
  
  [super dealloc];
}

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
  
  NSString * IDSequence = @"0000000100020003000400050006";
  self.imageArray = [PListParser sixPokemonsImageArrayFor:IDSequence];
  self.sixPokemons = [TrainerTamedPokemon sixPokemonsForTrainer:1];
  
  CGFloat x      = 10.0f;
  CGFloat y      = 5.0f;
  CGFloat width  = 150.0f;
  CGFloat height = 60.0f;
  CGFloat imageWidth = 40.0f;
  CGRect pokemonViewFrame = CGRectZero;
  CGRect dataViewFrame    = CGRectMake(imageWidth, 0.0f, width - imageWidth, height);
  CGRect levelLabelFrame  = CGRectMake(0.0f, 0.0f, 40.0f, 30.0f);
  CGRect HPLabelFrame     = CGRectMake(35.0f, 0.0f, dataViewFrame.size.width - 45.0f, 30.0f);
  CGRect HPBarFrame       = CGRectMake(0.0f, 30.0f, width - imageWidth - 10.0f, 15.0f);
  
  for (int i = 0; i < [self.sixPokemons count]; ++i) {
    TrainerTamedPokemon * pokemonData = [self.sixPokemons objectAtIndex:i];
//    Pokemon * pokemonBaseInfo = pokemonData.pokemon;
    
    pokemonViewFrame = CGRectMake(x + width * (i % 2), y + height * (int)(i / 2), width, height);
    UIView * pokemonView = [[UIView alloc] initWithFrame:pokemonViewFrame];
    
    // Image
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageWidth, height)];
    [imageView setContentMode:UIViewContentModeCenter | UIViewContentModeScaleAspectFit];
//    [imageView setImage:pokemonBaseInfo.imageIcon];
    [imageView setImage:[self.imageArray objectAtIndex:i]];
    [pokemonView addSubview:imageView];
    [imageView release];
    
    
    ///Data View
    UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
    
    // Level
    UILabel * levelLabel = [[UILabel alloc] initWithFrame:levelLabelFrame];
    [levelLabel setBackgroundColor:[UIColor clearColor]];
    [levelLabel setTextColor:[GlobalRender textColorTitleWhite]];
    [levelLabel setTextAlignment:UITextAlignmentLeft];
    [levelLabel setFont:[GlobalRender textFontBoldItalicInSizeOf:12.0f]];
    [levelLabel setText:[NSString stringWithFormat:@"Lv.%d", [pokemonData.level intValue]]];
    [dataView addSubview:levelLabel];
    [levelLabel release];
    
    // HP
    UILabel * hpLabel = [[UILabel alloc] initWithFrame:HPLabelFrame];
    [hpLabel setBackgroundColor:[UIColor clearColor]];
    [hpLabel setTextColor:[GlobalRender textColorOrange]];
    [hpLabel setTextAlignment:UITextAlignmentRight];
    [hpLabel setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
    [hpLabel setText:[NSString stringWithFormat:@"%d/%d",
                      [pokemonData.currHP intValue],
                      [[pokemonData.maxStats objectAtIndex:0] intValue]]];
    [dataView addSubview:hpLabel];
    [hpLabel release];
    
    // HP Bar
    UIView * HPBarTotal = [[UIView alloc] initWithFrame:HPBarFrame];
    [HPBarTotal setBackgroundColor:[GlobalRender textColorTitleWhite]];
    [HPBarTotal.layer setCornerRadius:5.0f];
    // HP Bar Left Part
    CGRect HPBarLeftFrame = CGRectMake(0.0f,
                                       0.0f,
                                       HPBarFrame.size.width * [pokemonData.currHP  floatValue] / [[pokemonData.maxStats objectAtIndex:0] floatValue],
                                       HPBarFrame.size.height);
    UIView * HPBarLeft = [[UIView alloc] initWithFrame:HPBarLeftFrame];
    [HPBarLeft setBackgroundColor:[GlobalRender textColorOrange]];
    [HPBarLeft.layer setCornerRadius:5.0f];
    [HPBarTotal addSubview:HPBarLeft];
    [HPBarLeft release];
    
    [dataView addSubview:HPBarTotal];
    [HPBarTotal release];
    
    [pokemonView addSubview:dataView];
    [dataView release];
    
    [self.view addSubview:pokemonView];
    [pokemonView release];
  }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.sixPokemons = nil;
  self.imageArray  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
