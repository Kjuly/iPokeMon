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
  CAShapeLayer     * circle_;
  CABasicAnimation * drawAnimation_;
}

@property (nonatomic, retain) CAShapeLayer     * circle;
@property (nonatomic, retain) CABasicAnimation * drawAnimation;

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
- (CGPathRef)getStartToEndPathForSelectedItem:(UIButton *)selectedItem;

@end


@implementation CustomTabBar

@synthesize buttons = buttons_;

@synthesize circle        = circle_;
@synthesize drawAnimation = drawAnimation_;

- (void)dealloc
{
  [buttons_ release];
  
  self.circle        = nil;
  self.drawAnimation = nil;
  
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
               delegate:(NSObject <CustomTabBarDelegate> *)tabBarDelegate
{
  if (self = [super init]) {
    // The tag allows callers with multiple controls to distinguish between them
    [self setTag:objectTag];
    
    delegate_ = tabBarDelegate;
    
    // Set background
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:
                                         [UIImage imageNamed:[NSString stringWithFormat:@"TabView%dTabsCircleBarBackground.png", itemCount]]];
    [self addSubview:backgroundImageView];
    [backgroundImageView release];
    
    // Set mask
    CGFloat startAngle = 0.0f;
    //    CGFloat byAngle    = 0.01f;
    CGFloat endAngle   = 1.0f;
    
    self.circle = [CAShapeLayer layer];
    [circle_ setPath:nil];
    [circle_ setPosition:CGPointMake(0.0f, 0.0f)];
    [circle_ setFillColor:[UIColor clearColor].CGColor];
    [circle_ setStrokeColor:[UIColor blueColor].CGColor];
    [circle_ setLineWidth:50.0f];
    
    // Set button circle foreground
    UIImageView * foregroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"TabView%dTabsCircleBarCircleWithLine.png", itemCount]]];
    foregroundImageView.layer.mask = circle_;
    [self addSubview:foregroundImageView];
    [foregroundImageView release];
    
    // Change the model layer's property first
    circle_.strokeStart = startAngle;
    circle_.strokeEnd = endAngle;
    // Draw animation
    self.drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [drawAnimation_ setDuration:0.3f];
    [drawAnimation_ setRepeatCount:1.0f];
    //  [drawAnimation setRemovedOnCompletion:NO];
    [drawAnimation_ setFromValue:[NSNumber numberWithFloat:startAngle]];
    //    [drawAnimation_ setByValue:[NSNumber numberWithFloat:byAngle]];
    [drawAnimation_ setToValue:[NSNumber numberWithFloat:endAngle]];
    [drawAnimation_ setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    // Add the animation, but stop it 
//    [self.circle addAnimation:self.drawAnimation forKey:@"DrawCircleAnimation"];
//    [self pauseLayer:self.circle];
    
    
    // Initalize the array to store buttons
    // And iterate through each item
    buttons_ = [[NSMutableArray alloc] initWithCapacity:itemCount];
    for (NSUInteger i = 0; i < itemCount; ++i) {
      // |TabBarBackgroundSelected| size
      CGSize TabBarBackgroundSelectedSize = CGSizeMake(44.0f, 44.0f);
      UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
      
      // Set image
      UIImage * rawButtonImage     = [delegate_ iconFor:i];
      UIImage * buttonImage        = [self tabBarImage:rawButtonImage
                                                  size:button.frame.size
                                       backgroundImage:[UIImage imageNamed:@"PoketchTabBarIconDefaultMask.png"]];
      UIImage * buttonPressedImage = [self tabBarImage:rawButtonImage
                                                  size:TabBarBackgroundSelectedSize
                                       backgroundImage:[UIImage imageNamed:@"PoketchTabBarIconSelectedMask.png"]];
      [button setImage:buttonImage        forState:UIControlStateNormal];
      [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
      [button setImage:buttonPressedImage forState:UIControlStateSelected];
      [button setAdjustsImageWhenHighlighted:NO];
      
      // Register for touch events
      [button addTarget:self action:@selector(touchDownAction:)     forControlEvents:UIControlEventTouchDown];
      [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
      [button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchUpOutside];
      [button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchDragOutside];
      [button addTarget:self action:@selector(otherTouchesAction:)  forControlEvents:UIControlEventTouchDragInside];
      
      // Add the button to |buttons_| array
      [buttons_ addObject:button];
      [self addSubview:button];
    }
    
    // Set frame for button, based on |itemCount|
    [self setFrameForButtonsBasedOnItemCount];
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
      
      // Generate animation path for |circle_| & resume animation
      [self.circle setPath:[self getStartToEndPathForSelectedItem:selectedButton]];
      [self.circle addAnimation:self.drawAnimation forKey:@"DrawCircleAnimation"];
//      [self resumeLayer:self.circle];
      
//      UIImageView * tabBarArrow = (UIImageView *)[self viewWithTag:kTabArrowImageTag];
//      NSUInteger selectedIndex = [buttons_ indexOfObjectIdenticalTo:button];
//      if (tabBarArrow)
//        [UIView animateWithDuration:0.2f
//                              delay:0.0f
//                            options:UIViewAnimationOptionCurveEaseInOut
//                         animations:^{
//                           //CGRect frame = tabBarArrow.frame;
//                           //frame.origin.x = [self horizontalLocationFor:selectedIndex];
//                           [tabBarArrow setFrame:button.frame];
//                         }
//                         completion:nil];
//      else [self addTabBarArrowAtIndex:selectedIndex];
//      tabBarArrow = nil;
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

// Add TabBar Arrow Image
- (void)addTabBarArrowAtIndex:(NSUInteger)itemIndex
{
  UIImageView * tabBarArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TabBarSelectedArrow.png"]];
  [tabBarArrow setTag:kTabArrowImageTag];
  [tabBarArrow setFrame:CGRectMake([self horizontalLocationFor:itemIndex] - 22.0f,
                                   0.0f,
                                   tabBarArrow.frame.size.width,
                                   tabBarArrow.frame.size.height)];
  [self insertSubview:tabBarArrow atIndex:1];
  [tabBarArrow release];
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

#pragma mark - Private Methods

- (void)setFrameForButtonsBasedOnItemCount
{
  CGFloat tabAreaHalfHeight      = kTabBarHeight;
  CGFloat tabAreaHalfWidth       = kTabBarWdith  / 2;
  CGFloat buttonRadius           = 22.0f;
  CGFloat triangleHypotenuse     = tabAreaHalfHeight - 26.0f; // Distance to Ball Center
  
  NSLog(@"%d", self.buttons.count);
  
  switch ([self.buttons count]) {
    case 2: {
      CGFloat degree    = M_PI / 4.0f; // = 45 * M_PI / 180
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      [self setButtonWithTag:0 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleB - buttonRadius)];
      [self setButtonWithTag:1 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleB - buttonRadius)];
      break;
    }
      
    case 3: {      
      CGFloat degree    = 65 * M_PI / 180;
      CGFloat triangleA = triangleHypotenuse * cosf(degree);
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      [self setButtonWithTag:0 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      [self setButtonWithTag:1 origin:CGPointMake(tabAreaHalfWidth - buttonRadius,
                                                  tabAreaHalfHeight - triangleHypotenuse - buttonRadius)];
      [self setButtonWithTag:2 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      break;
    }
      
    case 4:
    default: {
      CGFloat degree    = 65 * M_PI / 180;
      CGFloat triangleA = triangleHypotenuse * cosf(degree);
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      [self setButtonWithTag:0 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      [self setButtonWithTag:3 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      
      degree    = 24 * M_PI / 180;
      triangleA = triangleHypotenuse * cosf(degree);
      triangleB = triangleHypotenuse * sinf(degree);
      [self setButtonWithTag:1 origin:CGPointMake(tabAreaHalfWidth - triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      [self setButtonWithTag:2 origin:CGPointMake(tabAreaHalfWidth + triangleB - buttonRadius,
                                                  tabAreaHalfHeight - triangleA - buttonRadius)];
      break;
    }
  }
}

// Set Frame for button with special tag
- (void)setButtonWithTag:(NSInteger)buttonTag origin:(CGPoint)origin
{
  UIButton * button = [self.buttons objectAtIndex:buttonTag];
  [button setFrame:CGRectMake(origin.x, origin.y, 44.0f, 44.0f)];
  button = nil;
}

#pragma mark - Animation Control Methods

-(void)pauseLayer:(CALayer*)layer
{
  CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
  layer.speed = 0.0;
  layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
  CFTimeInterval pausedTime = [layer timeOffset];
  layer.speed = 1.0;
  layer.timeOffset = 0.0;
  layer.beginTime = 0.0;
  CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
  layer.beginTime = timeSincePause;
}

- (CGPathRef)getStartToEndPathForSelectedItem:(UIButton *)selectedItem
{
  //
  //   |
  // -   o    0 - M_PI * 2
  //   |
  //
  CGFloat triangleHypotenuse = kTabBarHeight - 26.0f; // Distance to Ball Center
  CGFloat centerOriginX      = kTabBarWdith / 2;
  
  CGFloat itemCenterOriginX = selectedItem.frame.origin.x + 22.0f;
  CGFloat itemCenterOriginY = selectedItem.frame.origin.y + 22.0f;
  
  CGFloat arc = asinf((kTabBarHeight - itemCenterOriginY) / triangleHypotenuse);
  
  CGFloat itemCenterAngle = itemCenterOriginX < centerOriginX ? M_PI + arc : M_PI * 2 - arc;
  CGFloat startAngle      = itemCenterAngle - 0.22;
  CGFloat endAngle        = itemCenterAngle + 0.22f;
  
  return [UIBezierPath bezierPathWithArcCenter:CGPointMake(kTabBarWdith / 2, kTabBarHeight)
                                        radius:kTabBarHeight - 25.0f
                                    startAngle:startAngle
                                      endAngle:endAngle
                                     clockwise:YES].CGPath;
}

@end
