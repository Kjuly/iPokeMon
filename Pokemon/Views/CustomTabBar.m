//
//  PoketchTabBar.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CustomTabBar.h"

#import "GlobalConstants.h"

#import <QuartzCore/QuartzCore.h>


@interface CustomTabBar () {
 @private
  UIView      * menuArea_;
  UIImageView * arrow_;
  
  CGFloat       triangleHypotenuse_;
  CGPoint       newPositionForArrow_;
  CGFloat       currArcForArrow_;
}

@property (nonatomic, retain) UIView      * menuArea;
@property (nonatomic, retain) UIImageView * arrow;

- (CGFloat)horizontalLocationFor:(NSUInteger)tabIndex;
- (void)addTabBarArrowAtIndex:(NSUInteger)itemIndex;
- (UIImage *)tabBarImage:(UIImage *)startImage size:(CGSize)targetSize backgroundImage:(UIImage *)backgroundImage;
- (UIImage *)blackFilledImageWithWhiteBackgroundUsing:(UIImage *)startImage;
- (UIImage *)tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage *)backgroundImage;

- (void)setFrameForButtonsBasedOnItemCount;
- (void)setButtonWithTag:(NSInteger)buttonTag origin:(CGPoint)origin;

// Animation Control methods
- (void)pauseLayer:(CALayer *)layer;
- (void)resumeLayer:(CALayer *)layer;
- (void)moveArrowToNewPosition;

@end


@implementation CustomTabBar

@synthesize buttons           = buttons_;
@synthesize previousItemIndex = previousItemIndex_;

@synthesize menuArea            = menuArea_;
@synthesize arrow               = arrow_;

- (void)dealloc {
  self.buttons             = nil;
  self.menuArea            = nil;
  self.arrow               = nil;
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
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
               delegate:(NSObject <CustomTabBarDelegate> *)tabBarDelegate {
  if (self = [super init]) {
    // The tag allows callers with multiple controls to distinguish between them
    [self setTag:objectTag];
    
    delegate_ = tabBarDelegate;
    
    // Set background
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:kPMINTabBarBackground]]];
    [self setOpaque:NO];
    
    CGFloat menuAreaHeight = kTabBarHeight - kTabBarItemSize / 2.f - 8.f;
    menuArea_ = [UIView alloc];
    [menuArea_ initWithFrame:CGRectMake(0.f, kTabBarHeight - menuAreaHeight, kTabBarWdith, menuAreaHeight)];
    [self addSubview:menuArea_];
    
    // Initalize the array to store buttons
    // And iterate through each item
    buttons_ = [[NSMutableArray alloc] initWithCapacity:itemCount];
    for (NSUInteger i = 0; i < itemCount; ++i) {
      UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
      [button setImage:[delegate_ iconFor:i] forState:UIControlStateNormal];
      
      // Register for touch events
      [button addTarget:self action:@selector(touchDownAction:)     forControlEvents:UIControlEventTouchDown];
      [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
      [button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchUpOutside];
      [button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchDragOutside];
      [button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchDragInside];
      
      // Add the button to |buttons_| array
      [buttons_ addObject:button];
      [self.menuArea addSubview:button];
    }
    
    // Calculate |triangleHypotenuse_|
    CGFloat tabAreaHalfHeight = kTabBarHeight / 2.f;
    CGFloat tabAreaHalfWidth  = kTabBarWdith  / 2.f;
    triangleHypotenuse_       = (pow(tabAreaHalfHeight, 2) + pow(tabAreaHalfWidth, 2)) / kTabBarHeight;
    
    // Set frame for button, based on |itemCount|
    [self setFrameForButtonsBasedOnItemCount];
    
    // Top Circle Arrow
    arrow_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kPMINTabBarArrow]];
    UIButton * button = [buttons_ objectAtIndex:0];
    [arrow_ setFrame:button.frame];
    [self.menuArea addSubview:arrow_];
    
    CGFloat radius         = triangleHypotenuse_;
    CGFloat centerOriginY  = triangleHypotenuse_;
    newPositionForArrow_   = CGPointMake(button.frame.origin.x + kTabBarItemSize / 2.f,
                                         button.frame.origin.y + kTabBarItemSize / 2.f);
    currArcForArrow_       = M_PI + asinf((centerOriginY - newPositionForArrow_.y) / radius);
    self.previousItemIndex = 0;
    button = nil;
  }
  return self;
}

