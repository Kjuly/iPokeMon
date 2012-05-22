//
//  MapAnnotationCalloutViewController.m
//  Mew
//
//  Created by Kaijie Yu on 5/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MapAnnotationCalloutViewController.h"

#import "MEWRoundView.h"
#import <QuartzCore/QuartzCore.h>

@interface MapAnnotationCalloutViewController () {
 @private
  MEWRoundView     * mainView_;
  CAAnimationGroup * loadAnimationGroup_;
  CAAnimationGroup * unloadAnimationGroup_;
  CAAnimationGroup * switchAnimationGroup_;
}

@property (nonatomic, retain) MEWRoundView     * mainView;
@property (nonatomic, retain) CAAnimationGroup * loadAnimationGroup;
@property (nonatomic, retain) CAAnimationGroup * unloadAnimationGroup;
@property (nonatomic, retain) CAAnimationGroup * switchAnimationGroup;

- (void)_releaseSubViews;

@end

@implementation MapAnnotationCalloutViewController

@synthesize mainView             = mainView_;
@synthesize loadAnimationGroup   = loadAnimationGroup_;
@synthesize unloadAnimationGroup = unloadAnimationGroup_;
@synthesize switchAnimationGroup = switchAnimationGroup_;

- (void)dealloc {
  [self _releaseSubViews];
  self.loadAnimationGroup   = nil;
  self.unloadAnimationGroup = nil;
  self.switchAnimationGroup = nil;
  [super dealloc];
}

- (void)_releaseSubViews {
  self.mainView = nil;
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
  CGRect viewFrame = CGRectMake(0.f, 0.f, kMapAnnotationCalloutMainViewSize, kMapAnnotationCalloutMainViewSize);
  [self.view setFrame:viewFrame];
  mainView_ = [[MEWRoundView alloc] initWithFrame:viewFrame
                                  foregroundColor:kMEWColorTypeBlack
                                  foregroundAlpha:.9f
                                  backgroundColor:kMEWColorTypeWhite
                                  backgroundAlpha:.5f];
  [mainView_ setAlpha:0.f];
  [self.view addSubview:mainView_];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  [self _releaseSubViews];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Public Methods

// load view
- (void)loadViewAnimated:(BOOL)animated {
  [self.mainView setAlpha:1.f];
  // set up animations if it is not initialized
  if (self.loadAnimationGroup == nil) {
    CGFloat duration = .3f;
    // scale
    CAKeyframeAnimation * animationScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.duration = duration;
    animationScale.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:.1f],
                             [NSNumber numberWithFloat:.8f],
                             [NSNumber numberWithFloat:1.f], nil];
    
    // fade
    CABasicAnimation * animationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationFade.duration = duration * .4f;
    animationFade.fromValue = [NSNumber numberWithFloat:0.f];
    animationFade.toValue = [NSNumber numberWithFloat:1.f];
    animationFade.fillMode = kCAFillModeForwards;
    
    self.loadAnimationGroup = [CAAnimationGroup animation];
    self.loadAnimationGroup.delegate = self;
    [self.loadAnimationGroup setValue:@"load" forKey:@"animationType"];
    [self.loadAnimationGroup setDuration:duration];
    NSArray * animations = [[NSArray alloc] initWithObjects:animationScale, animationFade, nil];
    [self.loadAnimationGroup setAnimations:animations];
    [animations release];
    [self.loadAnimationGroup setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  }
  [self.mainView.layer addAnimation:self.loadAnimationGroup forKey:@"loadAnimation"];
}

// unload view
- (void)unloadViewAnimated:(BOOL)animated {
  // set up animations if it is not initialized
  if (self.unloadAnimationGroup == nil) {
    CGFloat duration = .3f;
    // scale
    CAKeyframeAnimation * animationScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.duration = duration;
    animationScale.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:1.f],
                             [NSNumber numberWithFloat:1.2f], nil];
    
    // fade
    CABasicAnimation * animationFade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animationFade.duration = duration * .8f;
    animationFade.fromValue = [NSNumber numberWithFloat:1.f];
    animationFade.toValue = [NSNumber numberWithFloat:0.f];
    animationFade.fillMode = kCAFillModeForwards;
    
    self.unloadAnimationGroup = [CAAnimationGroup animation];
    self.unloadAnimationGroup.delegate = self;
    [self.unloadAnimationGroup setValue:@"unload" forKey:@"animationType"];
    [self.unloadAnimationGroup setDuration:duration];
    NSArray * animations = [[NSArray alloc] initWithObjects:animationScale, animationFade, nil];
    [self.unloadAnimationGroup setAnimations:animations];
    [animations release];
    [self.unloadAnimationGroup setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  }
  [self.mainView.layer addAnimation:self.unloadAnimationGroup forKey:@"unloadAnimation"];
}

// switch view
- (void)switchViewAnimated:(BOOL)animated {
  // set up animations if it is not initialized
  if (self.switchAnimationGroup == nil) {
    CGFloat duration = .3f;
    CAKeyframeAnimation * animationScale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animationScale.duration = duration;
    animationScale.values = [NSArray arrayWithObjects:
                             [NSNumber numberWithFloat:1.f],
                             [NSNumber numberWithFloat:.6f],
                             [NSNumber numberWithFloat:1.f], nil];
    animationScale.timingFunctions =
    [NSArray arrayWithObjects:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], nil];
    
    self.switchAnimationGroup = [CAAnimationGroup animation];
    self.switchAnimationGroup.delegate = self;
    [self.switchAnimationGroup setValue:@"switch" forKey:@"animationType"];
    [self.switchAnimationGroup setDuration:duration];
    NSArray * animations = [[NSArray alloc] initWithObjects:animationScale, nil];
    [self.switchAnimationGroup setAnimations:animations];
    [animations release];
  }
  [self.mainView.layer addAnimation:self.switchAnimationGroup forKey:@"switchAnimation"];
}

#pragma mark - CoreAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if ([[anim valueForKey:@"animationType"] isEqualToString:@"unload"]) {
    [self.mainView setAlpha:0.f];
    [self.view removeFromSuperview];
  }
}

@end
