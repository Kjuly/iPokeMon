//
//  TrainerInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/11/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "TrainerInfoViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "GlobalRender.h"
#import "Trainer+DataController.h"


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
  
  [trainer_ release];
  
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
    trainer_ = [Trainer queryTrainerWithTrainerID:1];
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
  
  // Constants
  CGFloat const imageHeight       = 100.0f;
  CGFloat const imageWidth        = 100.0f;
  
  CGFloat const labelHeight       = 30.0f;
  CGFloat const labelWidth        = 105.0f;
  CGFloat const valueHeight       = 30.0f;
  CGFloat const valueWidth        = 300.0f - labelWidth;
  
  CGFloat const nameLabelWidth    = 300.0f - imageWidth;
  CGFloat const nameLabelHeight   = imageHeight / 2 - labelHeight;
  
  CGRect  const IDViewFrame       = CGRectMake(imageWidth + 25.0f, 30.0f, 300.0f - imageWidth, imageHeight - 50.0f);
  CGRect  const dataViewFrame     = CGRectMake(10.0f, imageHeight + 35.0f, 300.0f, 195.0f);
  
  
  ///Left Image View
  imageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(10.0f, 20.0f, imageWidth, imageHeight)];
  [imageView_ setUserInteractionEnabled:YES];
  [imageView_ setContentMode:UIViewContentModeCenter];
  [imageView_ setBackgroundColor:[UIColor clearColor]];
  [imageView_.layer setMasksToBounds:YES];
  [imageView_.layer setCornerRadius:5.0f];
  [self.view addSubview:imageView_];
  
  
  ///Right ID View
  IDView_ = [[UIView alloc] initWithFrame:IDViewFrame];
  
  // ID
  IDLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, IDView_.frame.size.width, labelHeight)];
  [IDLabel_ setBackgroundColor:[UIColor clearColor]];
  [IDLabel_ setTextColor:[GlobalRender textColorBlue]];
  [IDLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [IDView_ addSubview:IDLabel_];
  
  // Name
  nameLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight, nameLabelWidth, nameLabelHeight)];
  [nameLabel_ setBackgroundColor:[UIColor clearColor]];
  [nameLabel_ setLineBreakMode:UILineBreakModeWordWrap];
  [nameLabel_ setTextColor:[GlobalRender textColorOrange]];
  [nameLabel_ setFont:[GlobalRender textFontBoldInSizeOf:20.0f]];
  [nameLabel_ setNumberOfLines:0];
  [nameLabel_.layer setShadowColor:[nameLabel_.textColor CGColor]];
  [nameLabel_.layer setShadowOpacity:1.0f];
  [nameLabel_.layer setShadowOffset:CGSizeMake(0.0f, 1.0f)];
  [nameLabel_.layer setShadowRadius:1.0f];
  [IDView_ addSubview:nameLabel_];
  
  // Add Right ID View to |self.view| & Release it
  [self.view addSubview:IDView_];
  
  
  ///Data View in Center
  dataView_ = [[UIView alloc] initWithFrame:dataViewFrame];
  
  // Money
  moneyLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, labelWidth, labelHeight)];
  moneyValue_ = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, 0.0f, valueWidth, valueHeight)];
  [moneyLabel_ setBackgroundColor:[UIColor clearColor]];
  [moneyValue_ setBackgroundColor:[UIColor clearColor]];
  [moneyLabel_ setTextColor:[GlobalRender textColorBlue]];
  [moneyLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [moneyValue_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [moneyLabel_ setTextAlignment:UITextAlignmentRight];
  [moneyValue_ setTextAlignment:UITextAlignmentLeft];
  [dataView_ addSubview:moneyLabel_];
  [dataView_ addSubview:moneyValue_];
  
  // Pokedex
  pokedexLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight, labelWidth, labelHeight)];
  pokedexValue_ = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, labelHeight, valueWidth, valueHeight)];
  [pokedexLabel_ setBackgroundColor:[UIColor clearColor]];
  [pokedexValue_ setBackgroundColor:[UIColor clearColor]];
  [pokedexLabel_ setTextColor:[GlobalRender textColorBlue]];
  [pokedexLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [pokedexValue_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [pokedexLabel_ setTextAlignment:UITextAlignmentRight];
  [pokedexValue_ setTextAlignment:UITextAlignmentLeft];
  [dataView_ addSubview:pokedexLabel_];
  [dataView_ addSubview:pokedexValue_];
  
  // Badges
  badgesLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, labelHeight * 2, labelWidth, labelHeight)];
  badgesValue_ = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth, labelHeight * 2, valueWidth, valueHeight)];
  [badgesLabel_ setBackgroundColor:[UIColor clearColor]];
  [badgesValue_ setBackgroundColor:[UIColor clearColor]];
  [badgesLabel_ setTextColor:[GlobalRender textColorBlue]];
  [badgesLabel_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [badgesValue_ setFont:[GlobalRender textFontBoldInSizeOf:16.0f]];
  [badgesLabel_ setTextAlignment:UITextAlignmentRight];
  [badgesValue_ setTextAlignment:UITextAlignmentLeft];
  [dataView_ addSubview:badgesLabel_];
  [dataView_ addSubview:badgesValue_];
  
  // Adventure Started
  adventureStartedTimeLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                                         dataView_.frame.size.height - labelHeight,
                                                                         170.0f,
                                                                         labelHeight)];
  adventureStartedTimeValue_ = [[UILabel alloc] initWithFrame:CGRectMake(170.0f,
                                                                         dataView_.frame.size.height - labelHeight,
                                                                         130.0f,
                                                                         valueHeight)];
  [adventureStartedTimeLabel_ setBackgroundColor:[UIColor clearColor]];
  [adventureStartedTimeValue_ setBackgroundColor:[UIColor clearColor]];
  [adventureStartedTimeLabel_ setTextColor:[GlobalRender textColorBlue]];
  [adventureStartedTimeLabel_ setFont:[GlobalRender textFontBoldInSizeOf:13.0f]];
  [adventureStartedTimeValue_ setFont:[GlobalRender textFontBoldInSizeOf:13.0f]];
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
  
  [self.imageView setImage:[UIImage imageNamed:@"UserAvatar.png"]];
  [self.IDLabel setText:[NSString stringWithFormat:@"ID: #%.8d", [self.trainer.sid intValue]]];
  [self.adventureStartedTimeLabel setText:NSLocalizedString(@"kLabelAdventureStarted", nil)];
  [self.adventureStartedTimeValue setText:@"2012-01-22"];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Update |trainer_|'s data
  self.trainer = [Trainer queryTrainerWithTrainerID:1];
  
  // Set new data
  [self.nameLabel setText:self.trainer.name];
  [self.nameLabel sizeToFit];
  [self.moneyLabel   setText:NSLocalizedString(@"kLabelMoney", nil)];
  [self.moneyValue   setText:[NSString stringWithFormat:@"$ %d", [self.trainer.money intValue]]];
  [self.pokedexLabel setText:NSLocalizedString(@"kLabelPokedex", nil)];
  [self.pokedexValue setText:[NSString stringWithFormat:@"%d", [self.trainer.pokedex intValue]]];
  [self.badgesLabel  setText:NSLocalizedString(@"kLabelBadges", nil)];
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
