//
//  NewTrainerGuideViewController.m
//  Pokemon
//
//  Created by Kaijie Yu on 4/3/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "NewbieGuideViewController.h"

#import "GlobalConstants.h"
#import "GlobalRender.h"
#import "TrainerController.h"


@interface NewbieGuideViewController () {
 @private
  TrainerController * trainer_;
  
  UIView   * backgroundView_;
  UILabel  * textView1_;
  UILabel  * textView2_;
  CGRect     textView1Frame_;
  CGRect     textView2Frame_;
  UIButton * confirmButton_;
  
  UITextView * nameInputView_;
}

@property (nonatomic, retain) TrainerController * trainer;

@property (nonatomic, retain) UIView   * backgroundView;
@property (nonatomic, retain) UILabel  * textView1;
@property (nonatomic, retain) UILabel  * textView2;
@property (nonatomic, assign) CGRect     textView1Frame;
@property (nonatomic, assign) CGRect     textView2Frame;
@property (nonatomic, retain) UIButton * confirmButton;

@property (nonatomic, retain) UITextView * nameInputView;

- (void)unloadViewAnimated:(BOOL)animated;
- (void)setTextViewWithText1:(NSString *)text1 text2:(NSString *)text2;

@end


@implementation NewbieGuideViewController

@synthesize trainer        = trainer_;

@synthesize backgroundView = backgroundView_;
@synthesize textView1      = textView1_;
@synthesize textView2      = textView2_;
@synthesize textView1Frame = textView1Frame_;
@synthesize textView2Frame = textView2Frame_;
@synthesize confirmButton  = confirmButton_;

@synthesize nameInputView  = nameInputView_;

- (void)dealloc
{
  self.trainer = nil;
  
  [backgroundView_ release];
  [textView1_      release];
  [textView2_      release];
  [confirmButton_  release];
  
  [nameInputView_  release];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.trainer = [TrainerController sharedInstance];
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  self.view = view;
  [view release];
  [self.view setAlpha:0.f];

  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:.85f];
  [self.view addSubview:backgroundView_];
  
  // Constants
  textView1Frame_ = CGRectMake(30.f, 60.f, 260.f, 40.f);
  textView2Frame_ = CGRectMake(30.f, 100.f, 260.f, 40.f);
  CGRect confirmButtonFrame =
    CGRectMake((kViewWidth - kCenterMainButtonSize) / 2, kViewHeight - 100.f, kCenterMainButtonSize, kCenterMainButtonSize);
  
  textView1_ = [[UILabel alloc] initWithFrame:textView1Frame_];
  [textView1_ setBackgroundColor:[UIColor clearColor]];
  [textView1_ setTextColor:[GlobalRender textColorTitleWhite]];
  [textView1_ setFont:[GlobalRender textFontNormalInSizeOf:18.f]];
  [textView1_ setLineBreakMode:UILineBreakModeWordWrap];
  [textView1_ setNumberOfLines:0];
  [self.view addSubview:textView1_];
  
  textView2_ = [[UILabel alloc] initWithFrame:textView2Frame_];
  [textView2_ setBackgroundColor:[UIColor clearColor]];
  [textView2_ setTextColor:[GlobalRender textColorTitleWhite]];
  [textView2_ setFont:[GlobalRender textFontNormalInSizeOf:18.f]];
  [textView2_ setLineBreakMode:UILineBreakModeWordWrap];
  [textView2_ setNumberOfLines:0];
  [self.view addSubview:textView2_];
  
  confirmButton_ = [[UIButton alloc] initWithFrame:confirmButtonFrame];
  [confirmButton_ setImage:[UIImage imageNamed:@"MainViewMapButtonImageNormal.png"] forState:UIControlStateNormal];
  [self.view addSubview:confirmButton_];
  
  // Layouts for different steps
  // Constants
  CGRect nameInputViewFrame = CGRectMake(30.f, (kViewHeight - 32.f) / 2.f, 260.f, 32.f);
  
  nameInputView_ = [[UITextView alloc] initWithFrame:nameInputViewFrame];
  [nameInputView_ setBackgroundColor:[UIColor whiteColor]];
  [nameInputView_ setTextColor:[UIColor blackColor]];
  [nameInputView_ setFont:[GlobalRender textFontBoldInSizeOf:16]];
  [nameInputView_ setKeyboardType:UIKeyboardTypeDefault];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self setTextViewWithText1:@"PMSNewbiewGuide1Text1" text2:@"PMSNewbiewGuide1Text2"];
  [self.nameInputView setText:[self.trainer name]]; // Default name
  [self.view addSubview:self.nameInputView];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  
  self.backgroundView = nil;
  self.textView1      = nil;
  self.textView2      = nil;
  self.confirmButton  = nil;
  
  self.nameInputView  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// Load view
-(void)loadViewAnimated:(BOOL)animated {
  void (^animations)() = ^(){[self.view setAlpha:1.f];};
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseIn
                                 animations:animations
                                 completion:nil];
  else animations();
}

#pragma mark - Private Methods

// Unload view
- (void)unloadViewAnimated:(BOOL)animated {
  void (^animations)() = ^(){[self.view setAlpha:0.f];};
  void (^completion)(BOOL) = ^(BOOL finished){[self.view removeFromSuperview];};
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:animations
                                 completion:completion];
  else {animations(); completion(YES);}
}

// Set text for |textView1_| & |textView2_|
- (void)setTextViewWithText1:(NSString *)text1 text2:(NSString *)text2 {
  [self.textView1 setFrame:self.textView1Frame];
  [self.textView1 setText:NSLocalizedString(text1, nil)];
  [self.textView1 sizeToFit];
  
  [self.textView2 setFrame:self.textView2Frame];
  [self.textView2 setText:NSLocalizedString(text2, nil)];
  [self.textView2 sizeToFit];
}

@end
