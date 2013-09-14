//
//  PokemonMoveView.m
//  iPokeMon
//
//  Created by Kaijie Yu on 2/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "PokemonMoveView.h"

#import "GlobalRender.h"

@interface PokemonMoveView () {
 @private
  id <PokemonMoveViewDelegate> __weak delegate_;
  UILabel  * type1_;
  UILabel  * name_;
  UILabel  * pp_;
  UIButton * viewButton_;
}

@property (nonatomic, weak) id <PokemonMoveViewDelegate> delegate;
@property (nonatomic, strong) UILabel  * type1;
@property (nonatomic, strong) UILabel  * name;
@property (nonatomic, strong) UILabel  * pp;
@property (nonatomic, strong) UIButton * viewButton;

@end

@implementation PokemonMoveView

@synthesize delegate   = delegate_;

@synthesize name       = name_;
@synthesize type1      = type1_;
@synthesize pp         = pp_;
@synthesize viewButton = viewButton_;


- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    CGFloat const typeWidth   = 64.f;
    CGFloat const labelHeight = frame.size.height - 10.f;
    
    CGRect  const type1Frame  = CGRectMake(10.f, 5.f, typeWidth, labelHeight);
    CGRect  const nameFrame   = CGRectMake(10.f + typeWidth, 5.f, frame.size.width - typeWidth - 100.f, labelHeight);
    CGRect  const ppFrame     = CGRectMake(nameFrame.origin.x + nameFrame.size.width, 5.f, 60.f, labelHeight);
    
    type1_ = [[UILabel alloc] initWithFrame:type1Frame];
    [type1_ setBackgroundColor:[UIColor clearColor]];
    [type1_ setTextColor:[GlobalRender textColorNormal]];
    [type1_ setFont:[GlobalRender textFontBoldInSizeOf:12.f]];
    [type1_ setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:type1_];
    
    name_ = [[UILabel alloc] initWithFrame:nameFrame];
    [name_ setBackgroundColor:[UIColor clearColor]];
    [name_ setTextColor:[GlobalRender textColorOrange]];
    [name_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [self addSubview:name_];
    
    pp_ = [[UILabel alloc] initWithFrame:ppFrame];
    [pp_ setBackgroundColor:[UIColor clearColor]];
    [pp_ setTextAlignment:NSTextAlignmentRight];
    [pp_ setTextColor:[GlobalRender textColorTitleWhite]];
    [pp_ setFont:[GlobalRender textFontBoldInSizeOf:16.f]];
    [self addSubview:pp_];
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
                             type:(NSString *)type
                               pp:(NSString *)pp
                         delegate:(id<PokemonMoveViewDelegate>)delegate
                              tag:(NSInteger)tag
                              odd:(BOOL)odd {
  [self.name  setText:KYResourceLocalizedString(name, nil)];
  [self.type1 setText:KYResourceLocalizedString(type, nil)];
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
                   action:@selector(loadMoveDetailView:)
         forControlEvents:UIControlEventTouchUpInside];
    self.viewButton = viewButton;
    [self addSubview:self.viewButton];
  }
}

// toggle |viewButton_|
- (void)setButtonEnabled:(BOOL)enabled {
  [self.viewButton setEnabled:enabled];
}

@end
