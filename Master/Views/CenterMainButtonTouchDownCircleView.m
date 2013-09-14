//
//  CenterMainButtonTouchDownCircleView.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "CenterMainButtonTouchDownCircleView.h"

#import <QuartzCore/QuartzCore.h>

@interface CenterMainButtonTouchDownCircleView () {
 @private
  UIImageView      * backgroundImageView_;
  UIImageView      * foregroundImageView_;
  CAShapeLayer     * circle_;
  CABasicAnimation * drawAnimation_;
}

@property (nonatomic, strong) UIImageView      * backgroundImageView;
@property (nonatomic, strong) UIImageView      * foregroundImageView;
@property (nonatomic, strong) CAShapeLayer     * circle;
@property (nonatomic, strong) CABasicAnimation * drawAnimation;

@end


@implementation CenterMainButtonTouchDownCircleView

@synthesize backgroundImageView = backgroundImageView_;
@synthesize foregroundImageView = foregroundImageView_;
@synthesize circle              = circle_;
@synthesize drawAnimation       = drawAnimation_;


- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setBackgroundColor:[UIColor clearColor]];
    
    CGFloat radius = kCenterMainButtonTouchDownCircleViewSize / 2;
    CGFloat startAngle = 0.f;
//    CGFloat byAngle    = 0.01f;
    CGFloat endAngle   = 1.f;
    CGFloat pathStartAngle = 2.965f;
    
    self.circle = [CAShapeLayer layer];
    [circle_ setPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
                                                    radius:radius
                                                startAngle:pathStartAngle
                                                  endAngle:M_PI * 2 + pathStartAngle
                                                 clockwise:YES].CGPath];
    [circle_ setPosition:CGPointZero];
    [circle_ setFillColor:[UIColor clearColor].CGColor];
    [circle_ setStrokeColor:[UIColor blueColor].CGColor];
    [circle_ setLineWidth:100.f];
//    [self.layer addSublayer:circle_];
    
    // Set background & foreground image
    // Background
    backgroundImageView_ = [[UIImageView alloc] initWithImage:
                            [UIImage imageNamed:kPMINMainViewCenterCircleBackgound]];
    [backgroundImageView_ setAlpha:0.f];
    [self addSubview:backgroundImageView_];
    // Foreground
    foregroundImageView_ = [[UIImageView alloc] initWithImage:
                            [UIImage imageNamed:kPMINMainViewCenterCircle]];
    [foregroundImageView_ setAlpha:0.f];
    foregroundImageView_.layer.mask = circle_;
    [self addSubview:foregroundImageView_];
    
    // Change the model layer's property first
    circle_.strokeStart = startAngle;
    circle_.strokeEnd = endAngle;
    // Draw animation
    self.drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [drawAnimation_ setDuration:5.f];
    [drawAnimation_ setRepeatCount:1.f];
    //  [drawAnimation setRemovedOnCompletion:NO];
    [drawAnimation_ setFromValue:[NSNumber numberWithFloat:startAngle]];
//    [drawAnimation_ setByValue:[NSNumber numberWithFloat:byAngle]];
    [drawAnimation_ setToValue:[NSNumber numberWithFloat:endAngle]];
    [drawAnimation_ setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*- (void)drawRect:(CGRect)rect
{
}*/

#pragma mark - Public Methods

- (void)startAnimation {
  NSLog(@"START LOADING");
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.backgroundImageView setAlpha:1.f];
                   }
                   completion:^(BOOL finished) {
                     [self.circle addAnimation:self.drawAnimation forKey:@"DrawCircleAnimation"];
                     [self.foregroundImageView setAlpha:1.f];
                   }];
}

- (void)stopAnimation {
  NSLog(@"STOP LOADING");
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:(UIViewAnimationOptions)UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.foregroundImageView setAlpha:0.f];
                     [self.backgroundImageView setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     [self.circle removeAnimationForKey:@"DrawCircleAnimation"];
                     [self removeFromSuperview];
                   }];
}

@end
