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
  UIImageView  * hpBar_;
  UIImageView  * hpBarBackground_;
  NSInteger      hpMax_;
}

@property (nonatomic, retain) UIImageView  * hpBar;
@property (nonatomic, retain) UIImageView  * hpBarBackground;
@property (nonatomic, assign) NSInteger      hpMax;

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
    
    UIImageView * hpBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, 13.f)];
    self.hpBarBackground = hpBarBackground;
    [hpBarBackground release];
    [self.hpBarBackground setContentMode:UIViewContentModeScaleAspectFit];
    [self.hpBarBackground setImage:[UIImage imageNamed:@"PokemonHPBarBackground.png"]];
    [self addSubview:self.hpBarBackground];
    
    CGRect hpBarFrame = CGRectMake(0.f, 0.f, frame.size.width * hp / hpMax, 13.f);
    UIImageView * hpBar = [[UIImageView alloc] initWithFrame:hpBarFrame];
    self.hpBar = hpBar;
    [hpBar release];
    [self.hpBar setContentMode:UIViewContentModeScaleAspectFit];
    [self.hpBar setImage:[UIImage imageNamed:@"PokemonHPBar.png"]];
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