// Only light the selected button area
- (void)dimAllButtonsExcept:(UIButton *)selectedButton {
  for (UIButton * button in buttons_) {
    if (button == selectedButton) {
      [button setSelected:YES];
      [button setHighlighted:button.selected ? NO : YES];
      [button setTag:kSelectedTabItemTag];
      
      // Generate new postion for |arrow_|
      CGPoint newPosition = button.frame.origin;
      newPosition.x += kTabBarItemSize / 2.f;
      newPosition.y += kTabBarItemSize / 2.f;
      newPositionForArrow_ = newPosition;
    }
    else {
      [button setSelected:NO];
      [button setHighlighted:NO];
      [button setTag:0];
    }
  }
}

- (void)touchDownAction:(UIButton *)button {
  [self dimAllButtonsExcept:button];
  [self moveArrowToNewPosition];
  
  NSInteger newSelectedItemIndex = [buttons_ indexOfObject:button];
  if ([delegate_ respondsToSelector:@selector(touchDownAtItemAtIndex:withPreviousItemIndex:)])
    [delegate_ touchDownAtItemAtIndex:newSelectedItemIndex withPreviousItemIndex:self.previousItemIndex];
  self.previousItemIndex = newSelectedItemIndex;
}

- (void)touchUpInsideAction:(UIButton *)button {
  [self dimAllButtonsExcept:button];
  
  if ([delegate_ respondsToSelector:@selector(touchUpInsideItemAtIndex:)])
    [delegate_ touchUpInsideItemAtIndex:[buttons_ indexOfObject:button]];
}

- (void)otherTouchesAction:(UIButton*)button {
  [self dimAllButtonsExcept:button];
}

- (void)selectItemAtIndex:(NSInteger)index {
  UIButton * button = [buttons_ objectAtIndex:index];
  [self dimAllButtonsExcept:button];
}

// Get position.x of the selected tab
- (CGFloat)horizontalLocationFor:(NSUInteger)tabIndex {
  UIImageView * tabBarArrow = (UIImageView *)[self viewWithTag:kTabArrowImageTag];
  
  // A single tab item's width is the same as the button's width
  UIButton * button = [buttons_ objectAtIndex:tabIndex];
  CGFloat tabItemWidth = button.frame.size.width;
  
  // A half width is tabItemWidth divided by 2 minus half the width of the arrow
  CGFloat halfTabItemWidth = (tabItemWidth / 2) - (tabBarArrow.frame.size.width / 2);
  
  // The horizontal location is the index times the width plus a half width
  //
  //    __^__
  //   |     |
  //    -----
  //
  return button.frame.origin.x + halfTabItemWidth;
}

// Add TabBar Arrow Image
- (void)addTabBarArrowAtIndex:(NSUInteger)itemIndex {
  UIImageView * tabBarArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kPMINTabBarArrow]];
  [tabBarArrow setTag:kTabArrowImageTag];
  [tabBarArrow setFrame:CGRectMake([self horizontalLocationFor:itemIndex] - kTabBarItemSize / 2.f,
                                   0.f,
                                   tabBarArrow.frame.size.width,
                                   tabBarArrow.frame.size.height)];
  [self insertSubview:tabBarArrow atIndex:1];
  [tabBarArrow release];
}

