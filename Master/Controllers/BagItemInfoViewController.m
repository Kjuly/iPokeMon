//
//  BagItemInfoViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/19/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "BagItemInfoViewController.h"

#import "GlobalRender.h"

@interface BagItemInfoViewController () {
 @private
  UIView                 * backgroundView_;
  UILabel                * name_;
  UILabel                * price_;
  UILabel                * info_;
  UITapGestureRecognizer * tapGestureRecognizer_;
  
  BOOL                     isDuringBattle_;
}

@property (nonatomic, strong) UIView                 * backgroundView;
@property (nonatomic, strong) UILabel                * name;
@property (nonatomic, strong) UILabel                * price;
@property (nonatomic, strong) UILabel                * info;
@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;

- (void)_unloadViewWithAnimation;

@end


@implementation BagItemInfoViewController

@synthesize backgroundView       = backgroundView_;
@synthesize name                 = name_;
@synthesize price                = price_;
@synthesize info                 = info_;
@synthesize tapGestureRecognizer = tapGestureRecognizer_;

- (id)init
{
  return (self = [super init]);
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
  UIView * view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {kViewWidth, kViewHeight + 20.f}}];
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Constants
  CGRect nameFrame  = CGRectMake(30.f, 80.f, 260.f, 32.f);
  CGRect priceFrame = CGRectMake(30.f, 112.f, 260.f, 32.f);
  CGRect infoFrame  = CGRectMake(30.f, 170.f, 260.f, 32.f);
  
  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:0.f];
  [self.view addSubview:backgroundView_];
  
  name_ = [[UILabel alloc] initWithFrame:nameFrame];
  [name_ setBackgroundColor:[UIColor clearColor]];
  [name_ setTextColor:[GlobalRender textColorOrange]];
  [name_ setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
  [self.view addSubview:name_];
  
  price_ = [[UILabel alloc] initWithFrame:priceFrame];
  [price_ setBackgroundColor:[UIColor clearColor]];
  [price_ setTextColor:[GlobalRender textColorBlue]];
  [price_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [self.view addSubview:price_];
  
  info_ = [[UILabel alloc] initWithFrame:infoFrame];
  [info_ setBackgroundColor:[UIColor clearColor]];
  [info_ setTextColor:[GlobalRender textColorTitleWhite]];
  [info_ setFont:[GlobalRender textFontNormalInSizeOf:16.f]];
  [info_ setLineBreakMode:NSLineBreakByWordWrapping];
  [info_ setNumberOfLines:0];
  [self.view addSubview:info_];
  
  isDuringBattle_ = NO;
  [self.name  setAlpha:0.f];
  [self.price setAlpha:0.f];
  [self.info  setAlpha:0.f];
  
  // Tap gesture recognizer
  UITapGestureRecognizer * tapGestureRecognizer = [UITapGestureRecognizer alloc];
  (void)[tapGestureRecognizer initWithTarget:self action:@selector(_unloadViewWithAnimation)];
  self.tapGestureRecognizer = tapGestureRecognizer;
  [self.tapGestureRecognizer setNumberOfTapsRequired:1];
  [self.tapGestureRecognizer setNumberOfTouchesRequired:1];
  [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.backgroundView = nil;
  self.name           = nil;
  self.price          = nil;
  self.info           = nil;
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
  isDuringBattle_ = duringBattle;
  [self.name setText:name];
  [self.price setText:(price ? [NSString stringWithFormat:@"§ %d", price] : @"- - -")];
  CGRect infoFrame  = CGRectMake(30.f, 150.f, 260.f, 32.f);
  [self.info setFrame:infoFrame];
  [self.info setText:info];
  [self.info sizeToFit];
}

- (void)loadViewWithAnimation
{
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
  if (isDuringBattle_)
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNToggleTopCancelButton
                                                        object:self
                                                      userInfo:nil];
}

#pragma mark - Private Methods

- (void)_unloadViewWithAnimation
{
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
  if (isDuringBattle_)
    [[NSNotificationCenter defaultCenter] postNotificationName:kPMNToggleTopCancelButton object:self userInfo:nil];
}

@end
