//
//  CustomNavigationBar.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/2/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

@synthesize navigationController = navigationController_;
@synthesize navigationBarBackgroundImage = navigationBarBackgroundImage_;

-(void)dealloc
{
  [navigationController_ release];
  [navigationBarBackgroundImage_ release];
  
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
  if (navigationBarBackgroundImage_) {
    float imageWidth = navigationBarBackgroundImage_.frame.size.width;
    float imageHeight= navigationBarBackgroundImage_.frame.size.height;
    [navigationBarBackgroundImage_.image drawInRect:CGRectMake(0.0f, 0.0f, imageWidth, imageHeight)];
  }
  else
    [super drawRect:rect];
}

- (CGSize)sizeThatFits:(CGSize)size {
  UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
  float newSizeWidth;
  if ( UIInterfaceOrientationIsLandscape(orientation) ) newSizeWidth = 480.0f;
  else newSizeWidth = 320.0f;
  CGSize newSize = CGSizeMake(newSizeWidth, navigationBarBackgroundImage_.frame.size.height);
  NSLog(@">>> new size: (%f, %f)", newSize.width, newSize.height);
  return newSize;
}

// Save the background image and call setNeedsDisplay to force a redraw
- (void)initNavigationBarWith:(UIImage *)backgroundImage
{
  NSLog(@"*** CustomNavigationBar initNavigationBarWith:");
  navigationBarBackgroundImage_ = [[UIImageView alloc]
                                   initWithFrame:CGRectMake(0.0f,
                                                            0.0f,
                                                            backgroundImage.size.width,
                                                            backgroundImage.size.height)];
  navigationBarBackgroundImage_.image = backgroundImage;
  
  [self setNeedsDisplay];
}

// With a custom back button, we have to provide the action. We simply pop the view controller
- (void)back:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

// clear the background image and call setNeedsDisplay to force a redraw
- (void)clearBackground
{
  self.navigationBarBackgroundImage = nil;
  [self setNeedsDisplay];
}

@end
