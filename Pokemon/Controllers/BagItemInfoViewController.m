//
//  BagItemInfoViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemInfoViewController.h"

#import "GlobalConstants.h"
#import "GlobalNotificationConstants.h"
#import "GlobalRender.h"


@interface BagItemInfoViewController () {
 @private
  BOOL                     isDuringBattle_;
  UIView                 * backgroundView_;
  UILabel                * name_;
  UILabel                * price_;
  UILabel                * info_;
  UITapGestureRecognizer * tapGestureRecognizer_;
}

@property (nonatomic, assign) BOOL                     isDuringBattle;
@property (nonatomic, retain) UIView                 * backgroundView;
@property (nonatomic, retain) UILabel                * name;
@property (nonatomic, retain) UILabel                * price;
@property (nonatomic, retain) UILabel                * info;
@property (nonatomic, retain) UITapGestureRecognizer * tapGestureRecognizer;

- (void)unloadViewWithAnimation;

@end


@implementation BagItemInfoViewController

@synthesize isDuringBattle       = isDuringBattle_;
@synthesize backgroundView       = backgroundView_;
@synthesize name                 = name_;
@synthesize price                = price_;
@synthesize info                 = info_;
@synthesize tapGestureRecognizer = tapGestureRecognizer_;

- (void)dealloc
{
  [backgroundView_       release];
  [name_                 release];
  [price_                release];
  [info_                 release];
  [tapGestureRecognizer_ release];
  
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, 480.f)];
  self.view = view;
  [view release];
  
  // Constants
  CGRect nameFrame  = CGRectMake(30.f, 60.f, 260.f, 32.f);
  CGRect priceFrame = CGRectMake(30.f, 92.f, 260.f, 32.f);
  CGRect infoFrame  = CGRectMake(30.f, 150.f, 260.f, 32.f);
  
  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:0.f];
  [self.view addSubview:backgroundView_];
  
  name_ = [[UILabel alloc] initWithFrame:nameFrame];
  [name_ setBackgroundColor:[UIColor clearColor]];
  [name_ setTextColor:[GlobalRender textColorTitleWhite]];
  [name_ setFont:[GlobalRender textFontBoldInSizeOf:18.f]];
  [self.view addSubview:name_];
  
  price_ = [[UILabel alloc] initWithFrame:priceFrame];
  [price_ setBackgroundColor:[UIColor clearColor]];
  [price_ setTextColor:[GlobalRender textColorTitleWhite]];
  [price_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [self.view addSubview:price_];
  
  info_ = [[UILabel alloc] initWithFrame:infoFrame];
  [info_ setBackgroundColor:[UIColor clearColor]];
  [info_ setTextColor:[GlobalRender textColorTitleWhite]];
  [info_ setFont:[GlobalRender textFontNormalInSizeOf:16.f]];
  [info_ setLineBreakMode:UILineBreakModeWordWrap];
  [info_ setNumberOfLines:0];
  [self.view addSubview:info_];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.isDuringBattle = NO;
  [self.name  setAlpha:0.f];
  [self.price setAlpha:0.f];
  [self.info  setAlpha:0.f];
  
  // Tap gesture recognizer
  UITapGestureRecognizer * tapGestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unloadViewWithAnimation)];
  self.tapGestureRecognizer = tapGestureRecognizer;
  [tapGestureRecognizer release];
  [self.tapGestureRecognizer setNumberOfTapsRequired:1];
  [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
  [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.backgroundView       = nil;
  self.name                 = nil;
  self.price                = nil;
  self.info                 = nil;
  self.tapGestureRecognizer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

- (void)setDataWithName:(NSString *)name
                  price:(NSInteger)price
                   info:(NSString *)info
           duringBattle:(BOOL)duringBattle
{
  self.isDuringBattle = duringBattle;
  [self.name setText:name];
  [self.price setText:(price ? [NSString stringWithFormat:@"$ %d", price] : @"- - -")];
  CGRect infoFrame  = CGRectMake(30.f, 150.f, 260.f, 32.f);
  [self.info setFrame:infoFrame];
  [self.info setText:info];
  [self.info sizeToFit];
}

- (void)loadViewWithAnimation {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.backgroundView setAlpha:.85f];
                     [self.name  setAlpha:1.f];
                     [self.price setAlpha:1.f];
                     [self.info  setAlpha:1.f];
                   }
                   completion:nil];
  if (self.isDuringBattle)
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNToggleTopCancelButton object:self userInfo:nil];
}

#pragma mark - Private Methods

- (void)unloadViewWithAnimation {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.view setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.view removeFromSuperview];
                     [self.view setAlpha:1.f];
                     [self.backgroundView setAlpha:0.f];
                     [self.name  setAlpha:0.f];
                     [self.price setAlpha:0.f];
                     [self.info  setAlpha:0.f];
                   }];
  if (self.isDuringBattle)
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNToggleTopCancelButton object:self userInfo:nil];
}

@end
