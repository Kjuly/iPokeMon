//
//  MEWMapAnnotationView.m
//  Mew
//
//  Created by Kaijie Yu on 5/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MEWMapAnnotationView.h"

#import <QuartzCore/QuartzCore.h>

@interface MEWMapAnnotationView () {
 @private
  UIButton * placeButton_;
}

@property (nonatomic, retain) UIButton * placeButton;

@end

@implementation MEWMapAnnotationView

@synthesize placeButton = placeButton_;

- (void)dealloc {
  self.placeButton = nil;
  [super dealloc];
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
    CGRect frame = self.frame;
    frame.size = CGSizeMake(kMapAnnotationSize, kMapAnnotationSize);
    [self setFrame:frame];
    [self setBackgroundColor:[UIColor clearColor]];
    
    // button
    CGFloat margin = (kMapAnnotationSize - kMapAnnotationImageSize) / 2.f;
    CGRect buttonFrame = CGRectMake(margin, margin, kMapAnnotationImageSize, kMapAnnotationImageSize);
    placeButton_ = [[UIButton alloc] initWithFrame:buttonFrame];
    [placeButton_.imageView.layer setCornerRadius:(kMapAnnotationImageSize / 2.f)];
    [self addSubview:placeButton_];
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  // Drawing code
  [[UIColor colorWithWhite:1.f alpha:.8f] setFill];
  [[UIBezierPath bezierPathWithOvalInRect:rect] fill];
  
  [[UIColor colorWithWhite:0.f alpha:.9f] setFill];
  CGFloat margin = (kMapAnnotationSize - kMapAnnotationImageSize) / 2.f;
  CGRect foregroundRect = rect;
  foregroundRect.origin.x    += margin;
  foregroundRect.origin.y    += margin;
  foregroundRect.size.width  -= margin * 2;
  foregroundRect.size.height -= margin * 2;
  [[UIBezierPath bezierPathWithOvalInRect:foregroundRect] fill];
}

//#pragma mark - Overwrited Methods of MKAnnotationView
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//  [super setSelected:selected animated:animated];
//  
//  
//}

#pragma mark - Public Methods

- (void)setPlaceImage:(UIImage *)placeImage {
  [placeButton_ setImage:placeImage forState:UIControlStateNormal];
}

@end
