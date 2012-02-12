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
#import "GlobalColor.h"


@implementation PoketchSixPokemonsViewController

@synthesize dataArray  = dataArray_;
@synthesize imageArray = imageArray_;

- (void)dealloc
{
  [dataArray_  release];
  [imageArray_ release];
  
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
  dataArray_ = [[NSArray alloc] initWithObjects:
                [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:32], @"level", [NSNumber numberWithInt:60],  @"HPLeft", [NSNumber numberWithInt:220], @"HPTotal", @"Normal", @"state", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:21], @"level", [NSNumber numberWithInt:129], @"HPLeft", [NSNumber numberWithInt:190], @"HPTotal", @"Normal", @"state", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:37], @"level", [NSNumber numberWithInt:249], @"HPLeft", [NSNumber numberWithInt:270], @"HPTotal", @"Normal", @"state", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:31], @"level", [NSNumber numberWithInt:209], @"HPLeft", [NSNumber numberWithInt:209], @"HPTotal", @"Normal", @"state", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:49], @"level", [NSNumber numberWithInt:390], @"HPLeft", [NSNumber numberWithInt:420], @"HPTotal", @"Normal", @"state", nil],
                [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:51], @"level", [NSNumber numberWithInt:119], @"HPLeft", [NSNumber numberWithInt:512], @"HPTotal", @"Normal", @"state", nil],
                nil];
  
  CGFloat x      = 10.0f;
  CGFloat y      = 5.0f;
  CGFloat width  = 150.0f;
  CGFloat height = 60.0f;
  CGFloat imageWidth = 40.0f;
  CGRect pokemonViewFrame = CGRectZero;
  CGRect dataViewFrame    = CGRectMake(imageWidth, 0.0f, width - imageWidth, height);
  CGRect levelLabelFrame  = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
  CGRect HPLabelFrame     = CGRectMake(30.0f, 0.0f, dataViewFrame.size.width - 40.0f, 30.0f);
  CGRect HPBarFrame       = CGRectMake(0.0f, 30.0f, width - imageWidth - 10.0f, 15.0f);
  
  for (int i = 0; i < [self.dataArray count]; ++i) {
    pokemonViewFrame = CGRectMake(x + width * (i % 2), y + height * (int)(i / 2), width, height);
    UIView * pokemonView = [[UIView alloc] initWithFrame:pokemonViewFrame];
    
    // Image
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageWidth, height)];
    [imageView setContentMode:UIViewContentModeCenter | UIViewContentModeScaleAspectFit];
    [imageView setImage:[self.imageArray objectAtIndex:i]];
    [pokemonView addSubview:imageView];
    [imageView release];
    
    
    ///Data View
    UIView * dataView = [[UIView alloc] initWithFrame:dataViewFrame];
    NSDictionary * dataDict = [[NSDictionary alloc] initWithDictionary:[self.dataArray objectAtIndex:i]];
    
    // Level
    UILabel * levelLabel = [[UILabel alloc] initWithFrame:levelLabelFrame];
    [levelLabel setBackgroundColor:[UIColor clearColor]];
    [levelLabel setTextColor:[GlobalColor textColorBlue]];
    [levelLabel setTextAlignment:UITextAlignmentLeft];
    [levelLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:12.0f]];
    [levelLabel setText:[NSString stringWithFormat:@"Lv.%d", [[dataDict objectForKey:@"level"] intValue]]];
    [dataView addSubview:levelLabel];
    [levelLabel release];
    
    // HP
    UILabel * hpLabel = [[UILabel alloc] initWithFrame:HPLabelFrame];
    [hpLabel setBackgroundColor:[UIColor clearColor]];
    [hpLabel setTextColor:[GlobalColor textColorOrange]];
    [hpLabel setTextAlignment:UITextAlignmentRight];
    [hpLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.0f]];
    [hpLabel setText:[NSString stringWithFormat:@"%d/%d",
                      [[dataDict objectForKey:@"HPLeft"]  intValue],
                      [[dataDict objectForKey:@"HPTotal"] intValue]]];
    [dataView addSubview:hpLabel];
    [hpLabel release];
    
    // HP Bar
    UIView * HPBarTotal = [[UIView alloc] initWithFrame:HPBarFrame];
    [HPBarTotal setBackgroundColor:[GlobalColor textColorBlue]];
    [HPBarTotal.layer setCornerRadius:5.0f];
    // HP Bar Left Part
    CGRect HPBarLeftFrame = CGRectMake(0.0f,
                                       0.0f,
                                       HPBarFrame.size.width * [[dataDict objectForKey:@"HPLeft"]  floatValue] / [[dataDict objectForKey:@"HPTotal"] floatValue],
                                       HPBarFrame.size.height);
    UIView * HPBarLeft = [[UIView alloc] initWithFrame:HPBarLeftFrame];
    [HPBarLeft setBackgroundColor:[GlobalColor textColorOrange]];
    [HPBarLeft.layer setCornerRadius:5.0f];
    [HPBarTotal addSubview:HPBarLeft];
    [HPBarLeft release];
    
    [dataView addSubview:HPBarTotal];
    [HPBarTotal release];
    
    [dataDict release];
    
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
  
  self.dataArray  = nil;
  self.imageArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
