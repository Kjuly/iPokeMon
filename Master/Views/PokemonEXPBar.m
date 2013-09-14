//
//  PokemonEXPBar.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonEXPBar.h"

#import "GlobalRender.h"
//#import <QuartzCore/QuartzCore.h>

@interface PokemonEXPBar () {
 @private
//  UIImageView  * expBar_;
//  UIImageView  * expBarBackground_;
  UIView  * expBar_;
  UIView  * expBarBackground_;
  NSInteger      exp_;
  NSInteger      expMax_;
}

//@property (nonatomic, retain) UIImageView  * expBar;
//@property (nonatomic, retain) UIImageView  * expBarBackground;
@property (nonatomic, strong) UIView  * expBar;
@property (nonatomic, strong) UIView  * expBarBackground;
@property (nonatomic, assign) NSInteger      exp;
@property (nonatomic, assign) NSInteger      expMax;

@end

@implementation PokemonEXPBar

@synthesize expBar           = expBar_;
@synthesize expBarBackground = expBarBackground_;
@synthesize exp              = exp_;
@synthesize expMax           = expMax_;


- (id)initWithFrame:(CGRect)frame
                exp:(NSInteger)exp
             expMax:(NSInteger)expMax {
  if (self = [self initWithFrame:frame]) {
    exp_    = exp;
    expMax_ = expMax;
    
    CGRect expBarFrame = CGRectMake(0.f, 0.f, frame.size.width * exp / expMax, 6.f);
    [self.expBar setFrame:expBarFrame];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    UIImageView * expBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, 6.f)];
    self.expBarBackground = expBarBackground;
    //[self.expBarBackground setContentMode:UIViewContentModeScaleAspectFit];
    //[self.expBarBackground setImage:[UIImage imageNamed:@"PokemonExpBarBackground.png"]];
    [self.expBarBackground setBackgroundColor:[GlobalRender colorGray]];
//    [self.expBarBackground.layer setCornerRadius:3.f];
    [self addSubview:self.expBarBackground];
    
    UIImageView * expBar = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.expBar = expBar;
    //[self.expBar setContentMode:UIViewContentModeScaleAspectFit];
    //[self.expBar setImage:[UIImage imageNamed:@"PokemonExpBar.png"]];
    [self.expBar setBackgroundColor:[GlobalRender colorBlue]];
//    [self.expBarBackground.layer setCornerRadius:3.f];
    [self.expBarBackground addSubview:self.expBar];
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

- (void)updateExpBarWithExp:(NSInteger)exp {
  self.exp = exp;
  CGRect hpBarFrame = self.expBar.frame;
  hpBarFrame.size.width = self.frame.size.width * self.exp / self.expMax;
  [UIView animateWithDuration:1.f
                        delay:0.f
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     [self.expBar setFrame:hpBarFrame];
                   }
                   completion:nil];
}

- (void)updateExpBarWithExpMax:(NSInteger)expMax {
  self.expMax = expMax;
}

- (void)updateExpBarWithExp:(NSInteger)exp
                     expMax:(NSInteger)expMax {
  self.expMax = expMax > 0 ? expMax : -expMax;
  self.exp    = exp < expMax ? exp : expMax;
  CGRect expBarFrame = CGRectMake(0.f, 0.f, self.frame.size.width * self.exp / self.expMax, 6.f);
  [self.expBar setFrame:expBarFrame];
}

@end
