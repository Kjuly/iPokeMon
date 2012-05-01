//
//  StoreItemQuantityChangeViewController.m
//  iPokemon
//
//  Created by Kaijie Yu on 5/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "StoreItemQuantityChangeViewController.h"

@interface StoreItemQuantityChangeViewController () {
 @private
  UIView   * backgroundView_;
  UIButton * confirmButton_;
}

@property (nonatomic, retain) UIView   * backgroundView;
@property (nonatomic, retain) UIButton * confirmButton;

- (void)releaseSubviews;
- (void)_unloadViewAnimated:(BOOL)animated;

@end

@implementation StoreItemQuantityChangeViewController

@synthesize backgroundView = backgroundView_;
@synthesize confirmButton  = confirmButton_;

- (void)dealloc {
  [self releaseSubviews];
  [self dealloc];
}

- (void)releaseSubviews {
  self.backgroundView = nil;
  self.confirmButton  = nil;
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
  UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, kViewWidth, 480.f)];
  self.view = view;
  [view release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  backgroundView_ = [[UIView alloc] initWithFrame:self.view.frame];
  [backgroundView_ setBackgroundColor:[UIColor blackColor]];
  [backgroundView_ setAlpha:0.f];
  [self.view addSubview:backgroundView_];
  
  // subviews
  CGRect confirmButtonFrame = CGRectMake((kViewWidth - kCenterMainButtonSize) / 2.f,
                                         300.f, kCenterMainButtonSize, kCenterMainButtonSize);
  confirmButton_ = [[UIButton alloc] initWithFrame:confirmButtonFrame];
  [confirmButton_ setBackgroundImage:[UIImage imageNamed:kPMINMainButtonBackgoundNormal]
                            forState:UIControlStateNormal];
  [confirmButton_ setImage:[UIImage imageNamed:kPMINMainButtonConfirm]
                  forState:UIControlStateNormal];
  [confirmButton_ setAlpha:0.f];
  [self.view addSubview:confirmButton_];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self releaseSubviews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

- (void)loadViewAnimated:(BOOL)animated {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.backgroundView setAlpha:.85f];
                     [self.confirmButton setAlpha:1.f];
                   }
                   completion:nil];
}

#pragma mark - Private Methods

- (void)_unloadViewAnimated:(BOOL)animated {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.view setAlpha:0.f];
                     [self.confirmButton setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.view removeFromSuperview];
                     [self.view setAlpha:1.f];
                     [self.backgroundView setAlpha:0.f];
                   }];
}

@end
