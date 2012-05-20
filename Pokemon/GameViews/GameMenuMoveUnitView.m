//
//  GameMenuMoveUnitView.m
//  Pokemon
//
//  Created by Kaijie Yu on 2/27/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "GameMenuMoveUnitView.h"

#import "GlobalRender.h"

@interface GameMenuMoveUnitView () {
@private
  id <GameMenuMoveUnitViewDelegate> delegate_;
  UILabel     * type1_;
  UILabel     * name_;
  UIImageView * icon_;
  UILabel     * pp_;
  UIButton    * viewButton_;
}

@property (nonatomic, assign) id <GameMenuMoveUnitViewDelegate> delegate;
@property (nonatomic, retain) UILabel     * type1;
@property (nonatomic, retain) UILabel     * name;
@property (nonatomic, retain) UIImageView * icon;
@property (nonatomic, retain) UILabel     * pp;
@property (nonatomic, retain) UIButton    * viewButton;

@end

@implementation GameMenuMoveUnitView

@synthesize delegate = delegate_;

@synthesize name  = name_;
@synthesize icon  = icon_;
@synthesize type1 = type1_;
@synthesize pp    = pp_;
@synthesize viewButton = viewButton_;

-(void)dealloc {
  self.delegate   = nil;
  self.name       = nil;
  self.icon       = nil;
  self.type1      = nil;
  self.pp         = nil;
  self.viewButton = nil;
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    CGFloat const frameHeight = frame.size.height;
    CGFloat const frameWidth  = frame.size.width;
    CGFloat const typeWidth   = 60.f;
    CGFloat const labelHeight = 32.f;
    CGFloat const buttonSize  = 64.f;
    
    CGRect  const type1Frame  = CGRectMake(10.f, 20.f, typeWidth, labelHeight);
    CGRect  const nameFrame   = CGRectMake(10.f, 20.f, frame.size.width - 20.f, labelHeight);
    CGRect  const iconFrame   = CGRectMake((frameWidth - buttonSize) / 2.f, (frameHeight - buttonSize) / 2.f, buttonSize, buttonSize);
    CGRect  const ppFrame     = CGRectMake(nameFrame.origin.x, 20.f + labelHeight, 60.f, labelHeight);
    CGRect  const viewButtonFrame = CGRectMake((frameWidth - buttonSize) / 2.f, (frameHeight - buttonSize) / 2.f, buttonSize, buttonSize);
    
    type1_ = [[UILabel alloc] initWithFrame:type1Frame];
//    [type1_ setBackgroundColor:[UIColor clearColor]];
//    [type1_ setTextAlignment:UITextAlignmentRight];
//    [type1_ setTextColor:[GlobalRender textColorNormal]];
//    [type1_ setFont:[GlobalRender textFontBoldInSizeOf:12.f]];
//    [self addSubview:type1_];
    
    name_ = [[UILabel alloc] initWithFrame:nameFrame];
    [name_ setBackgroundColor:[UIColor clearColor]];
    [name_ setTextAlignment:UITextAlignmentLeft];
    [name_ setTextColor:[GlobalRender textColorOrange]];
    [name_ setFont:[GlobalRender textFontBoldInSizeOf:24.f]];
    [self addSubview:name_];
    
//    icon_ = [[UIImageView alloc] initWithFrame:iconFrame];
//    [icon_ setImage:[UIImage imageNamed:@"IconMoveBackground.png"]];
//    [icon_ setAlpha:.8f];
//    [self addSubview:icon_];
    
    pp_ = [[UILabel alloc] initWithFrame:ppFrame];
//    [pp_ setBackgroundColor:[UIColor clearColor]];
//    [pp_ setTextAlignment:UITextAlignmentLeft];
//    [pp_ setTextColor:[GlobalRender textColorOrange]];
//    [pp_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
//    [self addSubview:pp_];
    
    viewButton_ = [[UIButton alloc] initWithFrame:viewButtonFrame];
    [viewButton_ setBackgroundColor:[UIColor clearColor]];
    [viewButton_ setImage:[UIImage imageNamed:@"IconMoveBackground.png"]
                 forState:UIControlStateNormal];
    [self addSubview:viewButton_];
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

#pragma mark - Public Methods

- (void)configureMoveUnitWithName:(NSString *)name
                             icon:(UIImage *)icon
                             type:(NSString *)type
                               pp:(NSString *)pp
                         delegate:(id<GameMenuMoveUnitViewDelegate>)delegate
                              tag:(NSInteger)tag
                              odd:(BOOL)odd {
  NSString * localizedName = NSLocalizedString(name, nil);
  CGFloat fontSize;
  if (localizedName.length <= 7)       fontSize = 12.f;
  else if (localizedName.length <= 12) fontSize = 8.f;
  else                                 fontSize = 6.f;
  [viewButton_.titleLabel setFont:[GlobalRender textFontBoldItalicInSizeOf:fontSize]];
  [self.viewButton setTitle:localizedName forState:UIControlStateNormal];
  [viewButton_.titleLabel setTextAlignment:UITextAlignmentCenter];
//  [self.icon  setImage:icon];
  [self.type1 setText:NSLocalizedString(type, nil)];
  [self.pp    setText:pp];
  
  self.delegate = delegate;
  if (delegate) {
    CGRect viewFrame = self.frame;
    viewFrame.origin.x = 0.f;
    viewFrame.origin.y = 0.f;
    UIButton * viewButton = [[UIButton alloc] initWithFrame:viewFrame];
    if (odd) [viewButton setBackgroundColor:[UIColor colorWithWhite:0.f alpha:.1f]];
    else [viewButton setBackgroundColor:[UIColor clearColor]];
    [viewButton setTag:tag];
    [viewButton setEnabled:YES];
    [viewButton addTarget:self.delegate
                   action:@selector(showDetail:)
         forControlEvents:UIControlEventTouchUpInside];
    self.viewButton = viewButton;
    [viewButton release];
    [self addSubview:self.viewButton];
  }
}

// toggle |viewButton_|
- (void)setButtonEnabled:(BOOL)enabled {
//  [self.viewButton setEnabled:enabled];
  
  // Change Text color if needed
  if (enabled) {
    [self.name setTextColor:[GlobalRender textColorTitleWhite]];
    [self.pp setTextColor:[GlobalRender textColorOrange]];
    [self.viewButton setEnabled:YES];
  } else {
    [self.name setTextColor:[GlobalRender textColorDisabled]];
    [self.pp setTextColor:[GlobalRender textColorDisabled]];
    [self.viewButton setEnabled:NO];
  }
}

@end
