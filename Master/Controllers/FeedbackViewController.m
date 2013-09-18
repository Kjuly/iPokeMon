//
//  FeedbackViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 4/28/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "FeedbackViewController.h"

#import "CustomNavigationBar.h"

@interface FeedbackViewController () {
 @private
  UIImageView * textFieldBackground_;
  UITextField * textField_;
  UIButton    * submitButton_;
  UIButton    * cleanButton_;
}

@property (nonatomic, strong) UIImageView * textFieldBackground;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton    * submitButton;
@property (nonatomic, strong) UIButton    * cleanButton;

- (void)_submit:(id)sender;
- (void)_clean:(id)sender;
- (void)_setMenuHidden:(BOOL)hidden;

@end

@implementation FeedbackViewController

@synthesize textFieldBackground = textFieldBackground_;
@synthesize textField           = textField_;
@synthesize submitButton        = submitButton_;
@synthesize cleanButton         = cleanButton_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  [view setBackgroundColor:[UIColor clearColor]];
  [view setUserInteractionEnabled:YES];
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  CGFloat marginTop        = 15.f;
  CGFloat marginLeft       = 15.f;
  CGFloat textFieldHeight  = kFeedbackTextFieldBackgroundHeight - 30.f;
  CGFloat textFieldWidth   = kViewWidth - 2 * marginLeft;
  CGRect textFieldBackgroundFrame = CGRectMake(0.f, 0.f, kViewWidth, kFeedbackTextFieldBackgroundHeight);
  CGRect textFieldFrame    = CGRectMake(marginLeft, marginTop, textFieldWidth, textFieldHeight);
  CGRect submitButtonFrame = CGRectMake(0.f, kFeedbackTextFieldBackgroundHeight, kRectButtonWidth, kRectButtonHeight);
  CGRect cleanButtonFrame  = CGRectMake(kRectButtonWidth, kFeedbackTextFieldBackgroundHeight, kRectButtonWidth, kRectButtonHeight);
  
  // text input field background
  UIImageView * textFieldBackground = [[UIImageView alloc] initWithFrame:textFieldBackgroundFrame];
  [textFieldBackground setImage:[UIImage imageNamed:kPMINFeedbackTextFieldBackground]];
  [textFieldBackground setUserInteractionEnabled:YES];
  self.textFieldBackground = textFieldBackground;
  [self.view addSubview:self.textFieldBackground];
  
  // text input field
  UITextField * textField = [[UITextField alloc] initWithFrame:textFieldFrame];
  [textField setBackgroundColor:[UIColor clearColor]];
  [textField setTextColor:[UIColor whiteColor]];
  [textField setKeyboardType:UIKeyboardTypeDefault];
  [textField setDelegate:self];
  self.textField = textField;
  [self.textFieldBackground addSubview:self.textField];
  
  // submit button
  UIButton * submitButton = [[UIButton alloc] initWithFrame:submitButtonFrame];
  [submitButton setImage:[UIImage imageNamed:kPMINRectButtonConfirm] forState:UIControlStateNormal];
  [submitButton addTarget:self action:@selector(_submit:) forControlEvents:UIControlEventTouchUpInside];
  self.submitButton = submitButton;
  [self.view insertSubview:self.submitButton belowSubview:self.textFieldBackground];
  
  // clean button
  UIButton * cleanButton = [[UIButton alloc] initWithFrame:cleanButtonFrame];
  [cleanButton setImage:[UIImage imageNamed:kPMINRectButtonUndo] forState:UIControlStateNormal];
  [cleanButton addTarget:self action:@selector(_clean:) forControlEvents:UIControlEventTouchUpInside];
  self.cleanButton = cleanButton;
  [self.view insertSubview:self.cleanButton belowSubview:self.textFieldBackground];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.textFieldBackground = nil;
  self.textField           = nil;
  self.submitButton        = nil;
  self.cleanButton         = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private Methods

// Submit feedback content & cancel
- (void)_submit:(id)sender
{
//  [TestFlight submitFeedback:self.textField.text];
//  if ([self.navigationController isNavigationBarHidden])
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//  [(CustomNavigationBar *)self.navigationController.navigationBar back:nil];
}

// Clean the content
- (void)_clean:(id)sender
{
  [self.textField setText:nil];
}

// toggle menu
- (void)_setMenuHidden:(BOOL)hidden
{
  CGRect submitButtonFrame =
    CGRectMake(0.f, kFeedbackTextFieldBackgroundHeight, kRectButtonWidth, kRectButtonHeight);
  CGRect cleanButtonFrame  =
    CGRectMake(kRectButtonWidth, kFeedbackTextFieldBackgroundHeight, kRectButtonWidth, kRectButtonHeight);
  if (hidden) {
    CGFloat deltaHeight = kRectButtonHeight - kRectButtonBottomLineHeight;
    submitButtonFrame.origin.y -= deltaHeight;
    cleanButtonFrame.origin.y  -= deltaHeight;
  }
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     [self.submitButton setFrame:submitButtonFrame];
                     [self.cleanButton setFrame:cleanButtonFrame];
                   }
                   completion:nil];
}

#pragma mark - UITextView Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self.navigationController setNavigationBarHidden:YES animated:YES];
  [self _setMenuHidden:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  [self.textField resignFirstResponder];
  [self _setMenuHidden:NO];
  return YES;
}

@end
