//
//  MoveDetailRoundView.m
//  iPokeMon
//
//  Created by Kaijie Yu on 5/20/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MoveDetailRoundView.h"

#import "GlobalRender.h"

@interface MoveDetailRoundView () {
 @private
  UILabel * title_;
  UILabel * type_;
  UILabel * pp_;
  UILabel * description_;
}

@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * type;
@property (nonatomic, strong) UILabel * pp;
@property (nonatomic, strong) UILabel * description;

@end


@implementation MoveDetailRoundView

@synthesize title       = title_;
@synthesize type        = type_;
@synthesize pp          = pp_;
@synthesize description = description_;


- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
    
    // subviews
    // constants
    CGFloat viewSize    = frame.size.width;
    CGFloat margin      = 50.f;
    CGFloat labelHeight = 32.f;
    CGFloat titleWidth  = 100.f;
    CGFloat ppWidth     = 80.f;
    CGFloat typeWidth   = 100.f;
    
    CGRect titleFrame = CGRectMake((viewSize - titleWidth) / 2.f, margin, titleWidth, labelHeight);
    CGRect ppFrame    = CGRectMake((viewSize - ppWidth) / 2.f, margin + labelHeight, ppWidth, labelHeight);
    CGRect typeFrame  = CGRectMake((viewSize - typeWidth) / 2.f, viewSize - 100.f, typeWidth, labelHeight);
    
    title_ = [[UILabel alloc] initWithFrame:titleFrame];
    [title_ setBackgroundColor:[UIColor clearColor]];
    [title_ setTextColor:[GlobalRender textColorTitleWhite]];
    [title_ setFont:[GlobalRender textFontBoldInSizeOf:24.f]];
    [title_ setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:title_];
    
    pp_ = [[UILabel alloc] initWithFrame:ppFrame];
    [pp_ setBackgroundColor:[UIColor clearColor]];
    [pp_ setTextColor:[GlobalRender textColorOrange]];
    [pp_ setFont:[GlobalRender textFontBoldInSizeOf:18.f]];
    [pp_ setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:pp_];
    
    description_ = [[UILabel alloc] init];
    [description_ setBackgroundColor:[UIColor clearColor]];
    [description_ setTextColor:[GlobalRender textColorNormal]];
    [description_ setFont:[GlobalRender textFontNormalInSizeOf:16.f]];
    [description_ setNumberOfLines:0];
    [description_ setLineBreakMode:NSLineBreakByWordWrapping];
    [self addSubview:description_];
    
    type_ = [[UILabel alloc] initWithFrame:typeFrame];
    [type_ setBackgroundColor:[UIColor clearColor]];
    [type_ setTextColor:[GlobalRender textColorGolden]];
    [type_ setFont:[GlobalRender textFontBoldInSizeOf:18.f]];
    [type_ setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:type_];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
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

// configure move detail with content
- (void)configureMoveDetailWithName:(NSString *)name
                               type:(NSString *)type
                                 pp:(NSString *)pp
                        description:(NSString *)description
{
  [self.title setText:KYResourceLocalizedString(name, nil)];
  [self.type setText:KYResourceLocalizedString(type, nil)];
  [self.pp setText:pp];
  CGFloat viewSize         = self.frame.size.width;
  CGFloat margin           = 50.f;
  CGFloat labelHeight      = 32.f;
  CGFloat descriptionWidth = 200.f;
  CGRect descriptionFrame = CGRectMake((viewSize - descriptionWidth) / 2.f,
                                       margin + labelHeight * 2,
                                       descriptionWidth,
                                       labelHeight);
  [self.description setFrame:descriptionFrame];
  [self.description setText:KYResourceLocalizedString(description, nil)];
  [self.description sizeToFit];
}

// toggle content between shown & hidden
- (void)setContentHidden:(BOOL)hidden
{
  CGFloat alpha = hidden ? 0.f : 1.f;
  [self.title setAlpha:alpha];
  [self.pp setAlpha:alpha];
  [self.description setAlpha:alpha];
}

@end
