//
//  PokemonHPBar.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonHPBar.h"

#import "GlobalRender.h"
#import <QuartzCore/QuartzCore.h>


@interface PokemonHPBar () {
 @private
//  UIImageView  * hpBar_;
//  UIImageView  * hpBarBackground_;
  UIView       * hpBar_;
  UIView       * hpBarBackground_;
  NSInteger      hp_;
  NSInteger      hpMax_;
}

//@property (nonatomic, retain) UIImageView  * hpBar;
//@property (nonatomic, retain) UIImageView  * hpBarBackground;
@property (nonatomic, retain) UIView  * hpBar;
@property (nonatomic, retain) UIView  * hpBarBackground;
@property (nonatomic, assign) NSInteger      hp;
@property (nonatomic, assign) NSInteger      hpMax;

@end


@implementation PokemonHPBar

@synthesize hpBar           = hpBar_;
@synthesize hpBarBackground = hpBarBackground_;
@synthesize hp              = hp_;
@synthesize hpMax           = hpMax_;

- (void)dealloc
{
  self.hpBar           = nil;
  self.hpBarBackground = nil;
  
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame HP:(NSInteger)hp HPMax:(NSInteger)hpMax
{
  if (self = [self initWithFrame:frame]) {
    hp_    = hp;
    hpMax_ = hpMax;
    
    UIImageView * hpBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, 13.f)];
    self.hpBarBackground = hpBarBackground;
    [hpBarBackground release];
//    [self.hpBarBackground setContentMode:UIViewContentModeScaleAspectFit];
//    [self.hpBarBackground setImage:[UIImage imageNamed:@"PokemonHPBarBackground.png"]];
    [self.hpBarBackground setBackgroundColor:[GlobalRender colorGray]];
    [self.hpBarBackground.layer setCornerRadius:5.f];
    [self addSubview:self.hpBarBackground];
    
    CGRect hpBarFrame = CGRectMake(0.f, 0.f, frame.size.width * hp / hpMax, 13.f);
    UIImageView * hpBar = [[UIImageView alloc] initWithFrame:hpBarFrame];
    self.hpBar = hpBar;
    [hpBar release];
//    [self.hpBar setContentMode:UIViewContentModeScaleAspectFit];
//    [self.hpBar setImage:[UIImage imageNamed:@"PokemonHPBar.png"]];
    [self.hpBar setBackgroundColor:[GlobalRender colorOrange]];
    [self.hpBar.layer setCornerRadius:5.f];
    [self.hpBarBackground addSubview:self.hpBar];
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

- (NSInteger)hp {
  return hp_;
}

- (NSInteger)hpMax {
  return hpMax_;
}

- (void)updateHPBarWithHP:(NSInteger)hp
{
  self.hp = hp;
  CGRect hpBarFrame = self.hpBar.frame;
  hpBarFrame.size.width = self.frame.size.width * self.hp / self.hpMax;
  [UIView animateWithDuration:1.f
                        delay:.5f
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     [self.hpBar setFrame:hpBarFrame];
                   }
                   completion:nil];
}

- (void)updateHpBarWithHPMax:(NSInteger)hpMax
{
  self.hpMax = hpMax;
}

@end