// Create a tab bar image
- (UIImage *)tabBarImage:(UIImage *)startImage
                    size:(CGSize)targetSize
         backgroundImage:(UIImage *)backgroundImageSource {
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
  UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.f);
  // Draw the new tab bar image at the center
  [tabBarImage drawInRect:CGRectMake((targetSize.width / 2.f) - (startImage.size.width / 2.f),
                                     (targetSize.height / 2.f) - (startImage.size.height / 2.f),
                                     startImage.size.width,
                                     startImage.size.height)];
  // Generate a new image
  UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return resultImage;
}

// Convert the image's fill color to black and background to white
- (UIImage *)blackFilledImageWithWhiteBackgroundUsing:(UIImage *)startImage {
  // Create the proper sized rect
  CGRect imageRect = CGRectMake(0.f, 0.f, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
  
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
                           backgroundImage:(UIImage*)backgroundImage {
  UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.f);
  
  if (backgroundImage) {
    // Draw the background image centered
    [backgroundImage drawInRect:CGRectMake((targetSize.width - CGImageGetWidth(backgroundImage.CGImage)) / 2.f,
                                           (targetSize.height - CGImageGetHeight(backgroundImage.CGImage)) / 2.f,
                                           CGImageGetWidth(backgroundImage.CGImage),
                                           CGImageGetHeight(backgroundImage.CGImage))];
  } else {
    [[UIColor lightGrayColor] set];
    UIRectFill(CGRectMake(0.f, 0.f, targetSize.width, targetSize.height));
  }
  
  UIImage * finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return finalBackgroundImage;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
  CGFloat itemWidth = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)  ? self.window.frame.size.height : self.window.frame.size.width) / buttons_.count;
  // horizontalOffset tracks the x value
  CGFloat horizontalOffset = 0;
  
  // Iterate through each button
  for (UIButton * button in buttons_) {
    // Set the button's x offset
    button.frame = CGRectMake(horizontalOffset, 0.f, button.frame.size.width, button.frame.size.height);
    horizontalOffset += itemWidth;
  }
  
  // Move the arrow to the new button location
  UIButton * selectedButton = (UIButton *)[self viewWithTag:kSelectedTabItemTag];
  [self dimAllButtonsExcept:selectedButton];
}

#pragma mark - Private Methods

