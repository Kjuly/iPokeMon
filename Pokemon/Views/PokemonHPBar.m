//
//  PokemonHPBar.m
//  Pokemon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonHPBar.h"


@interface PokemonHPBar () {
 @private
  UIView  * hpBar_;
  UIView  * hpBarBackground_;
  NSInteger hpMax_;
}

@property (nonatomic, retain) UIView  * hpBar;
@property (nonatomic, retain) UIView  * hpBarBackground;
@property (nonatomic, assign) NSInteger hpMax;

@end


@implementation PokemonHPBar

@synthesize hpBar           = hpBar_;
@synthesize hpBarBackground = hpBarBackground_;
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
    hpMax_ = hpMax;
    
    UIView * hpBarBackground = [[UIView alloc] initWithFrame:frame];
    self.hpBarBackground = hpBarBackground;
    [hpBarBackground release];
    [self addSubview:self.hpBarBackground];
    
    CGRect hpBarFrame = CGRectMake(0.f, 0.f, frame.size.width * hp / hpMax, frame.size.height);
    UIView * hpBar = [[UIView alloc] initWithFrame:hpBarFrame];
    self.hpBar = hpBar;
    [hpBar release];
    [self addSubview:self.hpBar];
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

- (void)updateHPBarWithHP:(NSInteger)hp
{
  CGRect hpBarFrame = self.hpBar.frame;
  hpBarFrame.size.width = self.frame.size.width * hp / self.hpMax;
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     [self.hpBar setFrame:hpBarFrame];
                   }
                   completion:nil];
}

@end
