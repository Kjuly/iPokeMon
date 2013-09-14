//
//  PokemonHPBar.m
//  iPokeMon
//
//  Created by Kaijie Yu on 3/7/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonHPBar.h"

#import "GlobalRender.h"
//#import <QuartzCore/QuartzCore.h>


@interface PokemonHPBar () {
 @private
//  UIImageView  * hpBar_;
//  UIImageView  * hpBarBackground_;
  UIView       * hpBar_;
//  UIView       * hpBarBackground_;
  NSInteger      hp_;
  NSInteger      hpMax_;
}

//@property (nonatomic, retain) UIImageView  * hpBar;
//@property (nonatomic, retain) UIImageView  * hpBarBackground;
@property (nonatomic, strong) UIView  * hpBar;
//@property (nonatomic, retain) UIView  * hpBarBackground;
@property (nonatomic, assign) NSInteger      hp;
@property (nonatomic, assign) NSInteger      hpMax;

@end


@implementation PokemonHPBar

@synthesize hpBar           = hpBar_;
//@synthesize hpBarBackground = hpBarBackground_;
@synthesize hp              = hp_;
@synthesize hpMax           = hpMax_;


- (id)initWithFrame:(CGRect)frame
                 HP:(NSInteger)hp
              HPMax:(NSInteger)hpMax {
  if (self = [self initWithFrame:frame]) {
    hp_    = hp;
    hpMax_ = hpMax;
    
    CGRect hpBarFrame = CGRectMake(0.f, 0.f, frame.size.width * hp / hpMax, frame.size.height);
    [self.hpBar setFrame:hpBarFrame];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    /*UIImageView * hpBarBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, frame.size.width, 13.f)];
    self.hpBarBackground = hpBarBackground;
    [hpBarBackground release];
    //[self.hpBarBackground setContentMode:UIViewContentModeScaleAspectFit];
    //[self.hpBarBackground setImage:[UIImage imageNamed:@"PokemonHPBarBackground.png"]];
    [self.hpBarBackground setBackgroundColor:[GlobalRender colorGray]];
    [self.hpBarBackground.layer setCornerRadius:5.f];
    [self addSubview:self.hpBarBackground];
    
    
    UIImageView * hpBar = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.hpBar = hpBar;
    [hpBar release];
    //[self.hpBar setContentMode:UIViewContentModeScaleAspectFit];
    //[self.hpBar setImage:[UIImage imageNamed:@"PokemonHPBar.png"]];
    [self.hpBar setBackgroundColor:[GlobalRender colorOrange]];
    [self.hpBar.layer setCornerRadius:5.f];
    [self.hpBarBackground addSubview:self.hpBar];*/
    
    UIView * hpBar = [[UIView alloc] initWithFrame:CGRectZero];
    self.hpBar = hpBar;
    [self.hpBar setBackgroundColor:[GlobalRender colorOrange]];
    [self addSubview:self.hpBar];
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  // Drawing code
}
*/

- (NSInteger)hp {
  return hp_;
}

- (NSInteger)hpMax {
  return hpMax_;
}

- (void)updateHPBarWithHP:(NSInteger)hp {
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

- (void)updateHpBarWithHPMax:(NSInteger)hpMax {
  self.hpMax = hpMax;
}

- (void)updateHPBarWithHP:(NSInteger)hp
                    HPMax:(NSInteger)hpMax {
  self.hpMax = hpMax > 0 ? hpMax : -hpMax;
  self.hp    = hp < hpMax ? hp : hpMax;
  CGRect hpBarFrame = CGRectMake(0.f, 0.f, self.frame.size.width * self.hp / self.hpMax, self.frame.size.height);
  [self.hpBar setFrame:hpBarFrame];
}

@end
