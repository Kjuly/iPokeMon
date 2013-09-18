//
//  MapAnnotationCalloutViewController.m
//  iPokeMon
//
//  Created by Kaijie Yu on 5/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MapAnnotationCalloutViewController.h"

#import "GlobalRender.h"
#import "MEWMapAnnotationCalloutBottomView.h"
#import <QuartzCore/QuartzCore.h>

@interface MapAnnotationCalloutViewController () {
 @private
  UIView                            * mainView_;
  UILabel                           * title_;
  UILabel                           * description_;
  MEWMapAnnotationCalloutBottomView * bottomView_;
  CAAnimationGroup * loadAnimationGroupForBottomView_;
  CAAnimationGroup * loadAnimationGroupForMainView_;
  CAAnimationGroup * switchAnimationGroupForMainView_;
  CAAnimationGroup * unloadAnimationGroup_;
}

@property (nonatomic, strong) UIView                            * mainView;
@property (nonatomic, strong) UILabel                           * title;
@property (nonatomic, strong) UILabel                           * description;
@property (nonatomic, strong) MEWMapAnnotationCalloutBottomView * bottomView;
@property (nonatomic, strong) CAAnimationGroup * loadAnimationGroupForBottomView;
@property (nonatomic, strong) CAAnimationGroup * loadAnimationGroupForMainView;
@property (nonatomic, strong) CAAnimationGroup * switchAnimationGroupForMainView;
@property (nonatomic, strong) CAAnimationGroup * unloadAnimationGroup;

@end


@implementation MapAnnotationCalloutViewController

@synthesize mainView             = mainView_;
@synthesize title                = title_;
@synthesize description          = description_;
@synthesize bottomView           = bottomView_;
@synthesize loadAnimationGroupForBottomView   = loadAnimationGroupForBottomView_;
@synthesize loadAnimationGroupForMainView     = loadAnimationGroupForMainView_;
@synthesize switchAnimationGroupForMainView   = switchAnimationGroupForMainView_;
@synthesize unloadAnimationGroup              = unloadAnimationGroup_;