- (void)setFrameForButtonsBasedOnItemCount {
  //
  //    ______|tabAreaHalfWidth|
  //    |
  //    |  |
  //    v  | <- |tabBarHalfHeight|
  // ---a--------- <- bottom of window (kViewHeight)
  // \     |
  //  c <---|triangleHypotenuse|: distance to Ball Center
  //   \   |b: <- |fixValue|
  //    \ ß|
  //     \/|
  //      \|
  //
  //   |degree|    = |ß|
  //   |triangleA| = |fixValue| + <distance from POINT pos Y to bottom of window>
  //   |triangleB| = |distance from POINT pos X to center line|
  //
  CGFloat tabAreaHalfHeight = kTabBarHeight / 2.f;
  CGFloat tabAreaHalfWidth  = kTabBarWdith  / 2.f;
  CGFloat buttonRadius      = kTabBarItemSize / 2.f;
  CGFloat fixValue          = triangleHypotenuse_ - tabAreaHalfHeight;
  
  switch ([self.buttons count]) {
    case 2: {
      CGFloat degree    = 12.f * M_PI / 180.f; // = 45 * M_PI / 180
      CGFloat triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
      CGFloat triangleB = triangleHypotenuse_ * sinf(degree);
      [self setButtonWithTag:0 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      [self setButtonWithTag:1 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      break;
    }
      
    case 3: {
      CGFloat degree    = M_PI / 10.f; // 18.f * M_PI / 180.f
      CGFloat triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
      CGFloat triangleB = triangleHypotenuse_ * sinf(degree);
      [self setButtonWithTag:0 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      [self setButtonWithTag:1 origin:CGPointMake(tabAreaHalfWidth - buttonRadius,
                                                  tabAreaHalfHeight - triangleHypotenuse_ + fixValue - buttonRadius)];
      [self setButtonWithTag:2 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      break;
    }
      
    case 4:
    default: {
      CGFloat degree    = M_PI / 9.f; // 20.f * M_PI / 180.f
      CGFloat triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
      CGFloat triangleB = triangleHypotenuse_ * sinf(degree);
      [self setButtonWithTag:0 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      [self setButtonWithTag:3 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      
      degree    = M_PI / 20.f; // 9.f * M_PI / 180.f
      triangleA = triangleHypotenuse_ * cosf(degree) - fixValue;
      triangleB = triangleHypotenuse_ * sinf(degree);
      [self setButtonWithTag:1 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      [self setButtonWithTag:2 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      break;
    }
  }
}

// Set Frame for button with special tag
- (void)setButtonWithTag:(NSInteger)buttonTag origin:(CGPoint)origin {
  UIButton * button = [self.buttons objectAtIndex:buttonTag];
  [button setFrame:CGRectMake(origin.x, origin.y, kTabBarItemSize, kTabBarItemSize)];
  button = nil;
}

#pragma mark - Animation Control Methods

-(void)pauseLayer:(CALayer*)layer {
  CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
  layer.speed = 0.f;
  layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer {
  CFTimeInterval pausedTime = [layer timeOffset];
  layer.speed = 1.f;
  layer.timeOffset = 0.f;
  layer.beginTime = 0.f;
  CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
  layer.beginTime = timeSincePause;
}

- (void)moveArrowToNewPosition {
  CGFloat tabAreaHalfHeight  = kTabBarHeight / 2.f;
  CGFloat tabAreaHalfWidth   = kTabBarWdith  / 2.f;
  CGFloat triangleHypotenuse = (pow(tabAreaHalfHeight, 2) + pow(tabAreaHalfWidth, 2)) / kTabBarHeight;
  
  // Values for |path|
  CGFloat radius            = triangleHypotenuse;
  CGFloat centerOriginX     = kTabBarWdith / 2;
  CGFloat centerOriginY     = triangleHypotenuse;
  CGFloat itemCenterOriginX = newPositionForArrow_.x;
  CGFloat itemCenterOriginY = newPositionForArrow_.y;
  CGFloat arc      = asinf((centerOriginY - itemCenterOriginY) / radius);
  CGFloat newAngle = itemCenterOriginX < centerOriginX ? M_PI + arc : M_PI * 2 - arc;
  
  // Path
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddArc(path, NULL,
               centerOriginX, centerOriginY,   // Center point
               radius,                         // Radius
               currArcForArrow_, newAngle, // New angle for the new point
               itemCenterOriginX < self.arrow.frame.origin.x ? YES : NO); // Clock wise or not
  CAKeyframeAnimation * customFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  customFrameAnimation.path = path;
//#ifdef DEBUG
//  CAShapeLayer * pathTrack = [CAShapeLayer layer];
//  pathTrack.path = path;
//	pathTrack.strokeColor = [UIColor blackColor].CGColor;
//	pathTrack.fillColor = [UIColor clearColor].CGColor;
//	pathTrack.lineWidth = 10.0;
//	[self.layer addSublayer:pathTrack];
//#endif
  CGPathRelease(path);
  currArcForArrow_ = newAngle;
  
  customFrameAnimation.delegate = self;
  customFrameAnimation.duration = .3f;
  customFrameAnimation.repeatCount = 1;
  //customFrameAnimation.cumulative = YES;
  //customFrameAnimation.additive = YES;
  customFrameAnimation.calculationMode = kCAAnimationPaced;
  customFrameAnimation.fillMode = kCAFillModeForwards;
//  customFrameAnimation.timingFunctions = timingFunctions;
  customFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  customFrameAnimation.removedOnCompletion = NO;
  [self.arrow.layer addAnimation:customFrameAnimation forKey:@"moveArrow"];
}

#pragma mark - CAAnimation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  // Update the layer's position so that the layer doesn't snap back when the animation completes
  [self.arrow.layer setPosition:newPositionForArrow_];
}

@end
