//
//  TrainerInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerInfoViewController.h"

#import "GlobalRender.h"
#import "TrainerCoreDataController.h"

#import <QuartzCore/QuartzCore.h>


@implementation TrainerInfoViewController

@synthesize trainer = trainer_;

@synthesize imageView    = imageView_;
@synthesize IDView       = IDView_;
@synthesize IDLabel      = IDLabel_;
@synthesize nameLabel    = nameLabel_;
@synthesize dataView     = dataView_;
@synthesize moneyLabel   = moneyLabel_;
@synthesize moneyValue   = moneyValue_;
@synthesize pokedexLabel = pokedexLabel_;
@synthesize pokedexValue = pokedexValue_;
@synthesize badgesLabel  = badgesLabel_;
@synthesize badgesValue  = badgesValue_;
@synthesize adventureStartedTimeLabel = adventureStartedTimeLabel_;
@synthesize adventureStartedTimeValue = adventureStartedTimeValue_;

- (void)dealloc
{
  [super dealloc];
  
  self.trainer = nil;
  
  [imageView_ release];
  [IDView_ release];
  [IDLabel_ release];
  [nameLabel_ release];
  [dataView_ release];
  [moneyLabel_ release];
  [moneyValue_ release];
  [pokedexLabel_ release];
  [pokedexValue_ release];
  [badgesLabel_ release];
  [badgesValue_ release];
  [adventureStartedTimeLabel_ release];
  [adventureStartedTimeValue_ release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.trainer = [TrainerCoreDataController sharedInstance];
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
  
  // Constants
  CGFloat const imageHeight       = 100.f;
  CGFloat const imageWidth        = 100.f;
  CGFloat const labelHeight       = 30.f;
  CGFloat const labelWidth        = 105.f;
  CGFloat const valueHeight       = 30.f;
  CGFloat const valueWidth        = 290.f - labelWidth;
  CGFloat const nameLabelWidth    = 290.f - imageWidth;
  CGFloat const nameLabelHeight   = imageHeight / 2 - labelHeight;
  
  CGRect  const IDViewFrame       = CGRectMake(imageWidth + 30.f, 30.f, 290.f - imageWidth, imageHeight - 50.f);
  CGRect  const dataViewFrame     = CGRectMake(15.f, imageHeight + 35.f, 290.f, 195.f);
  CGRect  const adventureStartedTimeLabelFrame =
    CGRectMake(0.f, dataViewFrame.size.height - labelHeight, 170.f, labelHeight);
  CGRect  const adventureStartedTimeValueFrame =
    CGRectMake(170.f, dataViewFrame.size.height - labelHeight, 130.f, valueHeight);
  
  
  ///Left Image View
  imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 20.f, imageWidth, imageHeight)];
  [imageView_ setUserInteractionEnabled:YES];
  [imageView_ setContentMode:UIViewContentModeCenter];
  [imageView_ setBackgroundColor:[UIColor clearColor]];
  [imageView_.layer setMasksToBounds:YES];
  [imageView_.layer setCornerRadius:5.f];
  [self.view addSubview:imageView_];
  
  
  ///Right ID View
  IDView_ = [[UIView alloc] initWithFrame:IDViewFrame];
  
  // ID
  IDLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, IDView_.frame.size.width, labelHeight)];
  [IDLabel_ setBackgroundColor:[UIColor clearColor]];
  [IDLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [IDLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [IDLabel_.layer setShadowColor:[UIColor blackColor].CGColor];
  [IDLabel_.layer setShadowOpacity:1.f];
  [IDLabel_.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [IDLabel_.layer setShadowRadius:0.f];
  [IDView_ addSubview:IDLabel_];
  
  // Name
  nameLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight, nameLabelWidth, nameLabelHeight)];
  [nameLabel_ setBackgroundColor:[UIColor clearColor]];
  [nameLabel_ setLineBreakMode:UILineBreakModeWordWrap];
  [nameLabel_ setTextColor:[GlobalRender textColorOrange]];
  [nameLabel_ setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  [nameLabel_ setNumberOfLines:0];
  [nameLabel_.layer setShadowColor:[UIColor blackColor].CGColor];
  [nameLabel_.layer setShadowOpacity:1.f];
  [nameLabel_.layer setShadowOffset:CGSizeMake(-1.f, -1.f)];
  [nameLabel_.layer setShadowRadius:0.f];
  [IDView_ addSubview:nameLabel_];
  
  // Add Right ID View to |self.view| & Release it
  [self.view addSubview:IDView_];
  
  
  ///Data View in Center
  dataView_ = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // Money
  moneyLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, labelWidth, labelHeight)];
  moneyValue_ = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0.f, valueWidth, valueHeight)];
  [moneyLabel_ setBackgroundColor:[UIColor clearColor]];
  [moneyValue_ setBackgroundColor:[UIColor clearColor]];
  [moneyLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [moneyValue_ setTextColor:[GlobalRender textColorNormal]];
  [moneyLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [moneyValue_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [moneyLabel_ setTextAlignment:UITextAlignmentRight];
  [moneyValue_ setTextAlignment:UITextAlignmentLeft];
  [dataView_ addSubview:moneyLabel_];
  [dataView_ addSubview:moneyValue_];
  
  // Pokedex
  pokedexLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.f, labelHeight, labelWidth, labelHeight)];
  pokedexValue_ = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, labelHeight, valueWidth, valueHeight)];
  [pokedexLabel_ setBackgroundColor:[UIColor clearColor]];
  [pokedexValue_ setBackgroundColor:[UIColor clearColor]];
  [pokedexLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [pokedexValue_ setTextColor:[GlobalRender textColorNormal]];
  [pokedexLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [pokedexValue_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [pokedexLabel_ setTextAlignment:UITextAlignmentRight];
  [pokedexValue_ setTextAlignment:UITextAlignmentLeft];
  [dataView_ addSubview:pokedexLabel_];
  [dataView_ addSubview:pokedexValue_];
  
  // Badges
  badgesLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.f, labelHeight * 2, labelWidth, labelHeight)];
  badgesValue_ = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, labelHeight * 2, valueWidth, valueHeight)];
  [badgesLabel_ setBackgroundColor:[UIColor clearColor]];
  [badgesValue_ setBackgroundColor:[UIColor clearColor]];
  [badgesLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [badgesValue_ setTextColor:[GlobalRender textColorNormal]];
  [badgesLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [badgesValue_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [badgesLabel_ setTextAlignment:UITextAlignmentRight];
  [badgesValue_ setTextAlignment:UITextAlignmentLeft];
  [dataView_ addSubview:badgesLabel_];
  [dataView_ addSubview:badgesValue_];
  
  // Adventure Started
  adventureStartedTimeLabel_ = [[UILabel alloc] initWithFrame:adventureStartedTimeLabelFrame];
  adventureStartedTimeValue_ = [[UILabel alloc] initWithFrame:adventureStartedTimeValueFrame];
  [adventureStartedTimeLabel_ setBackgroundColor:[UIColor clearColor]];
  [adventureStartedTimeValue_ setBackgroundColor:[UIColor clearColor]];
  [adventureStartedTimeLabel_ setTextColor:[GlobalRender textColorTitleWhite]];
  [adventureStartedTimeValue_ setTextColor:[GlobalRender textColorNormal]];
  [adventureStartedTimeLabel_ setFont:[GlobalRender textFontBoldInSizeOf:13.f]];
  [adventureStartedTimeValue_ setFont:[GlobalRender textFontBoldInSizeOf:13.f]];
  [adventureStartedTimeLabel_ setTextAlignment:UITextAlignmentRight];
  [adventureStartedTimeValue_ setTextAlignment:UITextAlignmentLeft];
  [dataView_ addSubview:adventureStartedTimeLabel_];
  [dataView_ addSubview:adventureStartedTimeValue_];
  
  // Add Data View to |self.view| & Release it
  [self.view addSubview:dataView_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.imageView setImage:[self.trainer avatar]];
  [self.IDLabel setText:[NSString stringWithFormat:@"ID: #%.8d", [self.trainer UID]]];
  [self.moneyLabel   setText:NSLocalizedString(@"PMSLabelMoney", nil)];
  [self.pokedexLabel setText:NSLocalizedString(@"PMSLabelPokedex", nil)];
  [self.adventureStartedTimeLabel setText:NSLocalizedString(@"PMSLabelAdventureStarted", nil)];
  NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm"];
  [self.adventureStartedTimeValue setText:[dateFormat stringFromDate:[self.trainer timeStarted]]];
  [dateFormat release];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Set new data
  [self.nameLabel setText:[self.trainer name]];
  [self.nameLabel sizeToFit];
  [self.moneyValue setText:[NSString stringWithFormat:@"$ %d", [self.trainer money]]];
  
  NSArray * tamedPokemonSeq = [[self.trainer pokedex] componentsSeparatedByString:@"1"];
  NSInteger pokedexValue = [tamedPokemonSeq count] >= 1 ? [tamedPokemonSeq count] - 1 : 0;
  [self.pokedexValue setText:[NSString stringWithFormat:@"%d", pokedexValue]];
  tamedPokemonSeq = nil;
  
  [self.badgesLabel  setText:NSLocalizedString(@"PMSLabelBadges", nil)];
  [self.badgesValue  setText:@"123"];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.imageView    = nil;
  self.IDView       = nil;
  self.IDLabel      = nil;
  self.nameLabel    = nil;
  self.dataView     = nil;
  self.moneyLabel   = nil;
  self.moneyValue   = nil;
  self.pokedexLabel = nil;
  self.pokedexValue = nil;
  self.badgesLabel  = nil;
  self.badgesValue  = nil;
  self.adventureStartedTimeLabel = nil;
  self.adventureStartedTimeValue = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
