//
//  CustomNavigationBar.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomNavigationBar.h"

#import "GlobalRender.h"
#import "AbstractCenterMenuViewController.h"


@interface CustomNavigationBar () {
 @private  
  UIButton * backButtonToRoot_;
  UIButton * backButton_;
  BOOL       isButtonHidden_;
}

@property (nonatomic, retain) UIButton * backButtonToRoot;
@property (nonatomic, retain) UIButton * backButton;

- (void)_setBackButtonForRoot;
- (void)_removeBackButtonForPreviousView;

@end


@implementation CustomNavigationBar

@synthesize delegate         = delegate_;
@synthesize viewCount        = viewCount_;

@synthesize backButtonToRoot = backButtonToRoot_;
@synthesize backButton       = backButton_;

-(void)dealloc {
  self.delegate         = nil;
  self.backButtonToRoot = nil;
  self.backButton       = nil;
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    viewCount_      = -1;
    isButtonHidden_ = NO;
    [self setOpaque:NO];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//
// If we have a custom background image, then draw it,
// othwerwise call super and draw the standard nav bar
- (void)drawRect:(CGRect)rect {
//  [super drawRect:rect];
  NSLog(@"*** CustomNavigationBar drawRect:");
  UIImage * backgroundImage = [UIImage imageNamed:kPMINNavBarBackground];
  [backgroundImage drawInRect:CGRectMake(0.f, 0.f, kViewWidth, kNavigationBarHeight)];
  // Create custom |backButton_|
  [self _setBackButtonForRoot];
}

// Reset NavigationBar's size to container |navigationBarBackgroundImage_|
// 
////TODO: for Device Orientation:
//
//  UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
//  float newSizeWidth;
//  if ( UIInterfaceOrientationIsLandscape(orientation) ) newSizeWidth = 480.0f;
//  else newSizeWidth = 320.0f;
//  CGSize newSize = CGSizeMake(newSizeWidth, navigationBarBackgroundImage_.frame.size.height);
//  NSLog(@">>> new size: (%f, %f)", newSize.width, newSize.height);
//  return newSize;
//
- (CGSize)sizeThatFits:(CGSize)size {
  return CGSizeMake(kViewWidth, kNavigationBarHeight);
}

// Settings for |backButton|
// Back to Root(TopViewController)
- (void)backToRoot:(id)sender {
  // Reset |viewCount_|
  if (self.viewCount >= 2)
    [self _removeBackButtonForPreviousView];
  self.viewCount = 0;
  
  [self.delegate backToRootViewAnimated:YES];
  // Animation blocks
  void (^animations)() = ^{
    if ([[self.delegate rootViewController] isKindOfClass:[AbstractCenterMenuViewController class]]) {
      // Slide up the Navigation bar to hide it
      [self setFrame:CGRectMake(0.f, -kNavigationBarHeight, kViewWidth, kNavigationBarHeight)];
    }
    // For Login view
    else [self setBackToRootButtonToHidden:YES animated:YES];
  };
  void (^completion)(BOOL) = ^(BOOL finished) {
    if ([[self.delegate rootViewController] isKindOfClass:[AbstractCenterMenuViewController class]]) {
      // Set |cenerMainButton|'s status to Normal (Default: |kCenterMainButtonStatusNormal|)
      // And recover button' layout in center view
      [self.delegate hideNavigationBar:YES animated:NO];
      [(AbstractCenterMenuViewController *)[self.delegate rootViewController]
       changeCenterMainButtonStatusToMove:kCenterMainButtonStatusNormal];
    }
  };  
  [UIView animateWithDuration:0.3f
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:animations
                   completion:completion];
}

// Provide the action for the custom |backButton|
- (void)back:(id)sender {
  NSLog(@"popViewController");
  // Remove the |backButton| if needed
  if (self.viewCount >= 2 && --self.viewCount < 2)
    [self _removeBackButtonForPreviousView];
  [self.delegate backToPreviousViewAnimated:YES];
  
  // When pop view, the |titleView| will over the |backButtonToRoot_|,
  //   so bring it to front
  [self bringSubviewToFront:self.backButtonToRoot];
  [self bringSubviewToFront:self.backButton];
}

// Set |backButtonToRoot_| to hidden or not
- (void)setBackToRootButtonToHidden:(BOOL)hidden animated:(BOOL)animated {
  NSLog(@"--- |CustomNavigationBar|: %@ navigation bar...", hidden ? @"hide" : @"show");
  isButtonHidden_ = hidden;
  CGRect backToRootButtonFrame = self.backButtonToRoot.frame;
  backToRootButtonFrame.origin.x = hidden ? 160.f : 10.f;
  CGFloat alpha                  = hidden ? 0.f   : 1.f;
  void (^animations)() = ^(){
    [self.backButtonToRoot setFrame:backToRootButtonFrame];
    [self.backButtonToRoot setAlpha:alpha];
  };
  
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:animations
                                 completion:nil];
  else animations();
}

// Add |backButton| for previous view
- (void)addBackButtonForPreviousView {
  CGRect originalFrame = CGRectMake(160.f, 0.f, kNavigationBarBackButtonWidth, kNavigationBarBackButtonHeight);
  if (self.backButton == nil) {
    backButton_ = [[UIButton alloc] initWithFrame:originalFrame];
    [backButton_ setImage:[UIImage imageNamed:kPMINNavBarBackButton] forState:UIControlStateNormal];
    [backButton_ addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton_ setAlpha:0.f];
  }
  [self addSubview:self.backButton];
  originalFrame.origin.x = kNavigationBarBackButtonWidth + 10.f;
  [UIView animateWithDuration:.2f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     [self.backButton setFrame:originalFrame];
                     [self.backButton setAlpha:1.0f];
                   }
                   completion:nil];
}

#pragma mark - Private Methods

// Create |backButton| to Root (Private)
- (void)_setBackButtonForRoot {
  if (self.backButtonToRoot == nil) {
    CGRect buttonFrame = CGRectMake((isButtonHidden_ ? 160.f : 10.f), 0.f, kNavigationBarBackButtonWidth, kNavigationBarBackButtonHeight);
    backButtonToRoot_ = [[UIButton alloc] initWithFrame:buttonFrame];
    [backButtonToRoot_ setImage:[UIImage imageNamed:kPMINNavBarBackToRootButton]
                       forState:UIControlStateNormal];
    [backButtonToRoot_ addTarget:self action:@selector(backToRoot:) forControlEvents:UIControlEventTouchUpInside];
  }
  [self addSubview:self.backButtonToRoot];
  [self.backButtonToRoot setAlpha:(isButtonHidden_ ? 0.f : 1.f)];
}

// Remove |backButton| for previous view
- (void)_removeBackButtonForPreviousView {
  CGRect originalFrame = self.backButton.frame;
  originalFrame.origin.x = 160.f;
  [UIView animateWithDuration:.2f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self.backButton setFrame:originalFrame];
                     [self.backButton setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.backButton removeFromSuperview];
                   }];
}

@end
