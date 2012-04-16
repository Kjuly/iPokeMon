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
  UINavigationController * navigationController_;
  UILabel                * title_;
  UIButton               * backButtonToRoot_;
  UIButton               * backButton_;
  BOOL                     isButtonHidden_;
}

@property (nonatomic, retain) IBOutlet UINavigationController * navigationController;
@property (nonatomic, retain) UILabel     * title;
@property (nonatomic, retain) UIButton    * backButtonToRoot;
@property (nonatomic, retain) UIButton    * backButton;

- (void)setBackButtonForRoot;

@end


@implementation CustomNavigationBar

@synthesize viewCount      = viewCount_;

@synthesize navigationController = navigationController_;
@synthesize title                = title_;
@synthesize backButtonToRoot     = backButtonToRoot_;
@synthesize backButton           = backButton_;

-(void)dealloc
{
  self.navigationController = nil;
  self.title                = nil;
  self.backButtonToRoot     = nil;
  self.backButton           = nil;
  
  [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//
// If we have a custom background image, then draw it,
// othwerwise call super and draw the standard nav bar
- (void)drawRect:(CGRect)rect {
//  [super drawRect:rect];
  NSLog(@"*** CustomNavigationBar drawRect:");
  UIImage * backgroundImage = [UIImage imageNamed:@"NavigationBarBackground.png"];
  [backgroundImage drawInRect:CGRectMake(0.f, 0.f, kViewWidth, kNavigationBarHeight)];
  
  // Create custom |backButton_|
  [self setBackButtonForRoot];
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

// Save the background image to |navigationBarBackgroundImage_|,
// If not shown, call |[self setNeedsDisplay];| to force a redraw.
- (void)setup {
  viewCount_      = 0;
  isButtonHidden_ = NO;
}

// Set title for navigation bar
- (void)setTitleWithText:(NSString *)text animated:(BOOL)animated {
  if (self.title == nil) {
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(100.f, 0.f, 120.f, self.frame.size.height - 10.f)];
    self.title = title;
    [title release];
    [self.title setBackgroundColor:[UIColor clearColor]];
    [self.title setTextColor:[GlobalRender textColorTitleWhite]];
    [self.title setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [self.title setTextAlignment:UITextAlignmentCenter];
    [self addSubview:self.title];
  }
  [self.title setText:text];
}

// Settings for |backButton|
// Back to Root(TopViewController)
- (void)backToRoot:(id)sender {
  // Reset |viewCount_|
  if (self.viewCount >= 2)
    [self removeBackButtonForPreviousView];
  self.viewCount = 0;
  
  [self.navigationController popToRootViewControllerAnimated:YES];
  
  [UIView animateWithDuration:0.3f
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     if ([self.navigationController.topViewController isKindOfClass:[AbstractCenterMenuViewController class]]) {
                       // Slide up the Navigation bar to hide it
                       CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
                       navigationBarFrame.origin.y = - navigationBarFrame.size.height;
                       [self.navigationController.navigationBar setFrame:navigationBarFrame];
                     }
                     else {
                       [self setBackToRootButtonToHidden:YES animated:YES];
                       [self setTitleWithText:NSLocalizedString(@"PMSLoginChoice", nil) animated:YES];
                     }
                   }
                   completion:^(BOOL finished) {
                     if ([self.navigationController.topViewController isKindOfClass:[AbstractCenterMenuViewController class]]) {
                       // Set |cenerMainButton|'s status to Normal (Default: |kCenterMainButtonStatusNormal|)
                       // And recover button' layout in center view
                       [self.navigationController setNavigationBarHidden:YES];
                       [(AbstractCenterMenuViewController *)self.navigationController.topViewController
                          changeCenterMainButtonStatusToMove:kCenterMainButtonStatusNormal];
                     }
                   }];
}

// Provide the action for the custom |backButton|
- (void)back:(id)sender {
  NSLog(@"popViewController");
  
  // Remove the |backButton| if needed
  if (self.viewCount >= 2 && --self.viewCount < 2)
    [self removeBackButtonForPreviousView];
  
  [self.navigationController popViewControllerAnimated:YES];
}

// Create |backButton| to Root (Private)
- (void)setBackButtonForRoot {
  if (self.backButtonToRoot == nil) {
    CGRect buttonFrame = CGRectMake((isButtonHidden_ ? 160.f : 10.f), 0.f, kNavigationBarBackButtonWidth, kNavigationBarBackButtonHeight);
    backButtonToRoot_ = [[UIButton alloc] initWithFrame:buttonFrame];
    [backButtonToRoot_ setImage:[UIImage imageNamed:@"CustomNavigationBar_backButtonToRoot.png"]
                       forState:UIControlStateNormal];
    [backButtonToRoot_ addTarget:self action:@selector(backToRoot:) forControlEvents:UIControlEventTouchUpInside];
  }
  [self addSubview:self.backButtonToRoot];
  [self.backButtonToRoot setAlpha:(isButtonHidden_ ? 0.f : 1.f)];
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
- (void)addBackButtonForPreviousView
{
  __block CGRect originalFrame = CGRectMake(160.f, 0.f, kNavigationBarBackButtonWidth, kNavigationBarBackButtonHeight);
  
  if (! self.backButton) {
    backButton_ = [[UIButton alloc] initWithFrame:originalFrame];
    [backButton_ setImage:[UIImage imageNamed:@"CustomNavigationBar_backButton.png"] forState:UIControlStateNormal];
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

// Remove |backButton| for previous view
- (void)removeBackButtonForPreviousView
{
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

// clear the background image and call setNeedsDisplay to force a redraw
- (void)clearBackground {
  self.backButtonToRoot             = nil;
  self.backButton                   = nil;
  
  [self setNeedsDisplay];
}

@end
