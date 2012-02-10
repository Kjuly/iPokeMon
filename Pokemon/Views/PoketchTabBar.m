//
//  PoketchTabBar.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PoketchTabBar.h"

#import "../GlobalConstants.h"

@interface PoketchTabBar (PrivateMethods)

- (CGFloat)horizontalLocationFor:(NSUInteger)tabIndex;
- (void)addTabBarArrowAtIndex:(NSUInteger)itemIndex;
- (UIButton *)buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width;
- (UIImage *)tabBarImage:(UIImage *)startImage size:(CGSize)targetSize backgroundImage:(UIImage *)backgroundImage;
- (UIImage *)blackFilledImageWithWhiteBackgroundUsing:(UIImage *)startImage;
- (UIImage *)tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage *)backgroundImage;

@end


@implementation PoketchTabBar

@synthesize buttons = buttons_;

- (void)dealloc
{
  [buttons_ release];
  
  [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  // Drawing code
}
*/

- (id)initWithItemCount:(NSUInteger)itemCount
                   size:(CGSize)itemSize
                    tag:(NSInteger)objectTag
               delegate:(NSObject <PoketchTabBarDelegate> *)tabBarDelegate
{
  if (self = [super init]) {
    // Adjust width based on the number of items & the width of each item
    [self setFrame:CGRectMake(0.0f, 0.0f, itemSize.width * itemCount, itemSize.height)];
    [self setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin
                             |UIViewAutoresizingFlexibleLeftMargin
                             |UIViewAutoresizingFlexibleBottomMargin
                             |UIViewAutoresizingFlexibleTopMargin
                             |UIViewAutoresizingFlexibleWidth];
    
    // The tag allows callers with multiple controls to distinguish between them
    [self setTag:objectTag];
    
    delegate_ = tabBarDelegate;
    
    // Add the background image
    UIImage * backgroundImage = [delegate_ backgroundImage];
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [self addSubview:backgroundImageView];
    [backgroundImageView release];
    
    // Initalize the array to store buttons
    buttons_ = [[NSMutableArray alloc] initWithCapacity:itemCount];
    
    // horizontalOffset tracks the proper x value as we add buttons as subviews
    // And iterate through each item
    CGFloat horizontalOffset = 10.0f;
    CGFloat buttonWidth      = (backgroundImage.size.width - 20.0f) / itemCount;
    for (NSUInteger i = 0; i < itemCount; ++i)
    {
      // Create a button
      UIButton * button = [self buttonAtIndex:i width:buttonWidth];
      
      // Register for touch events
      [button addTarget:self action:@selector(touchDownAction:)     forControlEvents:UIControlEventTouchDown];
      [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
      [button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchUpOutside];
      [button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchDragOutside];
      [button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchDragInside];
      
      // Add the button to |buttons_| array
      [buttons_ addObject:button];
      
      // Set the button's x offset & add the button as the subview
      [button setFrame:CGRectMake(horizontalOffset, 0.0f, button.frame.size.width, button.frame.size.height)];
      [self addSubview:button];
      
      // Increase the horizontal offset
      horizontalOffset += itemSize.width;
    }
  }
  
  return self;
}

// Only light the selected button area
- (void)dimAllButtonsExcept:(UIButton *)selectedButton
{
  for (UIButton * button in buttons_) {
    if (button == selectedButton) {
      [button setSelected:YES];
      [button setHighlighted:button.selected ? NO : YES];
      [button setTag:kSelectedTabItemTag];
      
      UIImageView * tabBarArrow = (UIImageView *)[self viewWithTag:kTabArrowImageTag];
      NSUInteger selectedIndex = [buttons_ indexOfObjectIdenticalTo:button];
      if (tabBarArrow)
        [UIView animateWithDuration:0.2f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                           CGRect frame = tabBarArrow.frame;
                           frame.origin.x = [self horizontalLocationFor:selectedIndex];
                           [tabBarArrow setFrame:frame];
                         }
                         completion:nil];
      else [self addTabBarArrowAtIndex:selectedIndex];
      tabBarArrow = nil;
    }
    else {
      [button setSelected:NO];
      [button setHighlighted:NO];
      [button setTag:0];
    }
  }
}

- (void)touchDownAction:(UIButton *)button
{
  [self dimAllButtonsExcept:button];
  
  if ([delegate_ respondsToSelector:@selector(touchDownAtItemAtIndex:)])
    [delegate_ touchDownAtItemAtIndex:[buttons_ indexOfObject:button]];
}

- (void)touchUpInsideAction:(UIButton *)button
{
  [self dimAllButtonsExcept:button];
  
  if ([delegate_ respondsToSelector:@selector(touchUpInsideItemAtIndex:)])
    [delegate_ touchUpInsideItemAtIndex:[buttons_ indexOfObject:button]];
}

- (void)otherTouchesAction:(UIButton*)button
{
  [self dimAllButtonsExcept:button];
}

- (void)selectItemAtIndex:(NSInteger)index
{
  UIButton * button = [buttons_ objectAtIndex:index];
  [self dimAllButtonsExcept:button];
}

// Get position.x of the selected tab
- (CGFloat)horizontalLocationFor:(NSUInteger)tabIndex
{
  UIImageView * tabBarArrow = (UIImageView *)[self viewWithTag:kTabArrowImageTag];
  
  // A single tab item's width is the same as the button's width
  UIButton * button = [buttons_ objectAtIndex:tabIndex];
  CGFloat tabItemWidth = button.frame.size.width;
  
  // A half width is tabItemWidth divided by 2 minus half the width of the arrow
  CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
  
  // The horizontal location is the index times the width plus a half width
  //
  //    __^__
  //   |     |
  //    -----
  //
  return button.frame.origin.x + halfTabItemWidth;
}

// Add tab bar arrow
- (void)addTabBarArrowAtIndex:(NSUInteger)itemIndex
{
  UIImageView * tabBarArrow = [[UIImageView alloc] initWithImage:[delegate_ tabBarArrowImage]];
  [tabBarArrow setTag:kTabArrowImageTag];
  
  // To get the vertical location we go up by the height of arrow
  // and then come back down 2 pixels so the arrow is slightly on top of the tab bar.
  CGFloat verticalLocation = -tabBarArrow.frame.size.height + 2;
  [tabBarArrow setFrame:CGRectMake([self horizontalLocationFor:itemIndex],
                                   verticalLocation,
                                   tabBarArrow.frame.size.width,
                                   tabBarArrow.frame.size.height)];
  [self addSubview:tabBarArrow];
  [tabBarArrow release];
}

// Create a button at the provided index
- (UIButton *)buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width
{
  // |TabBarBackgroundSelected| size
  CGSize TabBarBackgroundSelectedSize = CGSizeMake(44.0f, 44.0f);
  
  UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setFrame:CGRectMake(0.0f, 0.0f, TabBarBackgroundSelectedSize.width, TabBarBackgroundSelectedSize.height)];
  
  // Set button image
  UIImage * rawButtonImage = [delegate_ iconFor:itemIndex];
  UIImage * buttonImage = [self tabBarImage:rawButtonImage
                                       size:button.frame.size
                            backgroundImage:[UIImage imageNamed:@"PoketchTabBarIconDefaultMask.png"]];
  UIImage * buttonPressedImage = [self tabBarImage:rawButtonImage
                                              size:TabBarBackgroundSelectedSize
                                   backgroundImage:[UIImage imageNamed:@"PoketchTabBarIconSelectedMask.png"]];
  
  [button setImage:buttonImage        forState:UIControlStateNormal];
  [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
  [button setImage:buttonPressedImage forState:UIControlStateSelected];
  [button setBackgroundImage:[delegate_ selectedItemImage] forState:UIControlStateHighlighted];
  [button setBackgroundImage:[delegate_ selectedItemImage] forState:UIControlStateSelected];
  
  [button setAdjustsImageWhenHighlighted:NO];
  
  return button;
}

// Create a tab bar image
- (UIImage *)tabBarImage:(UIImage *)startImage
                    size:(CGSize)targetSize
         backgroundImage:(UIImage *)backgroundImageSource
{
  UIImage * backgroundImage = [self tabBarBackgroundImageWithSize:startImage.size
                                                  backgroundImage:backgroundImageSource];
  UIImage * bwImage = [self blackFilledImageWithWhiteBackgroundUsing:startImage];
  
  // Create an image mask
  CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(bwImage.CGImage),
                                           CGImageGetHeight(bwImage.CGImage),
                                           CGImageGetBitsPerComponent(bwImage.CGImage),
                                           CGImageGetBitsPerPixel(bwImage.CGImage),
                                           CGImageGetBytesPerRow(bwImage.CGImage),
                                           CGImageGetDataProvider(bwImage.CGImage), NULL, YES);
  
  // Using the mask to create a new image
  CGImageRef tabBarImageRef = CGImageCreateWithMask(backgroundImage.CGImage, imageMask);
  
  UIImage * tabBarImage = [UIImage imageWithCGImage:tabBarImageRef
                                              scale:startImage.scale
                                        orientation:startImage.imageOrientation];
  
  // Cleanup
  CGImageRelease(imageMask);
  CGImageRelease(tabBarImageRef);
  
  ///Create a new context with the right size
  UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0f);
  // Draw the new tab bar image at the center
  [tabBarImage drawInRect:CGRectMake((targetSize.width / 2.0f) - (startImage.size.width / 2.0f),
                                     (targetSize.height / 2.0f) - (startImage.size.height / 2.0f),
                                     startImage.size.width,
                                     startImage.size.height)];
  // Generate a new image
  UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return resultImage;
}