- (id)init
{
  return (self = [super init]);
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  CGRect viewFrame = (CGRect){CGPointZero, {kMapAnnotationCalloutViewWidth, kMapAnnotationCalloutViewHeight}};
  [self.view setFrame:viewFrame];
  
  viewFrame.size.height -= 12.f;
  CGFloat bottomViewHeight = 10.f;
  CGRect bottomViewFrame = CGRectMake(0.f, kMapAnnotationCalloutViewHeight - bottomViewHeight, kMapAnnotationCalloutViewWidth, bottomViewHeight);
  
  // main view
  mainView_ = [[UIView alloc] initWithFrame:viewFrame];
  [mainView_ setBackgroundColor:[UIColor colorWithWhite:0.f alpha:.8f]];
  [self.view addSubview:mainView_];
  
  CGFloat margin = 10.f;
  CGRect titleFrame = CGRectMake(margin, margin, kMapAnnotationCalloutViewWidth - margin * 2, 30.f);
  CGRect descriptionFrame = CGRectMake(margin, margin + 30.f, kMapAnnotationCalloutViewWidth - margin * 2, 30.f);
  
  // title
  title_ = [[UILabel alloc] initWithFrame:titleFrame];
  [title_ setBackgroundColor:[UIColor clearColor]];
  [title_ setTextColor:[GlobalRender textColorOrange]];
  [title_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
  [self.mainView addSubview:title_];
  
  // description
  description_ = [[UILabel alloc] initWithFrame:descriptionFrame];
  [description_ setBackgroundColor:[UIColor clearColor]];
  [description_ setTextColor:[GlobalRender textColorTitleWhite]];
  [description_ setFont:[GlobalRender textFontNormalInSizeOf:14.f]];
  [description_ setNumberOfLines:0];
  [description_ setLineBreakMode:NSLineBreakByCharWrapping];
//  [self.mainView addSubview:description_];
  
  // bottom view
  bottomView_ = [[MEWMapAnnotationCalloutBottomView alloc] initWithFrame:bottomViewFrame];
  [self.view addSubview:bottomView_];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.mainView    = nil;
  self.title       = nil;
  self.description = nil;
  self.bottomView  = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// load view
- (void)loadViewAnimated:(BOOL)animated
{
  [self.mainView setAlpha:1.f];
  
  // set up animation group for |bottomView_| if it is not initialized
  if (self.loadAnimationGroupForBottomView == nil) {
    CGFloat duration = .3f;
    // move // transform.translation.y also works
    CABasicAnimation * animationMove = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animationMove.duration = duration;
    [animationMove setFromValue:[NSNumber numberWithFloat:kMapAnnotationCalloutViewHeight]];
    [animationMove setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    animationMove.fillMode = kCAFillModeForwards;
    
    // fade
    CABasicAnimation * animationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationFade.duration = duration * .4f;
    animationFade.fromValue = [NSNumber numberWithFloat:0.f];
    animationFade.toValue = [NSNumber numberWithFloat:1.f];
    animationFade.fillMode = kCAFillModeForwards;
    
    self.loadAnimationGroupForBottomView = [CAAnimationGroup animation];
    self.loadAnimationGroupForBottomView.delegate = self;
    [self.loadAnimationGroupForBottomView setValue:@"loadBottomView" forKey:@"animationType"];
    [self.loadAnimationGroupForBottomView setDuration:duration];
    NSArray * animations = [[NSArray alloc] initWithObjects:animationMove, animationFade, nil];
    [self.loadAnimationGroupForBottomView setAnimations:animations];
    [self.loadAnimationGroupForBottomView setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.loadAnimationGroupForBottomView setFillMode:kCAFillModeForwards];
  }
  
  // set up animation group for |mainView_| if it is not initialized
  if (self.loadAnimationGroupForMainView == nil) {
    CGFloat duration = .3f;
    // move
    CABasicAnimation * animationMove = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animationMove.duration = duration;
    [animationMove setFromValue:[NSNumber numberWithFloat:self.view.frame.origin.y]];
    [animationMove setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    animationMove.fillMode = kCAFillModeForwards;
    
    // fade
    CABasicAnimation * animationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationFade.duration = duration * .4f;
    animationFade.fromValue = [NSNumber numberWithFloat:0.f];
    animationFade.toValue = [NSNumber numberWithFloat:1.f];
    animationFade.fillMode = kCAFillModeForwards;
    
    self.loadAnimationGroupForMainView = [CAAnimationGroup animation];
    self.loadAnimationGroupForMainView.delegate = self;
    [self.loadAnimationGroupForMainView setValue:@"loadMainView" forKey:@"animationType"];
    [self.loadAnimationGroupForMainView setDuration:duration];
    NSArray * animations = [[NSArray alloc] initWithObjects:animationMove, animationFade, nil];
    [self.loadAnimationGroupForMainView setAnimations:animations];
    [self.loadAnimationGroupForMainView setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.loadAnimationGroupForBottomView setFillMode:kCAFillModeForwards];
  }
  [self.bottomView.layer addAnimation:self.loadAnimationGroupForBottomView
                               forKey:@"loadAnimationForBottomView"];
  [self.mainView.layer addAnimation:self.loadAnimationGroupForMainView
                             forKey:@"loadAnimationForMainView"];
}

// unload view
- (void)unloadViewAnimated:(BOOL)animated
{
  // set up animation group for |mainView_| if it is not initialized
  if (self.unloadAnimationGroup == nil) {
    CGFloat duration = .3f;
    // scale
    CAKeyframeAnimation * animationScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.duration = duration;
    animationScale.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:1.f],
                             [NSNumber numberWithFloat:1.05f], nil];
    animationScale.fillMode = kCAFillModeForwards;
    
    // fade
    CABasicAnimation * animationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationFade.duration = duration * .8f;
    animationFade.fromValue = [NSNumber numberWithFloat:1.f];
    animationFade.toValue = [NSNumber numberWithFloat:0.f];
    animationFade.fillMode = kCAFillModeForwards;
    
    self.unloadAnimationGroup = [CAAnimationGroup animation];
    self.unloadAnimationGroup.delegate = self;
    [self.unloadAnimationGroup setValue:@"unloadAll" forKey:@"animationType"];
    [self.unloadAnimationGroup setDuration:duration];
    NSArray * animations = [[NSArray alloc] initWithObjects:animationScale, animationFade, nil];
    [self.unloadAnimationGroup setAnimations:animations];
    [self.unloadAnimationGroup setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.unloadAnimationGroup setFillMode:kCAFillModeForwards];
  }
  [self.view.layer addAnimation:self.unloadAnimationGroup
                         forKey:@"unloadAnimationForAll"];
}

// switch view
- (void)switchViewAnimated:(BOOL)animated
{
  // set up animation group for |mainView_| if it is not initialized
  if (self.switchAnimationGroupForMainView == nil) {
    CGFloat duration = .6f;
//    CAKeyframeAnimation * animationScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
//    animationScale.duration = duration;
//    animationScale.values = [NSArray arrayWithObjects:
//                             [NSNumber numberWithFloat:1.f],
//                             [NSNumber numberWithFloat:.6f],
//                             [NSNumber numberWithFloat:1.f], nil];
//    animationScale.timingFunctions =
//    [NSArray arrayWithObjects:
//     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
//     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], nil];
    
    // fade
    CAKeyframeAnimation * animationFade = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animationFade.duration = duration;
    animationFade.values = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:1.f],
                            [NSNumber numberWithFloat:.5f],
                            [NSNumber numberWithFloat:1.f], nil];
    animationFade.timingFunctions =
    [NSArray arrayWithObjects:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], nil];
    
    self.switchAnimationGroupForMainView = [CAAnimationGroup animation];
    self.switchAnimationGroupForMainView.delegate = self;
    [self.switchAnimationGroupForMainView setValue:@"switchMainView" forKey:@"animationType"];
    [self.switchAnimationGroupForMainView setDuration:duration];
    NSArray * animations = [[NSArray alloc] initWithObjects:animationFade, nil];
    [self.switchAnimationGroupForMainView setAnimations:animations];
  }
  [self.mainView.layer addAnimation:self.switchAnimationGroupForMainView
                             forKey:@"switchAnimationForMainView"];
}

// configure view
- (void)configureWithTitle:(NSString *)title
               description:(NSString *)description
{
  [self.title setText:title];
  CGFloat margin = 10.f;
  CGRect descriptionFrame = CGRectMake(margin, margin + 30.f, kMapAnnotationCalloutViewWidth - margin * 2, 30.f);
  [self.description setFrame:descriptionFrame];
  [self.description setText:description];
  [self.description sizeToFit];
}

#pragma mark - CoreAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim
                finished:(BOOL)flag
{
  if ([[anim valueForKey:@"animationType"] isEqualToString:@"unloadAll"]) {
//    [self.mainView setAlpha:0.f];
    [self.view removeFromSuperview];
  }
}

@end
