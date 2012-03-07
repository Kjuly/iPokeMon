//
//  PokemonEXPBar.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonEXPBar.h"

@interface PokemonEXPBar () {
 @private
  UIImageView  * expBar_;
  UIImageView  * expBarBackground_;
  NSInteger      exp_;
  NSInteger      expMax_;
}

@property (nonatomic, retain) UIImageView  * expBar;
@property (nonatomic, retain) UIImageView  * expBarBackground;
@property (nonatomic, assign) NSInteger      exp;
@property (nonatomic, assign) NSInteger      expMax;

@end

@implementation PokemonEXPBar

@synthesize expBar           = expBar_;
@synthesize expBarBackground = expBarBackground_;
@synthesize exp              = exp_;
@synthesize expMax           = expMax_;

- (void)dealloc
{
  self.expBar           = nil;
  self.expBarBackground = nil;
  
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame EXP:(NSInteger)exp EXPMax:(NSInteger)expMax
{
  if (self = [self initWithFrame:frame]) {
    exp_    = exp;
    expMax_ = expMax;
    
    UIImageView * expBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, 6.f)];
    self.expBarBackground = expBarBackground;
    [expBarBackground release];
    [self.expBarBackground setContentMode:UIViewContentModeScaleAspectFit];
    [self.expBarBackground setImage:[UIImage imageNamed:@"PokemonExpBarBackground.png"]];
    [self addSubview:self.expBarBackground];
    
    CGRect expBarFrame = CGRectMake(0.f, 0.f, frame.size.width * exp / expMax, 6.f);
    UIImageView * expBar = [[UIImageView alloc] initWithFrame:expBarFrame];
    self.expBar = expBar;
    [expBar release];
    [self.expBar setContentMode:UIViewContentModeScaleAspectFit];
    [self.expBar setImage:[UIImage imageNamed:@"PokemonExpBar.png"]];
    [self.expBarBackground addSubview:self.expBar];
  }
  return self;
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

- (NSInteger)exp {
  return exp_;
}

- (NSInteger)expMax {
  return expMax_;
}

- (void)updateExpBarWithExp:(NSInteger)exp
{
  CGRect hpBarFrame = self.expBar.frame;
  hpBarFrame.size.width = self.frame.size.width * exp / self.expMax;
  [UIView animateWithDuration:1.f
                        delay:0.f
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     [self.expBar setFrame:hpBarFrame];
                   }
                   completion:nil];
}

- (void)updateExpBarWithExpMax:(NSInteger)expMax
{
  self.expMax = expMax;
}

@end
