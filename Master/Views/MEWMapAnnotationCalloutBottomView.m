//
//  MEWMapAnnotationCalloutBottomView.m
//  iPokeMon
//
//  Created by Kaijie Yu on 5/23/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "MEWMapAnnotationCalloutBottomView.h"

@implementation MEWMapAnnotationCalloutBottomView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  CGFloat arrowHeight = 5.f;
  CGFloat arrowWidth  = 10.f;
  CGFloat lineHeight = rect.size.height - arrowHeight;
  CGFloat lineWidth  = rect.size.width;
  UIBezierPath * path = [UIBezierPath bezierPath];
  // Set the starting point of the shape.
  [path moveToPoint:CGPointMake(0.f, 0.f)]; // a
  
  // Draw the lines
  //
  // a------------------b
  // |                  |
  // g-------f\/d-------c
  //          e
  //
  [path addLineToPoint:CGPointMake(lineWidth, 0.f)];                             // b
  [path addLineToPoint:CGPointMake(lineWidth, lineHeight)];                      // c
  [path addLineToPoint:CGPointMake((lineWidth + arrowWidth) / 2.f, lineHeight)]; // d
  [path addLineToPoint:CGPointMake(lineWidth / 2.f, lineHeight + arrowHeight)];  // e
  [path addLineToPoint:CGPointMake((lineWidth - arrowWidth) / 2.f, lineHeight)]; // f
  [path addLineToPoint:CGPointMake(0.f, lineHeight)];                            // g
  [path closePath];
  
  [[UIColor colorWithWhite:0.f alpha:.8f] setFill];
  [path fill];
  path = nil;
}

@end