// Convert the image's fill color to black and background to white
- (UIImage *)blackFilledImageWithWhiteBackgroundUsing:(UIImage *)startImage
{
  // Create the proper sized rect
  CGRect imageRect = CGRectMake(0.0f, 0.0f, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
  
  // Create a new bitmap context
  CGContextRef context = CGBitmapContextCreate(NULL,
                                               imageRect.size.width,
                                               imageRect.size.height,
                                               8,
                                               0,
                                               CGImageGetColorSpace(startImage.CGImage),
                                               kCGImageAlphaPremultipliedLast);
  
  CGContextSetRGBFillColor(context, 1, 1, 1, 1);
  CGContextFillRect(context, imageRect);
  
  // Use the passed in image as a clipping mask
  CGContextClipToMask(context, imageRect, startImage.CGImage);
  // Set the fill color to black: R:0 G:0 B:0 alpha:1
  CGContextSetRGBFillColor(context, 0, 0, 0, 1);
  // Fill with black
  CGContextFillRect(context, imageRect);
  
  // Generate a new image
  CGImageRef newCGImage = CGBitmapContextCreateImage(context);
  UIImage * newImage = [UIImage imageWithCGImage:newCGImage
                                           scale:startImage.scale
                                     orientation:startImage.imageOrientation];
  
  // Cleanup
  CGContextRelease(context);
  CGImageRelease(newCGImage);
  
  return newImage;
}

- (UIImage *)tabBarBackgroundImageWithSize:(CGSize)targetSize
                           backgroundImage:(UIImage*)backgroundImage
{
  UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0f);
  
  if (backgroundImage) {
    // Draw the background image centered
    [backgroundImage drawInRect:CGRectMake((targetSize.width - CGImageGetWidth(backgroundImage.CGImage)) / 2.0f,
                                           (targetSize.height - CGImageGetHeight(backgroundImage.CGImage)) / 2.0f,
                                           CGImageGetWidth(backgroundImage.CGImage),
                                           CGImageGetHeight(backgroundImage.CGImage))];
  } else {
    [[UIColor lightGrayColor] set];
    UIRectFill(CGRectMake(0.0f, 0.0f, targetSize.width, targetSize.height));
  }
  
  UIImage * finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return finalBackgroundImage;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
  CGFloat itemWidth = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)  ? self.window.frame.size.height : self.window.frame.size.width) / buttons_.count;
  // horizontalOffset tracks the x value
  CGFloat horizontalOffset = 0;
  
  // Iterate through each button
  for (UIButton * button in buttons_) {
    // Set the button's x offset
    button.frame = CGRectMake(horizontalOffset, 0.0f, button.frame.size.width, button.frame.size.height);
    horizontalOffset += itemWidth;
  }
  
  // Move the arrow to the new button location
  UIButton * selectedButton = (UIButton *)[self viewWithTag:kSelectedTabItemTag];
  [self dimAllButtonsExcept:selectedButton];
}

@end
