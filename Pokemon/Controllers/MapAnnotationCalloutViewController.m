//
//  MapAnnotationCalloutViewController.m
//  Mew
//
//  Created by Kaijie Yu on 5/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MapAnnotationCalloutViewController.h"

#import "MEWMapAnnotationCalloutBottomView.h"
#import <QuartzCore/QuartzCore.h>

@interface MapAnnotationCalloutViewController () {
 @private
  UIView                            * mainView_;
  MEWMapAnnotationCalloutBottomView * bottomView_;
  CAAnimationGroup * loadAnimationGroupForBottomView_;
  CAAnimationGroup * loadAnimationGroupForMainView_;
  CAAnimationGroup * switchAnimationGroupForMainView_;
  CAAnimationGroup * unloadAnimationGroup_;
}

@property (nonatomic, retain) UIView                            * mainView;
@property (nonatomic, retain) MEWMapAnnotationCalloutBottomView * bottomView;
@property (nonatomic, retain) CAAnimationGroup * loadAnimationGroupForBottomView;
@property (nonatomic, retain) CAAnimationGroup * loadAnimationGroupForMainView;
@property (nonatomic, retain) CAAnimationGroup * switchAnimationGroupForMainView;
@property (nonatomic, retain) CAAnimationGroup * unloadAnimationGroup;

- (void)_releaseSubViews;

@end

@implementation MapAnnotationCalloutViewController

@synthesize mainView             = mainView_;
@synthesize bottomView           = bottomView_;
@synthesize loadAnimationGroupForBottomView   = loadAnimationGroupForBottomView_;
@synthesize loadAnimationGroupForMainView     = loadAnimationGroupForMainView_;
@synthesize switchAnimationGroupForMainView   = switchAnimationGroupForMainView_;
@synthesize unloadAnimationGroup              = unloadAnimationGroup_;

- (void)dealloc {
  self.loadAnimationGroupForBottomView   = nil;
  self.loadAnimationGroupForMainView     = nil;
  self.switchAnimationGroupForMainView   = nil;
  self.unloadAnimationGroup              = nil;
  [self _releaseSubViews];
  [super dealloc];
}

- (void)_releaseSubViews {
  self.mainView   = nil;
  self.bottomView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  CGRect viewFrame = CGRectMake(0.f, 0.f, kMapAnnotationCalloutViewWidth, kMapAnnotationCalloutViewHeight);
  [self.view setFrame:viewFrame];
  
  viewFrame.size.height -= 12.f;
  CGFloat bottomViewHeight = 10.f;
  CGRect bottomViewFrame = CGRectMake(0.f, kMapAnnotationCalloutViewHeight - bottomViewHeight, kMapAnnotationCalloutViewWidth, bottomViewHeight);
  
  mainView_ = [[UIView alloc] initWithFrame:viewFrame];
  [mainView_ setBackgroundColor:[UIColor colorWithWhite:0.f alpha:.8f]];
//  [mainView_ setAlpha:0.f];
  [self.view addSubview:mainView_];
  
  bottomView_ = [[MEWMapAnnotationCalloutBottomView alloc] initWithFrame:bottomViewFrame];
  [self.view addSubview:bottomView_];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self _releaseSubViews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// load view
- (void)loadViewAnimated:(BOOL)animated {
  [self.mainView setAlpha:1.f];
  
  // set up animation group for |bottomView_| if it is not initialized
  if (self.loadAnimationGroupForBottomView == nil) {
    CGFloat duration = .3f;
    // move
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
    [animations release];
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
    [animations release];
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
- (void)unloadViewAnimated:(BOOL)animated {
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
    [animations release];
    [self.unloadAnimationGroup setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.unloadAnimationGroup setFillMode:kCAFillModeForwards];
  }
  [self.view.layer addAnimation:self.unloadAnimationGroup
                         forKey:@"unloadAnimationForAll"];
}

// switch view
- (void)switchViewAnimated:(BOOL)animated {
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
    [animations release];
  }
  [self.mainView.layer addAnimation:self.switchAnimationGroupForMainView
                             forKey:@"switchAnimationForMainView"];
}

#pragma mark - CoreAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if ([[anim valueForKey:@"animationType"] isEqualToString:@"unloadAll"]) {
//    [self.mainView setAlpha:0.f];
    [self.view removeFromSuperview];
  }
}

@end
