//
//  CustomNavigationBar.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomNavigationBar.h"

#import "GlobalConstants.h"
#import "GlobalRender.h"
#import "GlobalNotificationConstants.h"
#import "AbstractCenterMenuViewController.h"


@interface CustomNavigationBar () {
 @private  
//  UILabel  * title_;
  UIButton * backButtonToRoot_;
  UIButton * backButton_;
  BOOL       isButtonHidden_;
}

//@property (nonatomic, retain) UILabel  * title;
@property (nonatomic, retain) UIButton * backButtonToRoot;
@property (nonatomic, retain) UIButton * backButton;

- (void)_setBackButtonForRoot;
- (void)_removeBackButtonForPreviousView;

@end


@implementation CustomNavigationBar

@synthesize delegate         = delegate_;
@synthesize viewCount        = viewCount_;

//@synthesize title            = title_;
@synthesize backButtonToRoot = backButtonToRoot_;
@synthesize backButton       = backButton_;

-(void)dealloc {
  self.delegate         = nil;
//  self.title            = nil;
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

// Set title for navigation bar
- (void)setTitleWithText:(NSString *)text animated:(BOOL)animated {
  /*if (self.title == nil) {
    UILabel * title = [[UILabel alloc] init];
    self.title = title;
    [title release];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self.title setTextColor:[GlobalRender textColorTitleWhite]];
    [self.title setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [self.title setTextAlignment:UITextAlignmentCenter];
    [self addSubview:self.title];
  }
  
  CGRect titleFrame = CGRectMake(100.f, -10.f, 120.f, self.frame.size.height - 10.f);
  [self.title setFrame:titleFrame];
  [self.title setAlpha:0.f];
  [self.title setText:text];
  titleFrame.origin.y = 0.f;
  // animation block
  void (^animations)() = ^{
    [self.title setFrame:titleFrame];
    [self.title setAlpha:1.f];
  };
  
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:animations
                                 completion:nil];
  else animations();*/
}

// Remove title
- (void)removeTitleAnimated:(BOOL)animated {
  /*CGRect titleFrame = CGRectMake(100.f, -10.f, 120.f, self.frame.size.height - 10.f);
  // animation block
  void (^animations)() = ^{
    [self.title setFrame:titleFrame];
    [self.title setAlpha:0.f];
  };
  
  if (animated) [UIView animateWithDuration:.3f
                                      delay:0.f
                                    options:UIViewAnimationOptionCurveEaseOut
                                 animations:animations
                                 completion:nil];
  else animations();*/
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
    else {
      [self setBackToRootButtonToHidden:YES animated:YES];
      [self setTitleWithText:NSLocalizedString(@"PMSLoginChoice", nil) animated:YES];
    }
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
  __block CGRect originalFrame = CGRectMake(160.f, 0.f, kNavigationBarBackButtonWidth, kNavigationBarBackButtonHeight);
  
  if (! self.backButton) {
    backButton_ = [[UIButton alloc] initWithFrame:originalFrame];
    [backButton_ setImage:[UIImage imageNamed:kPMINNavBarBackButton] forState:UIControlStateNormal];
    [backButton_ addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton_ setAlpha:0.f];
  }
  [self addSubview:self.backButton];
  
  [UIView animateWithDuration:.2f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     originalFrame.origin.x = kNavigationBarBackButtonWidth + 10.f;
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
  __block CGRect originalFrame = self.backButton.frame;
  [UIView animateWithDuration:.2f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     originalFrame.origin.x = 160.f;
                     [self.backButton setFrame:originalFrame];
                     [self.backButton setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.backButton removeFromSuperview];
                   }];
}

@end
