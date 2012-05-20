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
  UIButton * viewButton_;
  UILabel  * pp_;
}

@property (nonatomic, assign) id <GameMenuMoveUnitViewDelegate> delegate;
@property (nonatomic, retain) UIButton * viewButton;
@property (nonatomic, retain) UILabel  * pp;

@end

@implementation GameMenuMoveUnitView

@synthesize delegate = delegate_;

@synthesize viewButton = viewButton_;
@synthesize pp         = pp_;

-(void)dealloc {
  self.delegate   = nil;
  self.viewButton = nil;
  self.pp         = nil;
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    CGFloat const frameHeight = frame.size.height;
    CGFloat const frameWidth  = frame.size.width;
//    CGFloat const labelHeight = 32.f;
    CGFloat const buttonSize  = 64.f;
    
//    CGRect  const ppFrame     = CGRectMake(nameFrame.origin.x, 20.f + labelHeight, 60.f, labelHeight);
    CGRect  const viewButtonFrame = CGRectMake((frameWidth - buttonSize) / 2.f, (frameHeight - buttonSize) / 2.f, buttonSize, buttonSize);
    
    viewButton_ = [[UIButton alloc] initWithFrame:viewButtonFrame];
    [viewButton_ setBackgroundColor:[UIColor clearColor]];
    [viewButton_.titleLabel setTextAlignment:UITextAlignmentCenter];
    [viewButton_ setBackgroundImage:[UIImage imageNamed:@"IconMoveBackground.png"]
                           forState:UIControlStateNormal];
//    [viewButton_ setImage:[UIImage imageNamed:@"IconMoveBackground.png"]
//                 forState:UIControlStateNormal];
    [viewButton_ addTarget:self.delegate
                    action:@selector(showDetail:)
          forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:viewButton_];
    
//    pp_ = [[UILabel alloc] initWithFrame:ppFrame];
//    [pp_ setBackgroundColor:[UIColor clearColor]];
//    [pp_ setTextAlignment:UITextAlignmentLeft];
//    [pp_ setTextColor:[GlobalRender textColorOrange]];
//    [pp_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
//    [self addSubview:pp_];
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
                               pp:(NSString *)pp
                         delegate:(id<GameMenuMoveUnitViewDelegate>)delegate
                              tag:(NSInteger)tag {
  NSString * localizedName = NSLocalizedString(name, nil);
  if (! [self.viewButton.titleLabel.text isEqualToString:localizedName]) {
    CGFloat fontSize;
    if (localizedName.length <= 7)       fontSize = 12.f;
    else if (localizedName.length <= 12) fontSize = 8.f;
    else                                 fontSize = 6.f;
    [self.viewButton.titleLabel setFont:[GlobalRender textFontBoldItalicInSizeOf:fontSize]];
    [self.viewButton setTitle:localizedName forState:UIControlStateNormal];
  }
  
//  [self.pp setText:pp];
  
  self.delegate = delegate;
  [self.viewButton setTag:tag];
  [self.viewButton setEnabled:YES];
}

// toggle |viewButton_|
- (void)setButtonEnabled:(BOOL)enabled {
//  [self.viewButton setEnabled:enabled];
  
  // Change Text color if needed
  if (enabled) {
    [self.viewButton setEnabled:YES];
    [self.viewButton.titleLabel setTextColor:[GlobalRender textColorTitleWhite]];
//    [self.pp setTextColor:[GlobalRender textColorOrange]];
  } else {
    [self.viewButton setEnabled:NO];
    [self.viewButton.titleLabel setTextColor:[GlobalRender textColorDisabled]];
//    [self.pp setTextColor:[GlobalRender textColorDisabled]];
  }
}

@end
