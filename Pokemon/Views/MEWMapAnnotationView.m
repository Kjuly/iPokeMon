//
//  MEWMapAnnotationView.m
//  Mew
//
//  Created by Kaijie Yu on 5/22/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MEWMapAnnotationView.h"

@implementation MEWMapAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
    CGRect frame = self.frame;
    frame.size = CGSizeMake(44.f, 44.f);
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
- (void)drawRect:(CGRect)rect
{
  // Drawing code
  [[UIColor colorWithWhite:1.f alpha:.5f] setFill];
  [[UIBezierPath bezierPathWithOvalInRect:rect] fill];
  
  [[UIColor colorWithWhite:0.f alpha:.9f] setFill];
  CGFloat margin = 5.f;
  CGRect foregroundRect = rect;
  foregroundRect.origin.x    += margin;
  foregroundRect.origin.y    += margin;
  foregroundRect.size.width  -= margin * 2;
  foregroundRect.size.height -= margin * 2;
  [[UIBezierPath bezierPathWithOvalInRect:foregroundRect] fill];
}

@end
