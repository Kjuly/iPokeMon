//
//  MEWMapAnnotationView.m
//  Mew
//
//  Created by Kaijie Yu on 5/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MEWMapAnnotationView.h"

#import "MEWMapAnnotation.h"
#import <QuartzCore/QuartzCore.h>

@interface MEWMapAnnotationView () {
 @private
  UIImage * image_;
}

@property (nonatomic, retain) UIImage * image;

@end

@implementation MEWMapAnnotationView

@synthesize image = image_;

- (void)dealloc {
  self.image = nil;
  [super dealloc];
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
    CGRect frame = self.frame;
    frame.size = CGSizeMake(kMapAnnotationSize, kMapAnnotationSize);
    [self setFrame:frame];
    [self setBackgroundColor:[UIColor clearColor]];
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
  // background
  [[UIColor colorWithWhite:0.f alpha:.8f] setFill];
  [[UIBezierPath bezierPathWithOvalInRect:rect] fill];
  
  // foreground
//  [[UIColor colorWithWhite:0.f alpha:.9f] setFill];
//  CGFloat viewSize = self.frame.size.width;
//  CGFloat margin = viewSize * .1f;
//  CGRect foregroundRect = rect;
//  foregroundRect.origin.x    += margin;
//  foregroundRect.origin.y    += margin;
//  foregroundRect.size.width  -= margin * 2;
//  foregroundRect.size.height -= margin * 2;
//  [[UIBezierPath bezierPathWithOvalInRect:foregroundRect] fill];
  
  // image
  CGFloat viewSize = self.frame.size.width;
  CGFloat margin = viewSize * .1f;
  viewSize -= margin * 2;
  CGRect imageFrame = CGRectMake(margin, margin, viewSize, viewSize);
  [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:viewSize / 2.f] addClip];
  [self.image drawInRect:imageFrame];
}

//#pragma mark - Overwrited Methods of MKAnnotationView
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//  [super setSelected:selected animated:animated];
//  
//  
//}

#pragma mark - Public Methods

- (void)updateImage {
  NSLog(@"!!!!!!!!!!!!!!!!!!%@", [NSString stringWithFormat:@"%@%@.png",
                @"CN", ((MEWMapAnnotation *)self.annotation).code]);
  self.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png",
                                    @"CN", ((MEWMapAnnotation *)self.annotation).code]];
}

@end
