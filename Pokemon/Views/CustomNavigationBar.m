//
//  CustomNavigationBar.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomNavigationBar.h"

#import "GlobalNotificationConstants.h"
#import "AbstractCenterMenuViewController.h"

#define kBackButtonHeight 60.0f
#define kBackButtonWith   40.0f


@interface CustomNavigationBar ()

- (void)backToRootWithCenterMainButton:(NSNotification *)notification;

@end

@implementation CustomNavigationBar

@synthesize navigationController         = navigationController_;
@synthesize navigationBarBackgroundImage = navigationBarBackgroundImage_;
@synthesize backButtonToRoot             = backButtonToRoot_;
@synthesize backButton                   = backButton_;

@synthesize viewCount = viewCount_;

-(void)dealloc
{
  [navigationController_         release];
  [navigationBarBackgroundImage_ release];
  [backButtonToRoot_             release];
  [backButton_                   release];
  
  [super dealloc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//
// If we have a custom background image, then draw it,
// othwerwise call super and draw the standard nav bar
- (void)drawRect:(CGRect)rect
{
  NSLog(@"*** CustomNavigationBar drawRect:");
  
  // Draw |navigationBarBackgroundImage_|
  if (navigationBarBackgroundImage_)
    [navigationBarBackgroundImage_.image drawInRect:navigationBarBackgroundImage_.frame];
  else
    [super drawRect:rect];
  
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
  return self.navigationBarBackgroundImage.frame.size;
}

// Save the background image to |navigationBarBackgroundImage_|,
// If not shown, call |[self setNeedsDisplay];| to force a redraw.
- (void)initNavigationBarWith:(UIImage *)backgroundImage
{
  navigationBarBackgroundImage_ = [[UIImageView alloc]
                                   initWithFrame:CGRectMake(0.0f,
                                                            0.0f,
                                                            backgroundImage.size.width,
                                                            backgroundImage.size.height)];
  navigationBarBackgroundImage_.image = backgroundImage;
  
  // Initialize |viewCount_|
  viewCount_ = 0;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(backToRootWithCenterMainButton:)
                                               name:kPMNBackToMainView
                                             object:nil];
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
                     // Slide up the Navigation bar to hide it
                     CGRect navigationBarFrame = self.navigationController.topViewController.navigationController.navigationBar.frame;
                     navigationBarFrame.origin.y = - navigationBarFrame.size.height;
                     [self.navigationController.topViewController.navigationController.navigationBar setFrame:navigationBarFrame];
                   }
                   completion:^(BOOL finished) {
                     // Set |cenerMainButton|'s status to Normal (Default)
                     [[NSNotificationCenter defaultCenter] postNotificationName:kPMNChangeCenterMainButtonStatus
                                                                         object:self
                                                                       userInfo:nil];
                     
                     // Recover button' layout in center view
                     [(AbstractCenterMenuViewController *)self.navigationController.topViewController recoverButtonsLayoutInCenterView];
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

// Create |backButton| to Root
- (void)setBackButtonForRoot
{
  if (! self.backButtonToRoot) {
    backButtonToRoot_ = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 0.0f, kBackButtonWith, kBackButtonHeight)];
    [backButtonToRoot_ setImage:[UIImage imageNamed:@"CustomNavigationBar_backButtonToRoot.png"]
                       forState:UIControlStateNormal];
    [backButtonToRoot_ addTarget:self action:@selector(backToRoot:) forControlEvents:UIControlEventTouchUpInside];
  }
  [self addSubview:self.backButtonToRoot];
}

// Add |backButton| for previous view
- (void)addBackButtonForPreviousView
{
  __block CGRect originalFrame = CGRectMake(160.0f, 0.0f, kBackButtonWith, kBackButtonHeight);
  
  if (! self.backButton) {
    backButton_ = [[UIButton alloc] initWithFrame:originalFrame];
    [backButton_ setImage:[UIImage imageNamed:@"CustomNavigationBar_backButton.png"] forState:UIControlStateNormal];
    [backButton_ addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton_ setAlpha:0.0f];
  }
  [self addSubview:self.backButton];
  
  [UIView animateWithDuration:0.2f
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     originalFrame.origin.x = kBackButtonWith + 10.0f;
                     [self.backButton setFrame:originalFrame];
                     [self.backButton setAlpha:1.0f];
                   }
                   completion:nil];
}

// Remove |backButton| for previous view
- (void)removeBackButtonForPreviousView
{
  __block CGRect originalFrame = self.backButton.frame;
  
  [UIView animateWithDuration:0.2f
                        delay:0.0f
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     originalFrame.origin.x = 160.0f;
                     [self.backButton setFrame:originalFrame];
                     [self.backButton setAlpha:0.0f];
                   }
                   completion:^(BOOL finished) {
                     [self.backButton removeFromSuperview];
                   }];
}

/*- (void)setBackButtonWith:(UINavigationItem *)navigationItem
{
  NSLog(@"--- CustomNavigationBar setBackButtonWith: ---");
  
//  {
//    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 40.0f)];
//    [backButton setTitle:@"<<" forState:UIControlStateNormal];
//    [backButton setBackgroundColor:[UIColor yellowColor]];
//    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setUserInteractionEnabled:YES];
//    
//    UIBarButtonItem * backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    [backBarButtonItem setEnabled:YES];
//    [backButton release];
//    
//    [navigationItem setLeftBarButtonItem:backBarButtonItem];
//    [backBarButtonItem release];
//  }
  
  [self setNeedsDisplay];
}*/

// clear the background image and call setNeedsDisplay to force a redraw
- (void)clearBackground
{
  self.navigationBarBackgroundImage = nil;
  self.backButtonToRoot             = nil;
  self.backButton                   = nil;
  
  [self setNeedsDisplay];
}

#pragma mark - Private Methods

// Notification methods for backing to main view
- (void)backToRootWithCenterMainButton:(NSNotification *)notification {
  [self backToRoot:nil];
}

@end
