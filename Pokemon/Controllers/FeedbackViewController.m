//
//  FeedbackViewController.m
//  iPokemon
//
//  Created by Kaijie Yu on 4/28/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "FeedbackViewController.h"

#import "GlobalRender.h"


@interface FeedbackViewController () {
 @private
  UITextField * textField_;
  UIButton    * submitButton_;
  UIButton    * cleanButton_;
}

@property (nonatomic, retain) UITextField * textField;
@property (nonatomic, retain) UIButton    * submitButton;
@property (nonatomic, retain) UIButton    * cleanButton;

- (void)releaseSubviews;

@end

@implementation FeedbackViewController

@synthesize textField    = textField_;
@synthesize submitButton = submitButton_;
@synthesize cleanButton  = cleanButton_;

- (void)dealloc {
  [self releaseSubviews];
  [super dealloc];
}

- (void)releaseSubviews {
  self.textField    = nil;
  self.submitButton = nil;
  self.cleanButton  = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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
- (void)loadView {
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, kViewHeight)];
  self.view = view;
  [view release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  CGRect textFieldFrame    = CGRectMake(10.f, 15.f, 300.f, 32.f);
  CGRect submitButtonFrame = CGRectMake(30.f, 335.f, 64.f, 64.f);
  CGRect cleanButtonFrame  = CGRectMake(100.f, 335.f, 64., 64.);
  
  // text input field
  UITextField * textField = [[UITextField alloc] initWithFrame:textFieldFrame];
  [textField setFont:[GlobalRender textFontNormalInSizeOf:14.f]];
  [textField setKeyboardType:UIKeyboardTypeDefault];
  self.textField = textField;
  [textField release];
  [self.view addSubview:self.textField];
  
  // submit button
  UIButton * submitButton = [[UIButton alloc] initWithFrame:submitButtonFrame];
  self.submitButton = submitButton;
  [submitButton release];
  [self.view addSubview:self.submitButton];
  
  // clean button
  UIButton * cleanButton = [[UIButton alloc] initWithFrame:cleanButtonFrame];
  self.cleanButton = cleanButton;
  [cleanButton release];
  [self.view addSubview:self.cleanButton];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self releaseSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextView Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.textField resignFirstResponder];
  return YES;
}

@end
