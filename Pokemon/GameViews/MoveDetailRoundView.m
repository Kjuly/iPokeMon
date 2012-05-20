//
//  MoveDetailRoundView.m
//  Mew
//
//  Created by Kaijie Yu on 5/20/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MoveDetailRoundView.h"

#import "GlobalRender.h"

@interface MoveDetailRoundView () {
 @private
  UILabel * title_;
  UILabel * pp_;
  UILabel * description_;
}

@property (nonatomic, retain) UILabel * title;
@property (nonatomic, retain) UILabel * pp;
@property (nonatomic, retain) UILabel * description;

@end

@implementation MoveDetailRoundView

@synthesize title       = title_;
@synthesize pp          = pp_;
@synthesize description = description_;

- (void)dealloc {
  self.title       = nil;
  self.pp          = nil;
  self.description = nil;
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    
    // subviews
    // constants
    CGFloat viewSize         = frame.size.width;
    CGFloat margin           = 30.f;
    CGFloat labelHeight      = 32.f;
    CGFloat titleWidth       = 100.f;
    CGFloat ppWidth          = 80.f;
    
    CGRect titleFrame       = CGRectMake((viewSize - titleWidth) / 2.f, margin, titleWidth, labelHeight);
    CGRect ppFrame          = CGRectMake((viewSize - ppWidth) / 2.f, margin + labelHeight, ppWidth, labelHeight);
    
    title_ = [[UILabel alloc] initWithFrame:titleFrame];
    [title_ setBackgroundColor:[UIColor clearColor]];
    [title_ setTextColor:[GlobalRender textColorTitleWhite]];
    [title_ setFont:[GlobalRender textFontBoldInSizeOf:20.f]];
    [title_ setTextAlignment:UITextAlignmentCenter];
    [self addSubview:title_];
    
    pp_ = [[UILabel alloc] initWithFrame:ppFrame];
    [pp_ setBackgroundColor:[UIColor clearColor]];
    [pp_ setTextColor:[GlobalRender textColorOrange]];
    [pp_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [pp_ setTextAlignment:UITextAlignmentCenter];
    [self addSubview:pp_];
    
    description_ = [[UILabel alloc] init];
    [description_ setBackgroundColor:[UIColor clearColor]];
    [description_ setTextColor:[GlobalRender textColorNormal]];
    [description_ setNumberOfLines:0];
    [description_ setLineBreakMode:UILineBreakModeWordWrap];
    [self addSubview:description_];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  [[UIColor colorWithWhite:1.f alpha:.5f] setFill];
  [[UIBezierPath bezierPathWithOvalInRect:rect] fill];
  
  [[UIColor colorWithWhite:0.f alpha:.9f] setFill];
  CGRect foregroundRect = rect;
  foregroundRect.origin.x    += 10.f;
  foregroundRect.origin.y    += 10.f;
  foregroundRect.size.width  -= 20.f;
  foregroundRect.size.height -= 20.f;
  [[UIBezierPath bezierPathWithOvalInRect:foregroundRect] fill];
}

#pragma mark - Public Methods

- (void)configureMoveDetailWithName:(NSString *)name
                               type:(NSString *)type
                                 pp:(NSString *)pp
                        description:(NSString *)description {
  [self.title setText:NSLocalizedString(name, nil)];
  [self.pp setText:pp];
  CGFloat viewSize         = self.frame.size.width;
  CGFloat margin           = 30.f;
  CGFloat labelHeight      = 32.f;
  CGFloat descriptionWidth = 200.f;
  CGRect descriptionFrame = CGRectMake((viewSize - descriptionWidth) / 2.f,
                                       margin + labelHeight * 2,
                                       descriptionWidth,
                                       labelHeight);
  [self.description setFrame:descriptionFrame];
  [self.description setText:NSLocalizedString(description, nil)];
  [self.description sizeToFit];
}

@end
